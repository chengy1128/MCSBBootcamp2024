
% Define the system of differential equations with constants
function dydt = odefun(t, y,a, b,e)
    dydt = zeros(2, 1);
    dydt(1) =  y(1)-1/3*y(1)^3-y(2);%dv/dt = v-1/3v^3-w
    dydt(2) =e*(y(1)+a-b*y(2));%dw/dt=e(v+a-bw))
end

% Set the constants
e=0.08;
a=1;
b=0.2;

% Set the time span and initial conditions
tspan = [0 100];
y0 = [0; -0.5];

% Create a function handle that includes the constants
odefun_with_constants = @(t, y) odefun(t, y, a, b,e);

% Solve the ODE system
[t, y] = ode45(odefun_with_constants, tspan, y0);

% Plot the results
plot(t, y(:,1), 'b-', t, y(:,2), 'r--');
xlabel('Time');
ylabel('Solution');
legend('v - y(1)', 'w -y(2)');
title('Solution of the ODE System with FitzHughNagumo');
grid on;