% fits real data
% increase nRepeats (100 is usually OK) to avoid local minima in the 
% fitting procedure 

clear


directories;
datadir   = [maindir 'data/'];
savedir   = [maindir 'realfits/']; mkdir(savedir);


load([datadir 'dataForBob'])


nRepeats = 100;

% models to be fit
model_list = {'full' 'nassar' '1' '2' '3'};
% full : full Bayesian model
% nassar : Nassar et al. 2012 model
% 1 : 1-node model 
% 2 : 2-node model (using correct change-point prior)
% 3 : 3-node model (using correct change-point prior)
% can also use
% 2013n2 : 2-node model (using *incorrect* change-point prior used in original 2013 paper)
% 2013n3 : 3-node model (using *incorrect* change-point prior used in original 2013 paper)



tic
for mm = 1:length(model_list)
    model = model_list{mm};
    disp(['model = ' model])
    clear fit % clear up before running next model
    count = 1;
    TT = datestr(now);
    TT(TT=='-') = '';
    TT(TT==' ') = '';
    TT(TT==':') = '';
    for X0flag = 3:nRepeats
        % Note X0flag codes for initial conditions ...
        %   1 => fixed initial conditions
        %   2 => fixed but logarithmic spacing of run-lengths
        %   3 and up => random
        
        
        fprintf(1, [' repeat = ' num2str(X0flag)])
        
        % subject numbers
        sn = [1:30];
        % variance conditions
        vn = [5 10];
        fprintf(1, '  |')
        for s = 1:length(sn)
            subNum = sn(s);
            if mod(s,3) == 0
                fprintf(1, '.')
            end
            for v = 1:length(vn)
                
                % variance condition (really standard deviation)
                variance = vn(v);
                
                % extract data for this subject in this variance condition
                sub     = allOutcome(2,:);
                var     = allStd(1,:);
                ind1    = sub == subNum;
                ind2    = var == variance;
                ind     = ind1 & ind2;
                
                c       = allPred(1,ind);
                d       = allOutcome(1,ind);
                n       = length(d);
                
                
                % switch fit function depending on model
                switch model
                    case 'full'
                        fit(count) = fit_opt_gaussianUMKV(d, c, variance, X0flag);
                        fit(count).subNum = subNum;
                        
                    case 'nassar'
                        fit(count) = fit_nassar(d, c, variance, X0flag);
                        fit(count).subNum = subNum;
                        
                    case {'1' '2' '3' '4' '5'}
                        % number of nodes to be fit
                        nNodes = str2num(model);
                        
                        fit(count) = fit_gaussianUMKV(nNodes, d, c, variance, X0flag);
                        fit(count).subNum = subNum;
                        
                    case {'2013n1' '2013n2' '2013n3' '2013n4' '2013n5'}
                        % number of nodes to be fit
                        nNodes = str2num(model(end));
                        
                        fit(count) = fit_gaussianUMKV_2013(nNodes, d, c, variance, X0flag);
                        fit(count).subNum = subNum;
                end
                fit(count).model = model;
                count = count + 1;
                    
                % save after every run so crashing does not lose all
                % results
                save([savedir model '_' TT])
            end
        end
        fprintf(1, '|\n')
    end
    
    

    
    
end
toc
