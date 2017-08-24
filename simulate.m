function [mn, PP, plgd, XX, LK] = simulate(d, X, l, TrMat, U, lk, M)

% initialize run-length distribution
plgd = zeros(1,length(l))/length(l);
plgd(1) = 1;
mn(1,:) = plgd * (M(X, l))';
dum = plgd * (M(X, l))';

mn = nan(length(d), length(dum));
XX = nan(length(d), length(X));
PP = nan(length(d), length(plgd));

mn(1,:) = d(1);
% run simulation
for t = 1:length(d)-1
    
    XX(t,:) = X;
    PP(t,:) = plgd;
    
    xUp = U(d(t), X, l);
    
    
    lik = lk(d(t), X, l);
    if ~isreal(lik)
        a = 1;
    end
    
    X = xUp;
    
    pr = (TrMat * plgd')';
    
    pst = lik.*pr;
    if sum(pst)==0
        pst = pr;%ones(size(pst));
    end
    plgd = pst / sum(pst);
    
    
    m = M(X, l);
    mn(t+1,:) = plgd * (M(X, l))';
    
    LK(t,:) = lik;
end

XX(t+1,:) = X;
PP(t+1,:) = plgd;

end
