data {
    int<lower = 0> P;                       // AR Order
    int<lower = 0> Q;                       // MA Order
    int<lower=1> T;                         // num observations
    real y[T];                              // observed outputs
}
parameters {
    real mu;                                // mean coeff
    vector[P] phi;                          // autoregression coeff
    vector[Q] theta;                        // moving avg coeff
    real<lower=0> sigma;                    // noise scale
}
model {
    vector[T] nu;                           // prediction for time t
    vector[T] err;                          // error for time t

    // initialization
    for(t in 1:max(P,Q)){
        nu[t] = mu + phi[t] * mu;           // assume err[0] == 0
        err[t] = y[t] - nu[t];
    }

    for (t in (max(P,Q)+1):T) {
        nu[t] = mu;
        // 
        // AR component
        for(p in 1:P){
            nu[t] = nu[t] + phi[p] * y[t-p];

        }
        // MA component
        for(q in 1:Q){
            nu[t] = nu[t] + theta[q] * y[t-q];
        }
        //
        // error computation 
        err[t] = y[t] - nu[t];
    }

    // priors
    mu ~ normal(0, 10);        
    phi ~ normal(0, 2);
    theta ~ normal(0, 2);
    sigma ~ cauchy(0, 5);
    
    // likelihood
    err ~ normal(0, sigma);    
}
