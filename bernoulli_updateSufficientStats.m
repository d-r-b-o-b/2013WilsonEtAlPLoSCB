function Xout    = bernoulli_updateSufficientStats(d, X, l)
Xout = X .* (l-1)./l + d;
end
