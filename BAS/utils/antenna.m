function [xleft, xright] = antenna(x,dir,d)
    size_dir = size(dir);
    n = size_dir(1); % n == k;
    
    if n == 1 %for BAS
        xleft = x + dir*d/2;
        xright = x - dir*d/2;
    else % for BSAS
        %n = size_dir(1); % n == k;
        dims = size_dir(2);
        
        xleft = zeros(n,dims);
        xright = zeros(n,dims);
        for i = 1:n
            xleft(i,:) = x + dir(i,:)*d/2;
            xright(i,:) = x - dir(i,:)*d/2;
        end
    end

end

%test
% dir = directions(3,2)
% x = zeros(3,2)
% d = 2
% [xleft,xright] = antenna(x,dir,d)