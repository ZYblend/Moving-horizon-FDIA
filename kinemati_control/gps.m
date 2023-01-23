function y3 = gps(x)
%gps: measurement for x,y and theta

C=[ 0, 1, 0;
    0, 0,1];
y3=C*x;
end

