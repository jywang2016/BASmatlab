clear
clc
%% parameters description
help BSASoptim

%% set three parameters at least: objective function handle, lower bound and upper bound
% set initial step-size,sensing length and random seed
options = BASoptimset;
options.k = 1;
options.n = 150;
options.seed = 1;

fit = BSASoptim(@GoldsteinPrice,[],[-2,-2],[2,2],[],options);
fit.par
fit.fitness

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

