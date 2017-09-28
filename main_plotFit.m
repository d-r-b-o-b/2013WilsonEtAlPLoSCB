clear


directories;
datadir   = [maindir 'data/'];
savedir   = [maindir 'realfits/']; mkdir(savedir);


cd(savedir);
d = dir('*.mat');
for i = 1:length(d)
    L(i) = load(d(i).name, 'fit');
    for j = 1:length(L(i).fit)
        ii = find(d(i).name == '_');
        L(i).fit(j).model = d(i).name(1:ii-1);
    end
end

fit = [L.fit];
model = {'full' 'nassar' '1' '2' '3'};

%%
% for each subject find best fitting version of each model
% for i = 1:length(model);
v_vals = [5 10];
for i = 1:length(model)
    for sn = 1:30
        for v = 1:2
            %if i == 4
            %    i_model = isnan([fit.nNodes]);
            %else
            %i_model = [fit.nNodes] == model(i);
            %end
            i_model = strcmp({fit.model}, model{i});
            i_sub = [fit.subNum] == sn;
            i_v = [fit.var] == v_vals(v);
            
            ind = i_model & i_sub & i_v;
            F = fit(ind);
            
            [~,i_min] = min([F.val]);
            
            X{i}(:,v,sn) = F(i_min).X;
            
            % recompute BIC
            switch model{i}
                case {'1' '2013n1'}
                    k = 2;
                otherwise
                    k = length(F(i_min).X);
            end
            
            BIC(i,sn,v) = 2*F(i_min).val + k*log(F(i_min).n);
            
            
            
        end
    end
end

L = -[BIC(:,:,1) BIC(:,:,2)];
BIC = nanmean(BIC,3);


%% compute exceedance probabilities
lme = (L)';
ind1 = ~isnan(sum(lme,2));
ind2 = (sum(lme,2))==real((sum(lme,2)));
ind3 = ~(prod(lme,2)==0);
ind = ind1 & ind2 & ind3;

lme = lme(ind,:);

[alpha,exp_r,xp] = spm_BMS(lme);

figure(1); clf;
set(gcf, 'Position', [200 305 900 350])
ax = easy_gridOfEqualFigures([0.26  0.14], [0.13 0.15 0.02]);
axes(ax(1)); hold on;
bar(exp_r, 'facecolor', [1 1 1]*0.5)
% title('fraction of subjects best fit')


axes(ax(2)); hold on;
bar(xp, 'facecolor', [1 1 1]*0.5)

% ylabel({'probability of model' 'explaining all data'})

set(ax, 'xtick', [1:length(model)], ...
    'xticklabel', { 'full' 'Nassar et al.' '1 node' '2 nodes' '3 nodes'}, ...
    'xlim', [0.5 length(model)+0.5], ...
    'ylim', [0 1], 'view', [90 90], ...
    'tickdir', 'out', 'ytick', [0:0.2:1], ...
    'fontsize', 18)
addABCs(ax, [-0.08 0.16], 48);

axes(ax(1)); 
title('model probability', 'fontsize', 30, ...
    'fontweight', 'normal')
ylabel({'expected fraction of subjects' 'best fit by model'}, 'fontsize', 24)
axes(ax(2)); title('exceedance probability', 'fontsize', 30, ...
    'fontweight', 'normal')
ylabel({'probability of single model' 'explaining all data'}, 'fontsize', 24)
saveFigurePdf(gcf, '~/Desktop/modelFits2')

%% mean parameter values for each model
for i = 1:length(X)
    for j = 1:size(X{i},1)
        xx = X{i}(j,:,:);
        xx = xx(:);
        if (sum(strcmp(model{i}, {'1' '2' '3'}))>0) & (j >= 3)
            M(i,j) = nanmean(1./xx);
            S(i,j) = nanstd(1./xx)/sqrt(length(xx));
        else
            M(i,j) = nanmean(xx);
            S(i,j) = nanstd(xx)/sqrt(length(xx));
        end
    end
end

M(M==0) = nan; S(S==0) = nan;

%% supplementary figure 1 - distributions of fit parameter values
mname = { 'full' 'Nassar et al.' '1 node' '2 nodes' '3 nodes'};

figure(1); clf; 
set(gcf, 'Position', [ 440    92   900   700])
hg = ones(6,1)*0.07;
wg = ones(6,1)*0.07;
wg(1) = 0.05;
wg(end) = 0.02;
hg(1) = 0.07;
hg(end) = 0.05;
[~,~,~,ax] = easy_gridOfEqualFigures(hg, wg);
clear tt
for i = 1:length(mname);
    
    vname = {'h' '\sigma_d' '\alpha_1' '\alpha_2' '\alpha_3'};
    
    for j = 1:size(X{i},1)
        axes(ax(j,i)); hold on;
        dum = X{i}(j,:,:);
        dum = dum(:);
        if j == 1
            tt(i) = title(mname{i}, 'fontsize', 20, 'fontweight', 'normal');
        end
        
        switch j
            case 1
                bins = [0.05:0.1:0.95];
            case 2
                bins = [1.5:3:30-1.5];
            case {3 4 5}
            % convert run-lengths into learning rates
            dum = 1./dum;
            bins = [0.05:0.1:0.95];
        end
        [h,x] = hist(dum, bins);
        
        h = h / sum(h);
        b = bar(x, h);
        set(b, 'facecolor', [1 1 1]*0.5)
        xlabel(vname{j}, 'fontsize', 12);
        ylabel('frequency', 'fontsize', 12)
    end
    
    % remove axes for parameters that don't exist
    for j = size(X{i},1)+1:size(ax,1)
        set(ax(j,i), 'visible', 'off')
    end
end

% remove hazard rate from 1-node model
axes(ax(1,3)); cla;
set(ax(1,3), 'visible', 'off')
set(ax, 'tickdir', 'out', 'ylim', [0 1], 'fontsize', 12);
set(tt, 'fontsize', 20, 'visible', 'on')

set(ax(2,:), 'xlim', [0 30])
saveFigurePdf(gcf, '~/Desktop/Figure_S1')




