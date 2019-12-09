clear
clc
%% parameters description
help BASWPToptim

%% set three parameters at least: objective function handle, lower bound and upper bound
% set initial step-size,sensing length and random seed
options = BASoptimset;
options.step1 = 0.5;
options.d1 = 0.4;
options.seed = 1;

fit = BASWPToptim(@Michalewicz,[],[-6,0],[-1,2],[],options);
fit.par
fit.fitness

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off
