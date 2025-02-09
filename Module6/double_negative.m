%% 5.0 ----- DOUBLE NEGATIVE FEEDBACK -----

noisiness = 0.1;
noisiness2 = 0.1;

figure(); clf; 
numRuns = 100;%1000
input_concentration = linspace(0.1, 10, numRuns); %

storage_A = zeros(1,numRuns);
storage_B = zeros(1,numRuns);
In_storage_A=zeros(1,numel(input_concentration));
In_storage_B=zeros(1,numel(input_concentration));
for i_input = 1:numel(input_concentration)          
   for iRun = 1:numRuns
                    
    delta_ma = 1*(1+noisiness*rand());
    gamma_pa = 1*(1+noisiness*rand());
    delta_pa = 1*(1+noisiness*rand());
    
    delta_mb = 1*(1+noisiness*randn());
    gamma_pb = 1*(1+noisiness*rand());
    delta_pb = 1*(1+noisiness*rand());
    
    Kba = 1*(1+noisiness2*randn()); % Strength (IC50^-1) of inhibition of A by B
    Kaa = 0;
    gamma_ma =@(pb) 3./(1+abs(Kba*pb).^3);
    
    Kab = 1*(1+noisiness2*randn()); % Strength (IC50) of inhibition of B by A
    Kbb = 0;
    gamma_mb =@(pa) 3./(1+abs(Kab*pa).^3);

    dmadt =@(ma,pa,mb,pb,t) +gamma_ma(pb) - delta_ma*ma*i_input;
    dpadt =@(ma,pa,mb,pb,t) +gamma_pa*ma - delta_pa*pa;
    
    dmbdt =@(ma,pa,mb,pb,t) +gamma_mb(pa) - delta_mb*mb;
    dpbdt =@(ma,pa,mb,pb,t) +gamma_pb*mb - delta_pb*pb;

    dxdt = @(t,x)[dmadt(x(1),x(2),x(3),x(4),t);
                  dpadt(x(1),x(2),x(3),x(4),t);
                  dmbdt(x(1),x(2),x(3),x(4),t);
                  dpbdt(x(1),x(2),x(3),x(4),t)];
    
    
    initialCondition = 2*rand(4,1);
    

    [T, X] = ode45(dxdt, [0.0,60], initialCondition);

    % if iRun<10
    %     subplot(2,1,1);hold on; box on;
    %     plot(T,X(:,1),'-r'); % red for RNA
    %     plot(T,X(:,2),'-', 'color', [0.5 0 1]); % purple
    %     ylabel('RNA and Protein A')
    %     xlabel('Time (min)')
    % 
    %     subplot(2,1,2);hold on; box on;
    %     plot(T,X(:,3),'-r'); % red for RNA
    %     plot(T,X(:,4),'-', 'color', [0.5 0 1]); % purple
    %     ylabel('RNA and Protein B')
    %     xlabel('Time (min)')
    % end

    storage_A(iRun) = X(end,2);
    storage_B(iRun) = X(end,4);

    
end
%average steady state
In_storage_A(i_input)=mean(storage_A);
In_storage_B(i_input)=mean(storage_B);


end


% Plot switch-like graph
figure();
plot(input_concentration, In_storage_A, '-r', 'LineWidth', 2); hold on;
plot(input_concentration, In_storage_B, '-', 'color', [0.5 0 1], 'LineWidth', 2);
xlabel('Input Concentration');
ylabel('Protein Levels at Steady State');
legend('Protein A', 'Protein B');
title('Switch-like behavior of proteins A and B');
grid on;