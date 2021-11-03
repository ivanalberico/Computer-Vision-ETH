function [w_x, w_y, E] = tps_model(X, Y, lambda)

nsamp = size(X,1);

% Defining the TPS model parameters
P = [ones(nsamp,1) X];    

K = U(sqrt(dist2(X,X)));  K(isnan(K)) = 0;

T = [ K+lambda*eye(nsamp)      P      ;
              P'           zeros(3)  ];


vx = Y(:,1); 
vy = Y(:,2);

bx = [vx; zeros(3,1)];
by = [vy; zeros(3,1)] ;


% Solving the linear system
x = T\bx;
y = T\by;

w_x = x(1:nsamp, :);
a_x = x(nsamp+1:end, :);


w_y = y(1:nsamp, :);
a_y = y(nsamp+1:end, :);


% Total bending energy
E = (w_x')*K*w_x + (w_y')*K*w_y;

% Warping coefficients 
w_x = x;
w_y = y;


end


function U_value = U(t)

if t == 0
    U_value = 0;
else
    U_value = t.^2 .* log(t.^2);
end

end