clear


directories;
cd(fundir{1});

figure(1); clf; 
set(gcf, 'Position', [ 440   108   700   550])
[~, ~, ~, ax] = easy_gridOfEqualFigures([0.09 0.09 0.13 0.1], [0.12 0.12 0.12 0.03]);

l1 = figure6_bernoulli(ax(:,1))
l2 = figure6_gaussianUMKV(ax(:,2));
l3 = figure6_gaussianKMUV(ax(:,3));


set([l1 l2 l3], 'linewidth', 1, 'markersize', 20)

axes(ax(1,2));
leg = legend({'ground truth' 'data' 'full model' 'reduced model'}, ...
    'orientation', 'horizontal')


set(leg, 'position', [0.3186    0.6155    0.4621    0.0282])
set(ax, 'fontsize', 12, 'tickdir', 'out')

axes(ax(1,1)); t = title('Bernoulli');
axes(ax(1,2)); t(2) = title({'Gaussian' 'unknown mean' 'known variance'});
axes(ax(1,3)); t(3) = title({'Gaussian' 'known mean' 'unknown variance'});
set(t, 'fontweight', 'normal')

axes(ax(1,1)); ylabel('data & estimates')
axes(ax(2,1)); ylabel('run length (full)')
axes(ax(3,1)); ylabel('run length (reduced)')

axes(ax(3,1)); xlabel('time step')
axes(ax(3,2)); xlabel('time step')
axes(ax(3,3)); xlabel('time step')
ax = ax';
addABCs(ax(1,:), [-0.08 0.03], 20, ['ADG'])
dum = ax(2:end,:);
addABCs(dum(:), [-0.06 0.03], 20, ['BCEFHI'])

saveFigurePdf(gcf, '~/Desktop/Figure_6')

