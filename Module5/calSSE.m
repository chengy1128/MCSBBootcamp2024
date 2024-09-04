function SSE = calSSE(dataPath, initial, lambda, theta, alpha)
    % Define the ODE function
    function dNdt = BacterialGrowth(t, N)
        dNdt = lambda * N * (1 - N / theta)^alpha;
    end

    % Define the time span (becareful align with experimental data time)
    tspan = linspace(0, 10, 49);

    % Solve the ODE using ode45
    [T, N] = ode45(@BacterialGrowth, tspan, initial);

    % Load the experimental data
    data = readtable(dataPath);

    % Assuming the first column is time and the second is bacterial growth
    % time = data{:, 1};  % Extract the time column
    growth = data{:, 2};  % Extract the growth data column
    % P.S. orders may change

    % % Interpolate N at experimental time points
    % Ninterp = interp1(T, N, time);

    % Calculate SSE
    differences = N - growth;
    squaredDifferences = differences .^ 2;
    SSE = sum(squaredDifferences);

    % Output the SSE
    disp(['Sum of Squared Errors (SSE) = ', num2str(SSE)]);
end
