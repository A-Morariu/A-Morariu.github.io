data {
  int<lower=0> Q;                               // num previous noise terms
  int<lower=3> T;                               // num observations
  vector[T] returns;                            // observation at time t
}
parameters {
    real mu;                                    // mean of the TS 
    vector[Q] theta;                            // model coefficients
    real<lower = 0> sigma;                      // std dev of the noise 
}
transformed parameters {
    vector[T] epsilon;                          // vector of noise at time t, to be used to estimate sigma

    for (t in 1:T) {
        epsilon[t] = returns[t] - mu;
        for (q in 1:min(t - 1, Q))
            epsilon[t] = epsilon[t] - theta[q] * epsilon[t - q];
  }
}
model {
    // helpful quantity
    vector[T] previous_steps;

    // priors 
    mu ~ cauchy(0, 2.5);
    theta ~ cauchy(0, 2.5);
    sigma ~ cauchy(0, 2.5);

  // likelihood
  for (t in 1:T) {
    previous_steps[t] = mu;
    
    for (q in 1:min(t - 1, Q))
        previous_steps[t] = previous_steps[t] + theta[q] * epsilon[t - q];
  }

  returns ~ normal(previous_steps, sigma);
}
