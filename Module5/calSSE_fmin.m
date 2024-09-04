function SSE = calSSE_fmin(dataPath, initial, params)
    % Unpack parameters
    lambda = params(1);
    theta = params(2);
    alpha = params(3);

    % Define the ODE function
    function dNdt = BacterialGrowth(t, N)
        dNdt = lambda * N * (1 - N / theta)^alpha;
    end

    % Define the time span
    tspan = linspace(0, 10, 49);

    % ode45
    [T, N] = ode45(@BacterialGrowth, tspan, initial);

    % Load the experimental data
    data = readtable(dataPath);
    % time = data{:, 1};  % Assuming first column is time
    growth = data{:, 2};  % Assuming second column is growth data
    % Calculate SSE
    differences = N - growth;
    SSE = sum(differences .^ 2);
end
