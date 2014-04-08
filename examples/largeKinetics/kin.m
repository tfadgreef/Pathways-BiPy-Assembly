function dx = kin( t, x, par, N )
%% Input Arguments
% par(1)        Positive rate constant
kp = par(1);
% par(2)        Negative rate constant
km = par(2);

dx = zeros(N, 1); % Set all derivatives to zero

%% Help Variables
% sum x(i) for i=2:neq
h1 = 0;
for i=2:N
    h1 = h1 + x(i);
end

%% Equations
% The first one is exceptional
dx(1) = -2*kp*(x(1)^2) + km*x(2) + km*h1 - kp*x(1)*h1;

for i=2:(N-1)
    dx(i) = kp*x(1)*(x(i-1) - x(i)) + km*(x(i+1) - x(i));
end

% For i=N
dx(N) = kp*x(1)*(x(i-1) - x(i));

%% functionend
