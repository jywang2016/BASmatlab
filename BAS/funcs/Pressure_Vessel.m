function f = Pressure_Vessel
   %obj
   f.obj = @obj;
   %con
   f.con = @con;
end

function fobj = obj(x)
    x1 = floor(x(1)) * 0.0625;
    x2 = floor(x(2)) * 0.0625;
    x3 = x(3);
    x4 = x(4);
    fobj = 0.6224*x1*x3*x4 + 1.7781*x2*x3^2 + ...
        3.1611*x1^2*x4 + 19.84*x1^2*x3;
end

function fcon = con(x)
    x1 = floor(x(1)) * 0.0625;
    x2 = floor(x(2)) * 0.0625;
    x3 = x(3);
    x4 = x(4);
    fcon = [0.0193*x3 - x1,0.00954*x3 - x2,...
        750.0*1728.0 - pi*x3^2*x4 - 4/3*pi*x3^3];
end

% test
% h = Pressure_Vessel;
% h.obj([14.9,7.8762,43.51377,159.87]); %   6.3094e+03
% sum(h.con([14.9,7.8762,43.51377,159.87]) > 0)