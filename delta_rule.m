function v = delta_rule(d, alpha, v0)

v(1) = v0;
for t = 1:length(d)-1
    v(t+1) = v(t) + alpha * (d(t) - v(t));
end