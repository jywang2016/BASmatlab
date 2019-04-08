clear
clc
%% parameters description
help BSASoptim

%% set three parameters at least: objective function handle, lower bound and upper bound
options = BASoptimset;
fit = BSASoptim(@SquareSums,[],[-2,-2,-2,-2],[2,2,2,2],[],options);
fit.par
fit.fitness

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

