function [ch, PARS] = fake_gaussianUMKV(nNodes, d, variance)

% generate random parameters

% hazard rate
h = rand;

% decision noise
sigma_choice = rand*5;

% run lengths
if nNodes > 0
    l(1) = 1+rand*0.5;
    for i = 2:nNodes
        l(i) = l(i-1) + 1 + rand*5;
    end
end


% simulate behavior with these parameters on observations actually seen by 
% subjects

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

% choices are corrupted by decision noise
ch = mn + randn(size(mn))*sigma_choice;

PARS = [h sigma_choice l];