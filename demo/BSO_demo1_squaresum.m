clear
clc
%% parameters description
help BSOoptim

%% set three parameters at least: objective function handle, lower bound and upper bound
options = BASoptimset;
options.step1 = 2;
options.d1 = 1;
options.n = 200;
options.vmax = 5.12;
options.vmin = -5.12;
options.seed = 1;
options.lambda = 0.4;
options.penalty = 1e4;

fit = BSOoptim(@SquareSums,[],[-2,-2,-2,-2],[2,2,2,2],[],options);

fit.par
fit.fitness

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

figure(2)
plot(fit.popdetail)
xlabel('iteration')
ylabel('fitness of each individual')