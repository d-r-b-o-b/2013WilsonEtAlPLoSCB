% Gaussian example unknown mean, known variance

clear
h = 0.05;

% set run lengths
l = unique(ceil(logspace(log10(1), log10(100), 20)));

% setup transition matrix
TrMat = makeTransitionMatrix_2017(l, h);

% make data
mu_true = 0;

sig_true(1:66) = 5;
sig_true(67:133) = 15;
sig_true(134:200) = 5;

d = mu_true + sig_true.*randn(size(sig_true));

% setup functions
lk  = @(x,y,z) gaussianKMUV_likelihood(x,y,z,mu_true);
U   = @(x,y,z) gaussianKMUV_updateSufficientStats(x,y,z,mu_true);
M   = @ gaussianKMUV_mean;

% initial suff stat val
X = -0.5*l;

% simulate
[mn, PP, plgd] = simulate(d, X, l, TrMat, U, lk, M);

lk_opt  = @(x,y,z) gaussianKMUV_opt_likelihood(x,y,mu_true);
U_opt   = @(x,y) gaussianKMUV_opt_updateSufficientStats(x,y,mu_true);
M_opt   = @ gaussianKMUV_opt_mean;
H_opt   = @(T) hazard_constant(T,h);

% initial suff stat val
xPrior = [1 -1];

% simulate optimal model
[mn_opt, PP_opt, plgd_opt] = ...
    simulate_optimalModel(d, xPrior, H_opt, U_opt, lk_opt, M_opt);


figure(1); clf;
ax(1) = subplot(3,1,1);
ax(2) = subplot(3,1,2);
ax(3) = subplot(3,1,3);
axes(ax(1)); hold on;
mm  = plot(d, 'r.');
set(mm, 'color', [ 1 1 1]*0.75)
plot(mu_true+sig_true, 'k--')
plot(mu_true+mn_opt)
plot(mu_true+mn,'r')
plot(mu_true-sig_true, 'k--')
plot(mu_true-mn,'r')
plot(mu_true-mn_opt,'b')
plot(mu_true+mn_opt,'b')
xlim([0 length(d)])
ylim([min(d) max(d)])
% set(gca, 'xticklabel', [])



axes(ax(2));
pcolor([1:length(d)],[1:size(PP_opt,2)],log10(PP_opt)')
shading flat
set(gca, 'ydir', 'normal');
xlim([0 length(d)])
set(gca, 'clim', [-1.5 0])
% set(gca, 'xticklabel', [])
ylim([0 100])
title('run-length distribution (optimal model)')
ylabel('run-length')

axes(ax(3));
pcolor([1:length(d)],l,log10(PP)')
shading flat
set(gca, 'ydir', 'normal');
xlim([0 length(d)])
set(gca, 'clim', [-1.5 0])
ylim([0 100])
title('run-length distribution (reduced model)')

ylabel('run-length')
xlabel('time step')

