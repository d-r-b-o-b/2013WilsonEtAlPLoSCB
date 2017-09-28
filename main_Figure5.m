clear

directories;
cd(maindir);



%% generate observations
% generative mean
m(1:20,1) = 2;
m(21:40,1) = 8;

% generative standard deviation
sigma = 0.5;
h = 0.1;
l1 = [5];
l2 = [1.5 5];

% generate observations
d = m + sigma*randn(size(m));



%% run one-node model
h = 0.1; % hazard rate
l = [5]; % run-length

% make transition matrix
TrMat = makeTransitionMatrix_2017(l, h);
% to switch to incorrect 2013 version uncomment following line ...
% TrMat = makeTransitionMatrix_2013(l, h);

% setup functions
lk  = @(x,y,z) gaussianUMKV_likelihood(x,y,z,sigma);
U   = @gaussianUMKV_updateSufficientStats;
M   = @gaussianUMKV_mean;

% initial suff stat val - set so that mean of each node is equal to true
% mean
X = l*m(1); 

% simulate
mn(:,1) = simulate(d, X, l, TrMat, U, lk, M);


%% run two-node model
h = 0.1; % hazard rate
l = [1.5 5]; % run-length

% make transition matrix
TrMat = makeTransitionMatrix_2017(l, h);
% to switch to incorrect 2013 version uncomment following line ...
% TrMat = makeTransitionMatrix_2013(l, h);

% setup functions
lk  = @(x,y,z) gaussianUMKV_likelihood(x,y,z,sigma);
U   = @gaussianUMKV_updateSufficientStats;
M   = @gaussianUMKV_mean;

% initial suff stat val - set so that mean of each node is equal to true
% mean
X = l*m(1); 

% simulate
[mn(:,2), P] = simulate(d, X, l, TrMat, U, lk, M);




%% plot results
figure(1); clf;
set(gcf, 'Position', [440     1   500   400])
ax = easy_gridOfEqualFigures([0.12  0.15 0.04], [0.14 0.03]);


axes(ax(1)); hold on;
l0 = plot(d, '.', 'color', [1 1 1]*0.5, 'markersize', 25)
l1 =  plot(mn);
xlabel('time step')
ylabel('data')


axes(ax(2)); hold on;
l2 = plot(P);
xlabel('time step')
ylabel('node weight')

leg = legend([l0 l1'], {'data' '1 node' '2 nodes'});
leg(2) = legend(l2, {'p(l_1 | x_{1:t})' 'p(l_2 | x_{1:t})'});
set(leg, 'location', 'northwest')

set([l0 l1' l2'], 'linewidth', 3)

set(l1(1), 'color', 'r')
set(l1(2), 'color', 'k', 'linestyle', '--')

set(l2(1), 'color', [1 1 1]*0)
set(l2(2), 'color', [1 1 1]*0.5)


set(ax, 'tickdir', 'out', 'fontsize', 12', 'xlim', [0 41])
addABCs(ax, [-0.1 0.04], 36)

saveFigurePdf(gcf, '~/Desktop/Figure_5')































