function lik    = gaussianKMUV_likelihood(d, X, l, mu)

bigV = -2*X ./ l;

lik = 1 ./ sqrt(pi * l .* bigV) .* exp( ...
    gammaln((l+3)/2) - gammaln((l+2)/2) ...
    - (l+3)/2.*log(1+ (d-mu).^2 ./ (l.*bigV)));

end
