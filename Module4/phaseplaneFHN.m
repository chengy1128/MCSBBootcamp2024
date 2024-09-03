% model parameters
eps = 0.08;
a = 0.5;
b = 0.2;

% model definition
f = @(v,w) v - 1/3*v.^3 - w;
g = @(v,w) eps*(v + a -b*w);

%% single cell
dxdt =@ (t,x) [f(x(1),x(2)); g(x(1),x(2));];

% % solve!
[T,X] = ode45(dxdt,[0,1000], [-0,-0.5]);

% % part2
a_1=1.0;
f = @(v,w) v - 1/3*v.^3 - w;
g_p2 = @(v,w) eps*(v + a_1 -b*w);

dxdt_p2 =@ (t,x) [f(x(1),x(2)); g_p2(x(1),x(2));];
% Case 1 v0=-1.5, w0=-0.5
[T,X1] = ode45(dxdt_p2,[0,1000], [-1.5,-0.5]);
% Case 2 v0=0, w0=-0.5
[T,X2] = ode45(dxdt_p2,[0,1000], [0,-0.5]);

figure(405); clf; hold on;
set(gca, 'xlim', [-2.5, 2.5], 'ylim', [-2.5,2.5])
ylabel('w');
xlabel('v')

uArray = linspace(-2.5, 2.5,32);
wArray = linspace(-2.5, 2.52,32);

[uMesh,wMesh] = meshgrid(uArray, wArray);

% the Matlab plot command for a field of arrows is:
quiver(uMesh, wMesh, f(uMesh, wMesh), g_p2(uMesh,wMesh), 0.5)

plot(X(:,1),X(:,2),'-r')
plot(X(end,1),X(end,2), 'or')


% Plot v versus w for the first initial condition
figure;
plot(X1(:,1), X1(:,2), 'b-'); % Blue line for the first condition
hold on;

% Plot v versus w for the second initial condition
plot(X2(:,1), X2(:,2), 'r-'); % Red line for the second condition
steady_state_1 = X1(end, :)
steady_state_2 = X2(end, :)%  -1.1297   -0.6490
uArray = linspace(-2.5, 2.5,32);
wArray = linspace(-2.5, 2.52,32);

[uMesh,wMesh] = meshgrid(uArray, wArray);

% the Matlab plot command for a field of arrows is:
quiver(uMesh, wMesh, f(uMesh, wMesh), g_p2(uMesh,wMesh), 0.5)

% Add labels and title
xlabel('v(t)');
ylabel('w(t)');
title('Phase Plane Plot: v(t) vs w(t)');
legend('Initial Condition: v(0) = -1.5, w(0) = -0.5', ...
       'Initial Condition: v(0) = 0.0, w(0) = -0.5', ...
       'Location', 'Best');
grid on;



%% include I(t) current and stimulate at t=40~47
%a=1.0
a_2 = 1.0;
% Current injection parameters
I0 = 1.0;
tStart = 40;
tStop = 47;
I = @(t) I0*(t > tStart).*(t < tStop); % Current injection function
% model definition
f_2 = @(v,w,t) v - 1/3*v.^3 - w+I(t);
g_2 = @(v,w) eps*(v + a_2 -b*w);

% Define ODE system
dxdt_I = @(t,x) [f_2(x(1), x(2), t); g_2(x(1), x(2))];

% Set initial conditions close to the steady state
initial_conditions = [-1.1297   -0.6490];  % Use your calculated steady state values

% Simulate over time period, including the injection time
[T, X_I] = ode45(dxdt, [0, 100], initial_conditions);
% Plot v(t) and w(t) over time

set(gca, 'xlim', [-2.5, 2.5], 'ylim', [-2.5,2.5])
ylabel('w');
xlabel('v')
figure
plot(X_I(:,1), X_I(:,2), 'k-', 'LineWidth', 2);
title('Phase Plane Plot: v(t) vs w(t) with I (t)');
xlabel('v(t)');
ylabel('w(t)');
grid on;

% question3
% model definition
f_3 = @(v,w,t) v(i) - 1/3*v(i).^3 - w(i)+I(t)+D(v(i-1)-2*v(i)+v(i+1));
g_3 = @(v,w) eps*(v(i) + a_2 -b*w(i));