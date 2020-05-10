data {
    int<lower = 0> Q;                                   // order of model 
    int<lower = 1> T;                                   // length of time series
    vector[T] returns;                                  // time series vector
}
parameters {
    real mu;                                            // mean of the time series
    real theta[Q];                                      // the coefficients
    real<lower = 0> sigma;                              // noise scale parameter
}
model {
    // useful parameters
    vector[T] previous_steps;                           // prediction at time t (the moving average)
    vector[T] error;                                    // noise at each step

    // priors 
    mu ~ cauchy(0, 2.5);
    theta ~ normal(0, 2);
    sigma ~ exponential(2.01);

    // likelihood
    for(t in 1:T){
        previous_steps[t] = mu;
        error[t] = returns[t] - mu;

        for(q in 1:min(t-1, Q)){
            previous_steps[t] = previous_steps[t] + theta[q] * error[t-q];
            error[t] = error[t] - theta[q] * error[t-q];
        }
    }

    returns ~ normal(previous_steps, sigma);
}
