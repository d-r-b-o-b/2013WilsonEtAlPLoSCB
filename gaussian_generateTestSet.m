function [mu, d] = gaussian_generateTestSet( h, T, v_p, X_p, sigma)

% generate a Bernoulli change-point test set

% test parameter values
% h = 0.1;
% T = 500;
% alpha = 1;
% beta = 1;

% generate change-points
cp = rand(T,1) < h;

% compute segment number
seg = cumsum(cp);

% sample bernoulli rate from Beta distribution
for s = unique(seg)'
    ind = seg == s;
    mu(ind) = X_p / v_p + sigma/ sqrt(v_p) *randn(1);
end

% sample data
d = mu + sigma*randn(size(mu));

end
