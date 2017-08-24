function lik  = bernoulli_optimalModel_likelihood(d, X)
lik = d * X(:,2)./X(:,1) + (1-d) * (X(:,1)-X(:,2))./X(:,1);
end
