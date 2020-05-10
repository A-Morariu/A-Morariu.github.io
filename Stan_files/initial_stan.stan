data{
    int<lower = 1> N; // number of observations (1000)
    int<lower = 1> preds; // number of predictors (2)
    matrix[N, preds+1] data_matrix; // now you define the matrix that you will feed into Stan
}

parameters{
    vector[preds] betas; // vector of the betas (of the posterior)
    real<lower = 0> sigma; // the standard deviation of the poster
}

model{
    // priors 
    betas ~ normal(0,1);
    sigma ~ exponential(2.01);

    // likelihoods 
    data_matrix[, 3] ~ normal(data_matrix[, 1:2] * betas, sigma);
}
