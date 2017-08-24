function Xout   = gaussianUMKV_updateSufficientStats(d, X, l)
Xout = X .* (l-1)./l + repmat(d, [size(X,1) 1]);
end
