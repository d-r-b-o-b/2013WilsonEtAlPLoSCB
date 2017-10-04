clear 

% set random seed
try
    % rng is not supported on older versions of matlab
    rng(1);
end
% parameters
h = 0.05;
T = 100;
mu_p = 15;
sigma_p = 5;
sigma = 2;

% sample change-point locations
cp = find(rand(T,1) < h);

nChange = length(cp);
nEpochs = nChange + 1;

% sample means for each epoch
m = mu_p + randn(nEpochs,1) * sigma_p;

% create time course of true mean
eStart = [1; cp];
eEnd = [cp; T];
for i = 1:length(eStart)
    mu(eStart(i):eEnd(i)) = m(i);
end

% create data
d = mu + sigma * randn(size(mu));



d_max = 30;%max(d);




figure(1); clf;
set(gcf, 'position', [753     8   650   550])
dx = 0.1;
dy = 0.14;
hg = [0.09 dy dy 0.05];
wg = [0.12 0.32];
hb = (ones(length(hg)-1,1)-sum(hg))/(length(hg)-1);
wb = (ones(length(wg)-1,1)-sum(wg))/(length(wg)-1);
ax(1:3) = gridOfEqualFigures(hb, wb, hg, wg);

hg2 = [hg(1) hg(2) hg(3)+hb(2)+hg(4)];
hb2 = [hb(1) hb(2)];%(ones(length(hg2)-1,1)-sum(hg2))/(length(hg2)-1);
wg2 = [wg(1)+wb(1)+0.1 0.03]
wb2 = (ones(length(wg2)-1,1)-sum(wg2))/(length(wg2)-1);
ax(4:5) = gridOfEqualFigures(hb2, wb2, hg2, wg2);

axes(ax(1)); hold on;
lcp = plot([cp cp]'-0.5, [zeros(size(cp)) ones(size(cp))]'*d_max);
xlabel('time step')
ylabel({'change-point' 'locations'})

axes(ax(2)); hold on;
lcp(:,2) = plot([cp cp]'-0.5, [zeros(size(cp)) ones(size(cp))]'*d_max);
lmu = plot(mu);
xlabel('time step')
ylabel({'generative' 'mean, \mu'})


axes(ax(3)); hold on;
lcp(:,3) = plot([cp cp]'-0.5, [zeros(size(cp)) ones(size(cp))]'*d_max);
lmu(2) = plot(mu);
ld = plot(d, '.')
xlabel('time step')
ylabel('data value, x_t')


axes(ax(4)); hold on;
x = [0:0.01:d_max];
y = 1 / sqrt(2*pi) /sigma_p * exp(-(x-mu_p).^2/2/sigma_p^2);
ll = plot(y,x);
xlabel('probability density')
ylabel('\mu')
tt = title('p(\mu | v_p, \chi_p)');


axes(ax(5)); hold on;
x = [0:0.01:d_max];
y = 1 / sqrt(2*pi) /sigma * exp(-(x-mu(end)).^2/2/sigma^2);
ll(2) = plot(y,x);
xlabel('probability density')
ylabel('x_t')
tt(2) = title('p(x_t | \mu)');

set(lcp, 'color', [1 1 1]*0.5, 'linewidth', 3)
set(lmu, 'color', [1 1 1]*0, 'linestyle', '--', 'linewidth', 3)
set(ld, 'color', 'r', 'markersize', 30)
set(ll, 'color', 'k', 'linewidth', 3)

set(tt, 'fontweight', 'normal')

set(ax, 'ylim', [0 d_max], 'tickdir', 'out', ...
    'fontsize', 12)
set(ax(1:3), 'xlim', [0 100])

addABCs(ax(1:3), [-0.08 0.04], 20, 'ABD')
addABCs(ax(4:5), [-0.04 0.04], 20, 'CE')

saveFigurePdf(gcf, '~/Desktop/Figure_2')
