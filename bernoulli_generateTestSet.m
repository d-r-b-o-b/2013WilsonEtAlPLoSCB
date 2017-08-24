function [rho, d] = bernoulli_generateTestSet(h, T, alpha, beta)

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
    rho(ind) = betarnd(alpha, beta);
end

% sample data
d = rand(size(rho)) < rho;

end
