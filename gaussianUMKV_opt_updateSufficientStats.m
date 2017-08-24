function Xout   = gaussianUMKV_opt_updateSufficientStats(d, X, l)
Xout = X + repmat([1 d], [size(X,1) 1]);
end
