function [ch, PARS] = fake_nassar(d, variance)

% generate random parameters

% hazard rate
h = rand;

% decision noise
sigma_choice = rand*5;



% simulate behavior with these parameters on observations actually seen by 
% subjects
drift = 0;
likeWeight = 1;

mn = nassar(d, h, variance, drift, likeWeight, 0, d(1));
mn = mn(1:end-1)';
% % setup functions
% lk  = @(x,y,z) gaussianUMKV_opt_likelihood(x,y,variance);
% U   = @gaussianUMKV_opt_updateSufficientStats;
% M   = @gaussianUMKV_opt_mean;
% H   = @(T) hazard_constant(T,h);
% 
% % initial suff stat val
% muPrior = 150;
% vp = 0.5;
% xPrior = [vp muPrior*vp];
% 
% % simulate optimal model
% [mn, PP_opt, plgd_opt] = ...
%     simulate_optimalModel(d, xPrior, H, U, lk, M);
% % 
% 
% % make transition matrix
% TrMat = makeTransitionMatrix_2017(l, h);
% 
% % setup functions
% lk  = @(x,y,z) gaussianUMKV_likelihood(x,y,z,variance);
% U   = @gaussianUMKV_updateSufficientStats;
% M   = @gaussianUMKV_mean;
% 
% % initial suff stat val
% X = 0.5*l;
% 
% % simulate
% [mn, PP, plgd] = simulate(d, X, l, TrMat, U, lk, M);

% choices are corrupted by decision noise
ch = mn + randn(size(mn))*sigma_choice;

PARS = [h sigma_choice];