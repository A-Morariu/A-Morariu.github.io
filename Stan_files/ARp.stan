data {
    int<lower=0> P;                           // order of the model
    int<lower=0> N;                           // length of TS
    vector[N] returns;                          // name of TS vector 
}

parameters {
    real mu;                                    // mean of TS
    real theta[P];                              // real valued theta vector of length p
    real <lower = 0> sigma;                     // std dev of Gaussian noise 
}

model { 
    // specify priors 
    mu ~ normal(0,4);
    theta ~ normal(0, 2);
    sigma ~ exponential(2);

    // use for loops to set up the likelihood

    for (n in (P+1):N){
        real average = mu;

        for (p in 1:P) 
            average += theta[p] * returns[n - p];

        returns[n] ~ normal(average, sigma);    // mean is the combo of previous P steps in the process 
    }
}
