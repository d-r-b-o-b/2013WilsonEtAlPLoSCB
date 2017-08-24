function lik    = gaussianKMUV_opt_likelihood(d, X, mu)

xU = X + repmat([1 -(d-mu).^2/2], [size(X,1) 1]);

v0 = X(:,1);
chi0 = X(:,2);

v1 = xU(:,1);
chi1 = xU(:,2);

e1 = (v1+2)/2;
e0 = (v0+2)/2;

lik = 0.39894228040143272 * ...
    exp( gammaln( e1 ) - gammaln( e0 ) ...
    + e0 .* log(-chi0) - e1 .* log(-chi1));
end
