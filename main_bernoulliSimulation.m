% bernoulli example

clear

% parameters --------------------------------------------------------------
% run-lengths
l = unique(ceil(logspace(log10(1), log10(100), 20)));

% hazard rate (for optimal model)
h = 0.05;

T = 200;

% parameters of beta-distribution prior
a0 = 1;
b0 = 1;




% generate data set -------------------------------------------------------
% make data
[rho_true, d] = bernoulli_generateTestSet(h, T, a0, b0);

% number of timesteps in simulation
T = length(rho_true);


% run reduced model -------------------------------------------------------
% likelihood function
lk  = @bernoulli_likelihood;
% update function for sufficient statistics
U   = @bernoulli_updateSufficientStats;
% compute mean
M   = @bernoulli_mean;
% setup transition matrix - comment out one of these to switch between
% original 2013 model and 2017 update
% TrMat = makeTransitionMatrix_2013(l, h);
TrMat = makeTransitionMatrix_2017(l, h);

% initial suff stat val
X = a0/(a0+b0)*l;

% simulate
%   mn is estimated mean
%   PP is run-length distribution
[mn, PP] = simulate(d, X, l, TrMat, U, lk, M);


% run optimal model -------------------------------------------------------
lk_opt  = @bernoulli_optimalModel_likelihood;
U_opt   = @bernoulli_optimalModel_updateSufficientStats;
M_opt   = @bernoulli_optimalModel_mean;
H_opt   = @(T) hazard_constant(T,h);

% initial suff stat val
xPrior = [2 1];

% simulate optimal model
[mn_opt, PP_opt] = simulate_optimalModel(d, xPrior, H_opt, U_opt, lk_opt, M_opt);


% plot --------------------------------------------------------------------
figure(1); clf;
ax(1) = subplot(3,1,1); hold on;
imagesc(0.5, 1:length(d), d)
set(gca, 'clim', [0 4], 'ydir', 'normal')
ylabel('\rho')
plot(rho_true, 'k--')
plot(mn_opt, 'b')
plot(mn, 'r')
legend({'ground truth' 'optimal model' 'reduced model'})
ylim([0 1])
colormap gray; c = colormap; colormap(1-c);
title('')

ax(2) = subplot(3,1,2); hold on;
pcolor([1:length(d)],[1:size(PP_opt,2)],log10(PP_opt'))
ylim([0 100])
shading flat
set(gca, 'ydir', 'normal');
xlim([0 length(d)])
set(gca, 'tickLength', [0 0])
set(gca, 'clim', [-1.5 0])
ylim([0 100]+0.5)
ylabel('run-length')
title('optimal model')

ax(3) = subplot(3,1,3); hold on;
pcolor([1:length(d)],l,log10(PP'))
shading flat
set(gca, 'ydir', 'normal');
xlim([0 length(d)])
set(gca, 'clim', [-1.5 0])
ylim([0 100]+0.5)
ylabel('run-length')
title('reduced model')
xlabel('time step')
