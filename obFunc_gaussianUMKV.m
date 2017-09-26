function [E2] = obFunc_gaussianUMKV_v1(X, d, c, variance)

% X

h = X(1);
sigma_choice = X(2);
l = X(3:end);

if sigma_choice == 0
    E2 = 1e4; AA = Inf; BB = Inf;
    return;
end
if X(2) <= 0
    E2 = 1e4; AA = Inf; BB = Inf;
    return;
end
if length(unique(l)) ~= length(l)
    % cannot have two nodes with same run-length
    E2 = 1e4; AA = Inf; BB = Inf;
    return;
end

% make transition matrix
TrMat = makeTransitionMatrix_2017(l, h);

% setup functions
lk  = @(x,y,z) gaussianUMKV_likelihood(x,y,z,variance);
U   = @gaussianUMKV_updateSufficientStats;
M   = @gaussianUMKV_mean;

% initial suff stat val
X = 0.5*l;

% simulate
[mn, PP, plgd] = simulate(d, X, l, TrMat, U, lk, M);

% discard initial point
mn = mn(2:end);
c = c(2:end);

D = mn'-c;

AA = D*D'/sigma_choice^2/2;
BB = length(mn)*log(sigma_choice);
E2 = (AA+BB);

% E2
