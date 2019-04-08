function newx = xupdate(x,step,dir,fleft,fright)
% the bettle postion updates

% the swarm strategy needs to be considered 
% vector or matrix opreation
    size_dir = size(dir);
    n = size_dir(1); % n == k;
    if n == 1
        newx = x - step.*dir*sign2(fleft - fright);
    else
        newx = repmat(x,n,1);
        for i = 1:n
            newx(i,:) = x - step.*dir(i,:)*sign2(fleft(i) - fright(i));
        end
    end
end