function [E2] = obFunc_nassar_v1(X, d, c, variance)


h = X(1);
sigma_choice = X(2);
% drift = X(3);
% likeWeight = X(4);

drift = 0;
likeWeight = 1;

if sigma_choice == 0
    E2 = Inf; AA = Inf; BB = Inf;
    return;
end


[B, totSig, R, pCha] = nassar_v1(d, h, variance, drift, likeWeight, 0, 150);

% discard initial point
B = B(2:end-1);
c = c(2:end);

D = B - c;
AA = D*D'/sigma_choice^2/2;
BB = length(B)*log(sigma_choice);
E2 = (AA+BB);

















% 
% %%%%%%%%%%%
% h = X(1);
% sigma_choice = X(2);
% 
% 
% if sigma_choice == 0
%     E2 = 1e4; AA = Inf; BB = Inf;
%     return;
% end
% if X(2) <= 0
%     E2 = 1e4; AA = Inf; BB = Inf;
%     return;
% end
% 
% % setup functions
% lk  = @(x,y,z) gaussianUMKV_opt_likelihood(x,y,variance);
% U   = @gaussianUMKV_opt_updateSufficientStats;
% M   = @gaussianUMKV_opt_mean;
% H   = @(T) hazard_constant(T,h);
% 
% % initial suff stat val
% xPrior = [1 0];
% 
% % simulate optimal model
% [mn, PP_opt, plgd_opt] = ...
%     simulate_optimalModel(d, xPrior, H, U, lk, M);
% 
% 
% % discard initial point
% mn = mn(2:end);
% c = c(2:end);
% 
% D = mn'-c;
% 
% AA = D*D'/sigma_choice^2/2;
% BB = length(mn)*log(sigma_choice);
% E2 = (AA+BB);
