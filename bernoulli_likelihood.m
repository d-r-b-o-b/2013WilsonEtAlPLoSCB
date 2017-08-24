function lik    = bernoulli_likelihood(d, a, l)
lik = d * a./(l) + (1-d) * (1-a./(l));
end
