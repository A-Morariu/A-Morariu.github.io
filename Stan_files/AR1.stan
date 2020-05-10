data {
  int<lower=0> N;               // length of TS
  vector[N] returns;            // name of the vector/column we feed in
}
parameters {
  real theta_0;                 // estimate the mean 
  real theta_1;                 // estimate the first order parameter
  real<lower=0> sigma;          // estimate the std dev of the Gaussian noise
}
model {
    returns[2:N] ~ normal(theta_0 + theta_1 * returns[1:(N-1)], sigma);
    // note: improper/default priors are used here. We specify priors later
}
