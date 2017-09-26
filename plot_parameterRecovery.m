function [ax, lines] = plot_parameterRecovery(FIT, mdl_sim, mdl_fit)

% select results where true model is model_sim
ft = FIT(strcmp({FIT.model_true}, mdl_sim));

% select results where fit model is model_fit
ft = ft(strcmp({ft.model}, mdl_fit));

% for each simulation number, find the best fitting run
sn = unique([ft.simNum]);

for i = 1:length(sn)
    
    ind = find([ft.simNum] == sn(i));
    
    [~,i_min] = min([ft(ind).BIC]);
    Xfit(:,i) = ft(ind(i_min)).X;
    Xsim(:,i) = ft(ind(i_min)).X_true;
    bic(i) = ft(ind(i_min)).BIC;
    val(i) = ft(ind(i_min)).val;
    
end

if strcmp(mdl_sim, '1')
    Xsim = Xsim(2:end,:);
end
if strcmp(mdl_fit, '1')
    Xfit = Xfit(2:end,:);
end


ny = size(Xsim,1);
nx = size(Xfit,1);


hg = ones(ny+1,1)*0.1;
wg = ones(nx+1,1)*0.1;
figure(1); clf;
[~,~,~,ax] = easy_gridOfEqualFigures(hg, wg);
for i = 1:size(Xsim,1)
    for j = 1:size(Xfit,1)
        axes(ax(i,j)); hold on;
        lines.l(i,j) = plot(Xsim(i,:), Xfit(j,:),'.');
        if i == j
            if strcmp(mdl_sim, mdl_fit)
                xl = get(gca, 'xlim');
                lines.ld = plot(xl, xl, 'k--');
                xlim(xl)
            end
            
        end
    end
end
