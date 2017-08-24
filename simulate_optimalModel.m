function [mn, PP, plgd] = ...
    simulate_optimalModel(d, X, H, U, lk, M)

plgd(1) = 1;

mn(1,:) = plgd * (M(X))';
xPrior = X;

for t = 1:length(d)-1
    
    PP(t,1:length(plgd)) = plgd;
    
    % p(x_t | l_t, x_{1:t-1}) = likelihood
    pXgL = lk(d(t), X);
    pXgL = pXgL' / sum(pXgL);
    
    lik = [pXgL(1) pXgL];
    
    % update sufficient stats
    Xnew = U(d(t), X);
    Xup = [xPrior; Xnew];
    
    % prior
    h   = H(length(plgd));
    pr  = [plgd*h, plgd.*(1-h)'];
    
    wNew        = lik.*pr;
    plgd        = wNew / nansum(wNew);
    
    X = Xup;
    
    mn(t+1,:) = plgd * (M(X));
    
end

PP(t+1,1:length(plgd)) = plgd;

end
