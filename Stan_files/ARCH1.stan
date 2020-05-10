data{
    int<lower = 0> N;                           // length of time series
    vector[N] returns;                          // the time series
}

parameters{
    real mu;                                    // a constant - average return
    real<lower = 0> alpha_0;                    // parameter of ARCH portion - intercept of noise
    real<lower = 0, upper = 1> alpha_1;         // another parameter of ARCH - slope of noise
    real<lower = 0> sigma;
}

model{
    // priors
    mu ~ normal(0,2);
    alpha_0 ~ normal(0, 2);
    alpha_1 ~ normal(0,1);
    sigma ~ normal(0,2);

    // likelihood - can be vectorized instead of a loop
    for(n in 2:N)
        returns[n] ~ normal(mu, sqrt(alpha_0 + alpha_1 * sigma * pow(returns[n-1] - mu,2)));
}
