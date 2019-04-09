function options = BASoptimset(varargin)
    % BASoptimset func creates parameters for BAS and BAS-based algorithm
    % Syntax:
    % options = BASoptimset
    % options = BASoptimset()
    % options = BASoptimset('par name',par value)
    % i.e. modify the iterations(default 100)
    % options = BASoptimset('n',200)
    %
    %
    % step0, the resolution of step-size, default eps
    % step1, the initial value of step-size, default 1
    % eta_step, a coefficient of step-size decay, range from 0 to 1
    %       default 0.95
    %
    % d0, the resolution of sensing length of antennae, default eps
    % d1, the initial value of sensing length of antennae
    % eta_d, similar to eta_step, default 0.95
    %
    % n, iterations, default 100
    %
    % seed, random seed to make the fit reproducible
    %
    % trace,track the iterations, default 0, namely display nothing
    %
    % steptol, optimization will terminate when step-size is less than
    % steptol,defalut eps
    %
    % penalty, penalty coefficient for constraint violations, default 1e5
    %
    % for BSAS:
    % k, number of tentacles pairs,it also indicates the beetles number in 
    %    each optimization stage, default 2
    % Pgreedy, the probability of being greedy when find better positions
    %    default 0.8
    %
    % PstepUpdate, the prob of updating step when cannot find better positions
    %   default 0.8
    %
    % nflag, if the step-size is not updated over nflag times
    %   (when no better solutions can be found), parameters will be forced to
    %   update
    options.step0 = eps;
    options.step1 = 0.8;
    options.eta_step = 0.95;
    
    options.d0 = eps;
    options.d1 = 2;
    options.eta_d = 0.95;
    
    options.n = 100;
    options.seed = [];
    
    options.trace = 0;
    options.steptol = eps;
    options.penalty = 1e5;
    
    % for BSAS
    options.k = 2;
    options.Pgreedy = 0.8;
    options.PstepUpdate = 0.8;
    options.nflag = 3;
    
    % for BSO
    options.vmax = 5; % beetles' velocity
    options.vmin = -5;
    options.wstepmax = 0.9; % weights of step-size updating
    options.wstepmin = 0.4;
    options.wvmax = 0.9;% weights of velocity updating
    options.wvmin = 0.4;
    options.lambda = 0.4;% weights of positions updating
    options.s = []; % swarm size
    
    % the following field matching tech is referred to the PSOmatlab
    % toolbox
    % url: https://github.com/sdnchen/psomatlab/blob/master/psooptimset.m
    fields = fieldnames(options);
    for i = 1:size(fields,1)
        idx = find(cellfun(@(varargin)strcmpi(varargin,fields{i,1}),...
            varargin)) ;
        if ~isempty(idx)
            options.(fields{i,1}) = varargin(idx(end) + 1) ;
            options.(fields{i,1}) = options.(fields{i,1}){:} ;
        end 
    end 
end