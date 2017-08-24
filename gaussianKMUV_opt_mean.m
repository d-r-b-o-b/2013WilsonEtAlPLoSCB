function m      = gaussianKMUV_opt_mean(X, l)

% variance (central moment 2)
m = sqrt(-2*X(:,2)./X(:,1));%m = sqrt(-2*X ./ l);

end
