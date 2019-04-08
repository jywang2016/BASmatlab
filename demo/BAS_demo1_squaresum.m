clear
clc
%% parameters description
help BASoptim

%% set three parameters at least: objective function handle, lower bound and upper bound
fit = BASoptim(@SquareSums,[],[-2,-2,-2,-2],[2,2,2,2]);
fit.par
fit.fitness

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

%% set random seed to make the fit reproducible
options = BASoptimset;
options.seed = 1;
fit1 = BASoptim(@SquareSums,[],[-2,-2,-2,-2],[2,2,2,2],[],options);

%% set steptol to terminate optimization
% the optimization stops when the step size is less than 'steptol': step <
% steptol
options.steptol = 0.1;
fit2 = BASoptim(@SquareSums,[],[-2,-2,-2,-2],[2,2,2,2],[],options);

[fit1.iterations fit2.iterations]
[fit1.step fit2.step]