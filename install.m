%% BASmatlab is a toolbox for implementation of BAS optimization algorithms in Matlab.

% Add BAS to the path

% Author: Jiangyu Wang
% Reference: manopt.m in manopt toolbox 
% Date: Apr. 1, 2019
addpath(pwd);

cd BAS; 
addpath(genpath(pwd));
cd ..; 

cd demo;
addpath(genpath(pwd));
cd ..; 

disp('BAS was added to Matlab''s path.');

disp('%---------installation----------%');
savePath_flag = input('Save path for future Matlab sessions?[y/n]','s');
if strcmpi(savePath_flag, 'y')
    flag = savepath();
    if ~flag
        disp('path was saved');
    else
        error('something was wrong in savepath() functions');
    end
else
    disp('path was not saved: install.m needs to be executed next-time');
end