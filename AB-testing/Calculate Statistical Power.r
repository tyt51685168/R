sigma <- 15    # theoretical standard deviation
mu0   <- 100   # expected value under H0
mu1   <- 130   # expected value under H1
alpha <- 0.05  # probability of type I error

# critical value for a level alpha test
crit <- qnorm(1-alpha, mu0, sigma)

# power: probability for values > critical value under H1
(pow <- pnorm(crit, mu1, sigma, lower.tail=FALSE))
[1] 0.63876

# probability for type II error: 1 - power
(beta <- 1-pow)
[1] 0.36124
