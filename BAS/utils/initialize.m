function init = initialize(s,lower,upper)
    % for initialization of BSO
    % generate a swarm size * npars matrix between lower and upper
    tmp_upper = repmat(upper,s,1);
    tmp_lower = repmat(lower,s,1);
    init = tmp_lower + (tmp_upper - tmp_lower).*rand(size(tmp_lower));
end