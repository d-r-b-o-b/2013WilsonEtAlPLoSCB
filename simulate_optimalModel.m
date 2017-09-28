function [mn, PP, plgd] = simulate_optimalModel(d, X, H, U, lk, M)

plgd(1) = 1;
pr = 1;

mn(1,:) = plgd * (M(X))';
xPrior = X;

for t = 1:length(d)-1
    
    
    
    
    
    % p(x_t | r_{t-1}) = likelihood
    pXgL = lk(d(t), X);
    lik = pXgL' / sum(pXgL);
    
    % p(r_t | x_{1:t}) = run-length distribution
    wNew = lik.*pr;
    plgd = wNew / nansum(wNew);
    
    % update sufficient stats
    Xnew = U(d(t), X);
    Xup = [xPrior; Xnew];
    X = Xup;
    
    % compute prior for next time step, p(r_{t+1} | x_{1:t})
    h   = H(length(plgd));
    pr  = [plgd*h, plgd.*(1-h)'];
    
    % prediction for next time step assuming possibility of change
    % mn(t+1,:) = pr * (M(X));
    
    % prediction for next time step assuming no change
    mn(t+1,:) = [0, plgd] * (M(X));
    
    PP(t,1:length(plgd)) = plgd;
    
end

PP(t+1,1:length(plgd)) = plgd;

end
