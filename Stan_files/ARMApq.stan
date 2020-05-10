data {
    // order of model
    int<lower = 0> P;                                   // AR part
    int<lower = 0> Q;                                   // MA part

    // data
    int<lower = 1> T;                                   // length of TS
    vector[T] returns;                                  // the TS
}
parameters {
    real mu;                                            // mean
    vector[P] phi;                                      // AR parameters
    vector[Q] theta;                                    // MA parameters
    real<lower = 0> sigma;                              // noise scale
}
model {
    // useful parameters and initialization
    vector[T] previous_step;                          // the moving average
    vector[T] errors;                                 // the calucated noise
    for(i in 1:max(P,Q)){
        previous_step[i] = mu;
        errors[i] = 0;
    }

    // priors
    mu ~ cauchy(0, 2.5);   
    phi ~ normal(0, 1);                                 // keep it fairly tight since we want it to be causal
    theta ~ normal(0,2);
    sigma ~ exponential(2.01);                          // define on positive support

    // likelihood
    for (t in (max(P,Q)+1):T){
        // compute the moving average/ prediction
        for(p in 1:P){
            previous_step[t] = mu + phi[p] * returns[t - p]; 
        }
        errors[t] = returns[t] - previous_step[t];
        
        // compute the error - note index of errors is shifted by P due to AR part
        for(q in 1:min(t-1, Q)){
            previous_step[t] = previous_step[t] + theta[q] * errors[t-q];
            errors[t] = errors[t] - theta[q] * errors[t - q];
        }
        
        returns ~ normal(previous_step, sigma);
    }
}
