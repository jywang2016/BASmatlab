function fit = BSOoptim(f,constraint,lower,upper,init,options)
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
    
    % compare lower and upper
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
        dim_init = size(init,1);
        if dim_init <= options.s
            tmp_init = initialize(options.s, lower, upper);
            tmp_init(1:dim_init,:) = init;
            init = tmp_init;
        else
            options.s = dim_init;
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
        
        [xleft, xright] = antenna(x,v,d1);
        
        xleft = bounds(xleft,upper,lower);
        xright = bounds(xright,upper,lower);
        
        fleft = fconstriant(xleft,f,constraint,penalty);%f(xleft);
        fright = fconstriant(xright,f,constraint,penalty);%f(xright);
        
        %tmp_sign = repmat(sign2(fleft - fright),1,s);
        term_BAS = step1.*v.*sign2(fleft - fright);
        
        % v updates
        tmp_xgbest = repmat(xgbest,s,1);
        tmp_rand = repmat(rand(s,1),1,dims(2));
        v = wv.*v + c1*tmp_rand.*(xpbest - x) + c2*tmp_rand.*(tmp_xgbest - x);
        v = bounds(v,vmax,vmin);
       
        
        % x updates
        x = x + lambda.*v + (1-lambda).*term_BAS;
        x = bounds(x,upper,lower);
        fx = fconstriant(x,f,constraint,penalty);
        fit_table(i,:) = fx;
        
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

        % pars update
        % [step1,d1] = pupdate(step1,d1,eta_step,eta_d,step0,d0);
        
        % collect data
        x_store = cat(1,x_store,[i,xgbest,fgbest]);

        if(trace)
             display([num2str(i),':xbest=[',num2str(xgbest),'],fbest=',num2str(fgbest)])
        end
        
        if step1 < steptol
            disp('The optimization terminate : step < steptol');
            break;
        end
        
        % dynamic parameters
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
