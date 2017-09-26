clear

directories;
cd(fundir{1});



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















%%
for i = 1:length(ax)
    
    axes(ax(i)); hold on;
    l2(i) = plot(d, '.');
    l1(i) = plot(m, 'k--');
    
    if i > 1
        l3(i-1) = plot(mn(:,i-1));
    end
    xlabel('day number')
    ylabel('stock price [$]')
end
leg = legend([l1(1) l2(1)], {'generative mean' 'observed data'});
leg(2) = legend(l3(1), 'delta rule, \alpha = 0.2');
leg(3) = legend(l3(2), 'delta rule, \alpha = 0.5');
leg(4) = legend(l3(3), 'full Bayesian model');
leg(5) = legend(l3(4), 'approximate model');

set(leg, 'location', 'northwest', 'fontsize', 12)

set([l1 l2 l3], 'linewidth', 3)
set(l2, 'markersize', 25, 'color','r')
set(l3, 'color', 'b')
set(ax, 'tickdir', 'out', 'fontsize', 12')
addABCs(ax, [-0.13 0.01], 28)

saveFigurePdf(gcf, '~/Desktop/Figure_1')



























