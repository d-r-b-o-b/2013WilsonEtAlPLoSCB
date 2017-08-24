% Gaussian example unknown mean, known variance

clear

% parameters --------------------------------------------------------------
% run-lengths
l_A = [1 4 16];

% hazard rate
h = 0.1;

% number of timesteps in simulation
T = 1000;


% prior mean
mu_p = 50;

% strength of prior
v_p = 0.1;

% variance of observation noise
sigma = 100;

% \chi_p
X_p = mu_p * v_p;

% setup functions
lk  = @(x,y,z) gaussianKMUV_likelihood(x,y,z,sigma);
U   = @gaussianKMUV_updateSufficientStats;
M   = @gaussianKMUV_mean;

% initial suff stat val
X = 0.5*l_A;

% generate data
[mu, d] = gaussian_generateTestSet( h, T, v_p, X_p, sigma);

% setup transition matrix
TrMat = makeTransitionMatrix_2013(l_A, h);
% TrMat = makeTransitionMatrix_2017(l_A, h);

% simulate
[mn, PP, plgd, XX, LK] = simulate(d, X, l_A, TrMat, U, lk, M);


figure(1); clf;
ax(1) = subplot(2,1,1); hold on;
plot(mu)
plot(d, '.')
plot(mn)
legend({'true mean' 'data' 'infered mean'})

ax(2) = subplot(2,1,2); hold on;
imagesc(PP')
ylim([0.5 length(l_A)+0.5])
set(ax, 'xlim', [0 T]+0.5)
title('run-length distribution')
xlabel('time step')

set(ax, 'fontsize', 14)
