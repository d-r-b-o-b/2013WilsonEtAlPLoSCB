clear

directories;



%% generate observations
% generative mean
m(1:20,1) = 10;
m(21:40,1) = 20;

% generative standard deviation
sigma = 2;

% generate observations
d = m + sigma*randn(size(m));



%% run simple delta rule with alpha = 0.2
% assume initial condition is first true mean
mn(:,1) = delta_rule(d, 0.2, m(1))



%% run simple delta rule with alpha = 0.8
mn(:,2) = delta_rule(d, 0.8, m(1))



%% run full model 
% hazard rate set to 0.1
h = 0.1;
lk  = @(x,y,z) gaussianUMKV_opt_likelihood(x,y,sigma);
U   = @gaussianUMKV_opt_updateSufficientStats;
M   = @gaussianUMKV_opt_mean;
H   = @(T) hazard_constant(T,h);

% prior 
vp = 0.01; % strength of prior
mp = m(1); % prior mean (set to first true mean)
xPrior = [vp mp*vp];

% simulate optimal model
mn(:,3) = simulate_optimalModel(d, xPrior, H, U, lk, M);



% figure(1); clf; 
% ax = easy_gridOfEqualFigures([0.1 0.1 0.1], [0.1 0.03]);
% axes(ax(1)); hold on;
% plot(d,'.', 'markersize', 30)
% plot(mn(:,3),'.-', 'markersize', 30)
% axes(ax(2)); hold on;
% imagesc(PP')
% set(ax, 'xlim', [0 40])

%% run approximate model with 2 nodes
h = 0.1; % hazard rate
l = [1 5]; % run-lengths 

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
mn(:,4) = simulate(d, X, l, TrMat, U, lk, M);




%% plot results
figure(1); clf;
set(gcf, 'Position', [440     1   500   700])
ax = easy_gridOfEqualFigures([0.07 0.07 0.07 0.07 0.07 0.02], [0.17 0.03]);

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
leg(3) = legend(l3(2), 'delta rule, \alpha = 0.8');
leg(4) = legend(l3(3), 'full Bayesian model');
leg(5) = legend(l3(4), 'approximate model');

set(leg, 'location', 'northwest', 'fontsize', 12)

set([l1 l2 l3], 'linewidth', 3)
set(l2, 'markersize', 25, 'color','r')
set(l3, 'color', 'b')
set(ax, 'tickdir', 'out', 'fontsize', 12')
addABCs(ax, [-0.13 0.01], 28)

saveFigurePdf(gcf, '~/Desktop/Figure_1')



























