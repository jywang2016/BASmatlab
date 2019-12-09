function x_nor = normalize(x,upper,lower)
% the normalization of beetle(or antenna) postion
    x_nor = (x - lower)./(upper - lower);
end