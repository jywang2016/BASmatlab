function dir = directions(n,dims)
%     if(nargin < 2)
%         n = 1;
%     end
%   rand(positive) or rands ? Do negative values matter?
    dir = rands(n,dims);%rand(n,dims);
    if n == 1 % for BAS
        dir = dir/(eps + norm(dir));
    else % for BSAS
        tmp = zeros(n,dims);
        for i = 1:n
            tmp(i,:) = dir(i,:)/(eps + norm(dir(i,:)));
        end
        dir = tmp;
    end
end