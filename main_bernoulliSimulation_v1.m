% bernoulli example

clear

% parameters --------------------------------------------------------------
% run-lengths
l_A = [1 4 16];

% hazard rate
h = 0.1;

% number of timesteps in simulation
T = 1000;

% parameters of beta-distribution prior
a0 = 1;
b0 = 1;


% setup functions ---------------------------------------------------------
% likelihood function
lk  = @bernoulli_likelihood;
% update function for sufficient statistics
U   = @bernoulli_updateSufficientStats;
% compute mean
M   = @bernoulli_mean;


% generate data set -------------------------------------------------------
[rho, d] = bernoulli_generateTestSet(h, T, a0, b0);


% run reduced model -------------------------------------------------------
% setup transition matrix - comment out one of these to switch between
% original 2013 model and 2017 update
% TrMat = makeTransitionMatrix_2013(l_A, h);
TrMat = makeTransitionMatrix_2017(l_A, h);

% initial suff stat val
X = a0/(a0+b0)*l_A;

% simulate
%   mn is estimated mean 
%   PP is run-length distribution
%   plgd is run-length distribution at last time step (legacy)
%   XX is sufficient statistic \chi for each node
%   LK is likelihood at each node
[mn, PP, plgd, XX, LK] = simulate(d, X, l_A, TrMat, U, lk, M);


% plot --------------------------------------------------------------------
figure(1); clf;
ax(1) = subplot(3,1,1); hold on;
imagesc(d)
title('data')
set(gca, 'ytick', [])

ax(2) = subplot(3,1,2); hold on;
plot(rho)
plot(mn)
title('generative Bernoulli rate')

ax(3) = subplot(3,1,3); hold on;
imagesc(PP')
ylim([0.5 length(l_A)+0.5])
set(ax, 'xlim', [0 T]+0.5)
title('run-length distribution')
xlabel('time step')

set(ax, 'fontsize', 14)




