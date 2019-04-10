function fit = BASoptim(f,constraint,lower,upper,init,options)
    % fit = BASoptim(@f,@constraint,lower,upper)
    % fit = BASoptim(@f,@constraint,lower,upper,options)
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
    if nargin < 5 || isempty(init) 
        init = lower + (upper - lower).*rand(size(lower));
    end

    if nargin > 6 
        error('There are too much inputs.');   
    end
    
    %-----------------------------------------
    step0 = options.step0;
    step1 = options.step1;
    eta_step = options.eta_step;
    
    d0 = options.d0;
    d1 = options.d1;
    eta_d = options.eta_d;
    
    n = options.n;
    
    trace = options.trace;
    steptol = options.steptol;
    penalty = options.penalty;
    %-----------------------------------------
    
    % the initialization
    x = init;
    xbest = x;
    %fbest = f(xbest);
    fbest = fconstriant(xbest,f,constraint,penalty);
    fbest_store = fbest;
    x_store = [0,x,fbest];
    
    if(trace)
        display(['0:','xbest=[',num2str(xbest),'],fbest=',num2str(fbest)])
    end
    
    for i = 1:n
        
        dir = directions(1,dims(2));    
        [xleft, xright] = antenna(x,dir,d1);
        xleft = bounds(xleft,upper,lower);
        xright = bounds(xright,upper,lower);
        
        fleft = fconstriant(xleft,f,constraint,penalty);%f(xleft);
        fright = fconstriant(xright,f,constraint,penalty);%f(xright);
        
        x = xupdate(x,step1,dir,fleft,fright);
        x = bounds(x, upper, lower);
        
        fx = fconstriant(x,f,constraint,penalty);%f(x);
        
        if fx < fbest
            xbest = x;
            fbest = fx;
        end
        
        x_store = cat(1,x_store,[i,x,fx]);
        fbest_store = [fbest_store;fbest];
        if(trace)
             display([num2str(i),':xbest=[',num2str(xbest),'],fbest=',num2str(fbest)])
        end
        
        [step1,d1] = pupdate(step1,d1,eta_step,eta_d,step0, d0);
        
        if step1 < steptol
            disp('The optimization terminate : step < steptol');
            break;
        end
    end
    
    fit.par = xbest;
    fit.fitness = fbest;
    fit.data = x_store;
    fit.best = fbest_store;
    fit.step = step1;
    fit.iterations = i;
end
