% Gaussian example unknown mean, known variance
clear

h = 0.05;

% set run lengths
l = unique(ceil(logspace(log10(1), log10(100), 20)));

% setup transition matrix
% TrMat = makeTransitionMatrix_2013(l, h);
TrMat = makeTransitionMatrix_2017(l, h);

% make data
T = 200;

% 
sigma_noise = 5;

% generate data
% prior mean
mu_p = 0;

% strength of prior
v_p = 0.1;

% \chi_p
X_p = mu_p * v_p;

[mu_true, d] = gaussian_generateTestSet( h, T, v_p, X_p, sigma_noise);


% setup functions
lk  = @(x,y,z) gaussianUMKV_likelihood(x,y,z,sigma_noise);
U   = @gaussianUMKV_updateSufficientStats;
M   = @gaussianUMKV_mean;

% initial suff stat val
X = 0.5*l;

% simulate
[mn, PP, plgd] = simulate(d, X, l, TrMat, U, lk, M);


lk  = @(x,y,z) gaussianUMKV_opt_likelihood(x,y,sigma_noise);
U   = @gaussianUMKV_opt_updateSufficientStats;
M   = @gaussianUMKV_opt_mean;
H   = @(T) hazard_constant(T,h);

% initial suff stat val
xPrior = [1 0];

% simulate optimal model
[mn_opt, PP_opt, plgd_opt] = ...
    simulate_optimalModel(d, xPrior, H, U, lk, M);


% make figure
figure(1); clf;
ax(1) = subplot(3,1,1);
ax(2) = subplot(3,1,2);
ax(3) = subplot(3,1,3);

axes(ax(1)); hold on;
plot(mu_true, 'k--')
ll = plot(d, 'r.');
set(ll, 'color', [0.5 0.5 0.5]);

plot(mn_opt, 'b')
plot(mn,'r')
xlim([0 length(d)])
ylim([min(d) max(d)])
set(gca, 'xticklabel', [])
ylabel('data and estimates')
legend({'ground truth' 'data' 'optimal model' 'reduced model'})

axes(ax(2));
pcolor([1:length(d)],[1:size(PP_opt,2)],log10(PP_opt'))
shading flat
set(gca, 'ydir', 'normal');
set(gca, 'xticklabel', [])
set(gca, 'clim', [-1.5 0])
xlim([0 length(d)])
ylim([0 100])
title('run-length distribution (optimal model)')
ylabel('run-length')

axes(ax(3));
pcolor([1:length(d)],l,log10(PP'))
shading flat
set(gca, 'ydir', 'normal');
xlim([0 length(d)])
title('run-length distribution (reduced model)')

xlabel('time step')
ylabel('run-length')

set(gca, 'clim', [-1.5 0])
ylim([0 100])

