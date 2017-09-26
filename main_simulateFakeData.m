% generates fake data based on observations seen by subjects in the
% experiment.  To generate more fake data increase nRepeats.

clear

directories;
datadir   = [maindir 'data/'];
savedir   = [maindir 'fakedata/']; mkdir(savedir);

load([datadir 'dataForBob'])


TT = datestr(now);
TT( (TT=='-') | (TT==' ') | (TT==':') ) = '';
savename = ['fakeData_' TT];

count = 1;

model = {'full' 'nassar' '1' '2' '3'};
vc = [5 10];
nRepeats = 1;
for m = 1:length(model)
    disp(model{m})
    fprintf(1, ' |');
    for rep = 1:nRepeats
        if mod(round(rep/nRepeats*100),10) == 0
            fprintf(1, '.')
        end
        
        % extract data seen by subject ------------------------------------
        % subject number
        for subNum = 1:30
            % variance condition (really standard deviation)
            for v = 1:length(vc)
                
                variance = vc(v);
                
                % extract data for this subject in this variance condition
                sub     = allOutcome(2,:);
                var     = allStd(1,:);
                ind1    = sub == subNum;
                ind2    = var == variance;
                ind     = ind1 & ind2;
                d       = allOutcome(1,ind);
                % ---------------------------------------------------------
                
                switch model{m}
                    
                    case {'1' '2' '3' '4' '5'}
                        nNodes = str2num(model{m});
                        [ch, PARS] = fake_gaussianUMKV(nNodes, d, variance);
                    
                    case 'full'
                        [ch, PARS] = fake_gaussianUMKV_opt(d, variance);
                    
                    case 'nassar'
                        [ch, PARS] = fake_nassar(d, variance);
                        
                end
                
                
                % store simulation results in SIM structure
                SIM(count).model    = model{m};
                SIM(count).var      = variance;
                SIM(count).d        = d;
                SIM(count).c        = ch';
                SIM(count).X        = PARS;
                count = count + 1;
            end
        end
    end
    fprintf(1, '|\n');
    save([savedir savename], 'SIM')
end

disp(' ')
