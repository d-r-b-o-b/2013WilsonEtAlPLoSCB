function aUp    = bernoulli_updateSufficientStats(d, a, l)
aUp = a .* (l-1)./l + d;
end
