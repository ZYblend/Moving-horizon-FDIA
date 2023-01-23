function y1 = imu(z)
%gyroscope: for measurement v and w

% C= [1, 0, 0;
%     0, 1, 0;
%     0, 0, 1];


Ts = 0.01;
C = [0.3205    0.6142    0.7597;
    0.9724    0.5608    0.1071;
    0.4098    0.4219    0.0856];

y1=C*z;
end

