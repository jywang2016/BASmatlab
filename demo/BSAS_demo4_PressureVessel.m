clear
clc
%% parameters description
help BASoptim

%% Pressure_Vessel
PV = Pressure_Vessel;
objective = PV.obj;
constraint = PV.con;

%% set three parameters at least: objective function handle, lower bound and upper bound
% set initial step-size,sensing length and random seed

options = BASoptimset;
options.k = 2;
options.step1 = 100;
options.d1 = 5;
options.n = 200;
options.seed = 5;

fit = BSASoptim(objective,constraint,[1,1,10,10],[100,100,200,200],[],options);
fit.par 
fit.fitness %6140.3

% use the last fit.par as the initial values and increase k
options.k = 6;
options.step1 = 10;
options.d1 = 5;
options.seed = 1;
fit1 = BSASoptim(objective,constraint,[1,1,10,10],[100,100,200,200],fit.par,options);
fit1.par
fit1.fitness %6130.5

figure(1),clf(1),
plot(fit.data(:,1),fit.data(:,end),'r-o')
hold on
plot(fit.data(:,1),fit.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

figure(2),
plot(fit1.data(:,1),fit1.data(:,end),'r-o')
hold on
plot(fit1.data(:,1),fit1.best,'b-.')
xlabel('iteration')
ylabel('minimum value')
hold off

