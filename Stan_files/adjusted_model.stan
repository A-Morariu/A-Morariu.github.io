data{
  // dimensions of regression matrix
  int<lower = 1> N; // number of observations
  int<lower = 1> K; // number of predictors 
  
  // regression variables
  real y[N]; // the response 
  matrix[N,K] data_matrix;
}

parameters{
  vector[K] betas;
  real<lower = 0> sigma;
}

model{
  // priors 
  betas ~ normal(0,1);
  sigma ~ cauchy(0,2.5);
  
  // likelihood
  y ~ normal(data_matrix*betas, sigma);
}
