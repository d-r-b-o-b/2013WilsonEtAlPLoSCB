function lik    = gaussianUMKV_likelihood(d, X, l, sigma)

xBar = X ./ l;
lik = 1 / sqrt(2*pi) / sigma * sqrt(l ./ (1+l)) .* exp( ...
    -1/sigma^2/2 * (l ./ (1+l)) .* (d - xBar).^2);

end