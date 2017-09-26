% fits fake data
% to reproduce confusion matrix you will need to increase nRepeats to
% around 100.  This slows things down but ensures the fitting starts from
% multiple starting points and better avoids local minima.
% fits are stored in the FIT structures
% saves everything in "fakefits" directory

clear


directories;
datadir   = [maindir 'fakedata/'];
savedir   = [maindir 'fakefits/'];

% load fake data
cd(datadir);
d = dir('*.mat');
for i = 1:length(d)
    L(i) = load(d(i).name)
end
SIM = [L.SIM];
clear L


cd(maindir)

% generate a unique savename for this run
TT = datestr(now);
TT(TT==' ' | TT==':' | TT=='-') = '';
savename = ['fitFake_' TT];


nRepeats = 1; 

% model name
% full : full Bayesian model
% nassar : Nassar et al. 2012 model
% 1 : 1-node model 
% 2 : 2-node model (using correct change-point prior)
% 3 : 3-node model (using correct change-point prior)
% can also use
% 2013n2 : 2-node model (using *incorrect* change-point prior used in original 2013 paper)
% 2013n3 : 3-node model (using *incorrect* change-point prior used in original 2013 paper)

models = {'full' 'nassar' '1' '2' '3'};

count = 1;
tic
for m = 1:length(models)
    model = models{m};
    disp(model);
    
    % 77:240
    
    for sim_count = 1:length(SIM)
        fprintf(1, [' sim_count = ' num2str(sim_count) '\n'])
        d = SIM(sim_count).d;
        c = SIM(sim_count).c;
        variance = SIM(sim_count).var;
        
        for X0flag = 1:nRepeats
            % Note that first two repeats are with FIXED starting
            % conditions so start X0flag at 3 for random starting
            % parameters
            
            switch model
                case 'full'
                    fit = fit_opt_gaussianUMKV(d, c, variance, X0flag);
                    fit.subNum = sim_count;
                    
                case 'nassar'
                    fit = fit_nassar(d, c, variance, X0flag);
                    fit.subNum = sim_count;
                    
                case {'1' '2' '3' '4' '5'}
                    % number of nodes to be fit
                    nNodes = str2num(model);
                    
                    fit = fit_gaussianUMKV(nNodes, d, c, variance, X0flag);
                    fit.subNum = sim_count;
                    
                case {'2013n1' '2013n2' '2013n3' '2013n4' '2013n5'}
                    % number of nodes to be fit
                    nNodes = str2num(model(end));
                    
                    fit = fit_gaussianUMKV_2013(nNodes, d, c, variance, X0flag);
                    fit.subNum = sim_count;
            end
            
            
            
            FIT(count).model        = model;
            FIT(count).nNodes       = fit.nNodes;
            FIT(count).var          = fit.var;
            FIT(count).X            = fit.X;
            FIT(count).hessian      = fit.hessian;
            FIT(count).val          = fit.val;
            FIT(count).BIC          = fit.BIC;
            FIT(count).n            = fit.n;
            FIT(count).simNum       = sim_count;
            FIT(count).model_true   = SIM(sim_count).model;
            FIT(count).X_true       = SIM(sim_count).X;
            
            save([savedir savename]);
            count = count + 1;
        end
    end
end
toc
