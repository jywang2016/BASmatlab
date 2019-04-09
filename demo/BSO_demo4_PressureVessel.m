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
options.step1 = 40;
options.d1 = 20;
options.n = 500;
options.vmax = 5.12;
options.vmin = -5.12;
options.seed = 123;
options.wstepmax = 0.9;
options.wstepmin = 0.4;
options.penalty = 1e4;

fit = BSOoptim(objective,constraint,[1,1,10,10],[100,100,200,200],[],options);
%fit.par 
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
