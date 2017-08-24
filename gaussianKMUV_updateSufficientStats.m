function Xout   = gaussianKMUV_updateSufficientStats(d, X, l, mu)
Xout = X .* (l-1)./l + repmat(-(d-mu)^2/2, [size(X,1) 1]);
end
