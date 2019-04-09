function fit = BSOoptim2(f,constraint,lower,upper,init,options)
    % fit = BSOoptim(@f,@constraint,lower,upper)
    % fit = BSOoptim(@f,@constraint,lower,upper,options)
    % @f, the objective function handle
    % @constraint, the constraint function handle
    % lower & upper, bounds of inputs
    %       lower and upper should be row vectors, i.e. [1,1,1,1] & [2,2,2,2]
    % init, the initial value of inputs, if it was not specified
    %       the program will generate a random vector between lower and
    %       upper
    %
    % options, a struct of the parameters of BAS-based algorithm
    %
    % See also:
    % BASoptimset
    
    % check the inputs number
    if nargin < 4
        error('Inputs need include f,constraint,lower,upper at least');
    end
    
    % check the dims of lower and upper
    dims = size(lower);
    dims_flag = dims == size(upper);
    if(ismember(0,dims_flag))
        error('Check the dims of ''lower'' and ''upper''');
    end
    
    % compart lower and upper
    value_flag = lower < upper;
    if(ismember(0,value_flag))
        error('''lower''should be smaller than ''upper''');
    end
    
    if nargin < 6 || isempty(options) 
        options = BASoptimset; 
    end
    
    if ~isempty(options.seed)
        rng(options.seed);
    end
    
    %   generate a init vector randomly
    if isempty(options.s)
       dim_tmp = size(lower);
       options.s = floor(10+2*sqrt(dim_tmp(2)));
    end
    
    if isempty(init) 
        init = initialize(options.s, lower, upper);
    else
        dim_init = size(init);
        if dim_init(1) <= options.s
            tmp_init = initialize(options.s, lower, upper);
            tmp_init(1:dim_init(1),:) = init;
            init = tmp_init;
        else
            error('The dims of init exceed');
            %options.s = dim_init(1);
        end
    end

    if nargin > 6 
        error('There are too much inputs.');   
    end
    
    %-----------------------------------------
    step0 = options.step0;
    step1 = options.step1;
    %eta_step = options.eta_step;
    
    d0 = options.d0;
    d1 = options.d1;
    %eta_d = options.eta_d;
    
    n = options.n;
    
    trace = options.trace;
    steptol = options.steptol;
    penalty = options.penalty;
    
    % for BSO
    % beetles' velocity
    vmax = options.vmax;
    vmin = options.vmin;
    
    % weights of step-size updating
    wstepmax = options.wstepmax;%0.9;
    wstepmin = options.wstepmin;%0.2;
    
    % weights of velocity updating
    wvmax = options.wvmax;%0.9
    wvmin = options.wvmin;%0.4
    
    % weights of positions updating
    lambda = options.lambda;%0.4;
    s = options.s; %swarm size
    %(when no better solutions can be found), parameters will be forced to
    %update
    %-----------------------------------------
    
    % the initialization
    x = init;
    fx = fconstriant(x,f,constraint,penalty);

    %global
    [fgbest,bestindex] = min(fx);
    xgbest = x(bestindex,:); %global best
    
    %beetle
    xpbest = x; %best for each pop
    fpbest = fx;
    
    % fit table
    fit_table = zeros(n,s);
    fit_table(1,:) = fx;
    % v
    v = 0.5*rands(s,dims(2));
    x_store = [0,xgbest,fgbest];
    
    if(trace)
        display(['0:','xbest=[',num2str(xgbest),'],fbest=',num2str(fgbest)])
    end
    
    for i = 1:n
        c1 = 1.3 + 1.2*(cos(i*pi)/n);
        c2 = 2   - 1.2*(cos(i*pi)/n);
        wv = wvmax - (wvmax - wvmin)*(i/n);
        
        for j = 1:s
            xleft = x(j,:) + v(j,:) * d1/2;
            xleft = bounds(xleft,upper,lower);
            fleft =  fconstriant(xleft,f,constraint,penalty);
            xright = x(j,:) - v(j,:) * d1/2;
            xright = bounds(xright,upper,lower);
            fright =  fconstriant(xright,f,constraint,penalty);
            term_BAS = step1.*v(j,:).*sign(fleft-fright);
            
            v(j,:) = wv *v(j,:) + c1*rand*(xpbest(j,:) - x(j,:)) ...
                + c2*rand*(xgbest - x(j,:));
            v(j,:) = bounds(v(j,:),vmax,vmin);
            
            x(j,:) = x(j,:) + lambda*v(j,:) + (1 - lambda)*term_BAS;
            x(j,:) = bounds(x(j,:),upper,lower);
            
            fx(j) = fconstriant(x(j,:),f,constraint,penalty);
            fit_table(i+1,j) = fx(j);
        end

        % gbest and pbest update
        for j = 1:s
            if fx(j) < fpbest(j)
                fpbest(j) = fx(j);
                xpbest(j,:) = x(j,:);
            end
            
            if fx(j) < fgbest
                xgbest = x(j,:);
                fgbest = fx(j);
            end
        end
        
        % collect data
        x_store = cat(1,x_store,[i,xgbest,fgbest]);

        if(trace)
             display([num2str(i),':xbest=[',num2str(xgbest),'],fbest=',num2str(fgbest)])
        end
        
        if step1 < steptol
            disp('The optimization terminate : step < steptol');
            break;
        end
        
        % parameters update
        eta = wstepmin * (wstepmax/wstepmin)^(1/(1+10*i/n));
        step1 = step1 * eta + step0;
        d1 = d1 * eta + d0;
    end
    fbest_store = x_store(:,(2+dims(2)));
    
    fit.par = xgbest;
    fit.fitness = fgbest;
    fit.popdetail = fit_table;
    fit.data = x_store;
    fit.best = fbest_store;
    fit.step = step1;
    fit.iterations = i;
end
