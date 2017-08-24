function Xout = bernoulli_optimalModel_updateSufficientStats(d, X)
Xout = X + repmat([1 d], [size(X,1) 1]);
end
