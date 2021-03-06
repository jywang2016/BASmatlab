clear
clc
%% parameters description
help BASoptim

%% set three parameters at least: objective function handle, lower bound and upper bound
% set initial step-size,sensing length and random seed
options = BASoptimset;
options.step1 = 0.8;
options.d1 = 2;
options.seed = 1;

fit = BASWPToptim(@GoldsteinPrice,[],[-2,-2],[2,2],[],options);
fit.par
fit.fitness

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

