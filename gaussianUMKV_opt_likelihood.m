function lik    = gaussianUMKV_opt_likelihood(d, X, sigma)

xU = X + repmat([1 d], [size(X,1) 1]);

data = repmat(d, [size(X,1), 1]);
v0 = X(:,1);
chi0 = X(:,2);

v1 = xU(:,1);
chi1 = xU(:,2);

lik = 0.39894228040143272 * sqrt(v0./v1) / sigma ...
    .* exp(1/2/sigma^2 ...
    * ( -data.^2 + chi1.^2./v1 - chi0.^2./v0) ) ...
    * 1;%rE;

end
