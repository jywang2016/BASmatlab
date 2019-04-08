function ynew = fconstriant(x,f,constraint,penalty)
    %ynew = f(x) + constriant(x);
    size_x = size(x);
    n = size_x(1);
    
    
    if n == 1
        if ~isempty(constraint)
            fconstr = constraint(x);
            n_violation = sum(fconstr(:) > 0);
            ynew = f(x) + penalty * n_violation;
        else
            ynew = f(x);
        end
    else
        ynew = zeros(n,1);
         if ~isempty(constraint)
             n_violation = zeros(n,1);
            for i = 1:n
                fconstr = constraint(x(i,:));
                n_violation(i) = sum(fconstr(:) > 0);
                ynew(i) = f(x(i,:)) + penalty * n_violation(i);
            end
         else
            for i = 1:n
                ynew(i) = f(x(i,:));
            end
         end
    end
end