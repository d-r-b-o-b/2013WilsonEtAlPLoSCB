% Gaussian example unknown mean, known variance
clear

h = 0.025;
            
            % set run lengths
            l = unique(ceil(logspace(log10(1), log10(100), 20)));
            
            % setup transition matrix
            TrMat = makeTransitionMatrix_2013(l, h);
            
            % make data
            %mu_true(1:200) = -10;
            mu_true(1:40) = -10;
            mu_true(41:80) = 10;
            mu_true(81:120) = 20;
            mu_true(121:150) = -5;
            mu_true(151:200) = 15;
            
            sigma_noise = 5;
            
            d = mu_true + sigma_noise*randn(size(mu_true));
            
            % setup functions
            lk  = @(x,y,z) obj.gaussianUMKV_likelihood(x,y,z,sigma_noise);
            U   = @obj.gaussianUMKV_updateSufficientStats;
            M   = @obj.gaussianUMKV_mean;
            
            % initial suff stat val
            X = 0.5*l;
            
            % simulate
            [mn, PP, plgd] = obj.simulate(d, X, l, TrMat, U, lk, M);
            
            
            lk  = @(x,y,z) obj.gaussianUMKV_opt_likelihood(x,y,sigma_noise);
            U   = @obj.gaussianUMKV_opt_updateSufficientStats;
            M   = @obj.gaussianUMKV_opt_mean;
            H   = @(T) obj.hazard_constant(T,h);
            
            % initial suff stat val
            xPrior = [1 0];
            
            % simulate optimal model
            [mn_opt, PP_opt, plgd_opt] = ...
                obj.simulate_optimalModel(d, xPrior, H, U, lk, M);
            
            
            % make figure
            %figure(1); clf;
            %set(gcf, 'position', [1 1 500 500]);
            %
            %hg = [0.11 0.03 0.03 0.03];
            %wg = [0.18 0.03];
            %
            %hb(length(hg)-1) = 0.36;
            %hb(1:length(hg)-2) = (ones(length(hg)-2,1)-sum(hg)-hb(end))...
            %    / (length(hg)-2);
            %wb = (ones(length(wg)-1)-sum(wg)) / (length(wg)-1);
            %
            %ax = gridOfEqualFigures(hb, wb, hg, wg, gcf);
            
            axes(ax(1)); hold on;
            ll = plot(d, 'r.');
            set(ll, 'color', 1-[0.25 0.25 0.25]);
            plot(mu_true, 'k--')
            
            plot(mn_opt, 'b')
            plot(mn,'r')
            xlim([0 length(d)])
            ylim([min(d) max(d)])
            %colormap jet
            %leg = legend({'data' 'true' 'full' 'reduced'}, ...
            %    'location' ,'best');
            %set(leg, 'orientation', 'horizontal', ...
            %    'location', 'northOutside')
            set(gca, 'xticklabel', [])%, 'tickLength', [0 0])
            %ylabel('data')
            
            
            axes(ax(3));
            pcolor([1:length(d)],l,log10(PP'))
            shading flat
            set(gca, 'ydir', 'normal');
            
            xlim([0 length(d)])
            %ylabel('l_t')
            set(gca, 'clim', [-1.5 0])
            ylim([0 100])
            
            axes(ax(2));
            pcolor([1:length(d)],[1:size(PP_opt,2)],log10(PP_opt'))
            shading flat
            set(gca, 'ydir', 'normal');
            set(gca, 'xticklabel', [])%, 'tickLength', [0 0])
            
            xlim([0 length(d)])
            %xlabel('time step')
            %ylabel('l_t')
            %set(gca, 'tickLength', [0 0])
            set(gca, 'clim', [-1.5 0])
            ylim([0 100])
            

% 
% clear
% 
% % parameters --------------------------------------------------------------
% % run-lengths
% l_A = [1 4 16];
% 
% % hazard rate
% h = 0.1;
% 
% % number of timesteps in simulation
% T = 1000;
% 
% 
% % prior mean
% mu_p = 50;
% 
% % strength of prior
% v_p = 0.1;
% 
% % variance of observation noise
% sigma = 100;
% 
% % \chi_p
% X_p = mu_p * v_p;
% 
% % setup functions
% lk  = @(x,y,z) gaussianUMKV_likelihood(x,y,z,sigma);
% U   = @gaussianUMKV_updateSufficientStats;
% M   = @gaussianUMKV_mean;
% 
% % initial suff stat val
% X = 0.5*l_A;
% 
% % generate data
% [mu, d] = gaussian_generateTestSet( h, T, v_p, X_p, sigma);
% 
% % setup transition matrix
% TrMat = makeTransitionMatrix_2013(l_A, h);
% % TrMat = makeTransitionMatrix_2017(l_A, h);
% 
% % simulate
% [mn, PP, plgd, XX, LK] = simulate(d, X, l_A, TrMat, U, lk, M);
% 
% 
% figure(1); clf;
% ax(1) = subplot(2,1,1); hold on;
% plot(mu)
% plot(d, '.')
% plot(mn)
% legend({'true mean' 'data' 'infered mean'})
% 
% ax(2) = subplot(2,1,2); hold on;
% imagesc(PP')
% ylim([0.5 length(l_A)+0.5])
% set(ax, 'xlim', [0 T]+0.5)
% title('run-length distribution')
% xlabel('time step')
% 
% set(ax, 'fontsize', 14)
