function fit = fit_gaussianUMKV_2013(nNodes, d, c, variance, X0flag)

% setup objective function
obFunc = @(x) obFunc_gaussianUMKV_2013(x, d, c, variance);

% initial conditions
switch X0flag
    case 1
        % initial
        X0 = [0.1 1 1:nNodes];
    case 2
        % second time
        X0 = [0.1 1 logspace(log10(1), log10(length(d)/10), nNodes)];
        
    otherwise
        
        switch mod(round(100*rand),3)
            
            case 0
                X0 = [rand 10*rand 1:nNodes];
                
            case 1
                X0 = [rand 10*rand logspace(log10(1), log10(length(d)/10), nNodes)];
                
            case 2
                X0 = [rand 10*rand sort(rand(1,nNodes)*length(d)/5)+[0:nNodes-1]];
                
            case 3
                X0 = [rand 10*rand 10.^(sort(rand(1,nNodes)*log10(length(d)/5)))+[0:nNodes-1]];
                
        end
end

% bounds
LB(1, 1:length(X0)) = 1;
UB(1, 1:length(X0)) = length(d);
LB(1,1) = 0;
UB(1,1) = 1;
LB(1,2) = 0;
UB(1,2) = 50;%Inf;

% linear constraints (run-lengths must be ordered, i.e. l_{i+1} > l_i)
if length(X0) < 4
    A = []; B = [];
else
    
    for i = 3:length(X0)-1
        A(i,i) = 1;
        A(i,i+1) = -1;
    end
    B = zeros(size(A,1),1);
    B(1) = 0; B(2) = 0;
end

% set optimization options
options = optimset('MaxFunEvals', 100, 'TolFun', 1e-40, ...
   'FinDiffType', 'central', 'algorithm', 'active-set', 'display', 'off');

try
    [X, val,~,~,~,~,hess] = fmincon(obFunc, X0,A,B,[],[],LB,UB,[], options);
catch
    X = nan; val = nan; hess = nan;
end
n = length(d);
if nNodes == 1
    % for simplicity of code, 1-node case also has a redundant hazard rate
    % parameter that does not affect fit.  So one parameter must be removed
    % for computing BIC in 1-node case
    BIC      = 2*val + (length(X)-1)*log(n);
else
    BIC      = 2*val + length(X)*log(n);
end



fit.X = X;
fit.val = val;
fit.BIC = BIC;
fit.hessian = hess;
fit.detH = det(hess);
fit.nNodes   = nNodes;
fit.var      = variance;
fit.n        = length(d);
fit.subNum   = nan; % placeholder
fit.model = nan; % placeholder