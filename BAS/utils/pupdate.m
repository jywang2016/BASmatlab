function [newstep,newd] = pupdate(step,d,eta_step,eta_d, ...
    step0, d0)
    if (nargin < 5)
        step0 = 0;
        d0 = 0;
    end
    % parameters update
    newstep = step*eta_step + step0;
    newd = d*eta_d + d0;
end