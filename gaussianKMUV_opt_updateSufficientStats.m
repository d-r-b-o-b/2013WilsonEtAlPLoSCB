function Xout   = gaussianKMUV_opt_updateSufficientStats(d, X, mu)
Xout = X + repmat([1 -(d-mu).^2/2], [size(X,1) 1]);
end
