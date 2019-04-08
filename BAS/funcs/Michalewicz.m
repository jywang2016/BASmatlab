function y = Michalewicz(x)
  y1 = -sin(x(1))*(sin((x(1)^2)/pi))^20;
  y2 = -sin(x(2))*(sin((2*x(2)^2)/pi))^20;
  y = y1 + y2;
end