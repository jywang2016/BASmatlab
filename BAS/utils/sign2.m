function y = sign2(x)
% output the sign of fleft - fright in BAS
% in the case of x equal to 0, output 1
% otherwise, output should be same with the sign()

    y = sign(x);
    
    if ismember(0,y)
        zero_flag = y == 0;
        y(zero_flag) = 1;
    end

end