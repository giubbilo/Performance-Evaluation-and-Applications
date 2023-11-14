clc; clear all;

%%% M/M/1/K - scenario
lambda = 150 / 60; % req per s
D = 350 / 1000; % ms to s
k = 32;

% Utilization
U = lambda * D;
rho = U;

% Loss probability
P_loss = (rho^k - rho^(k+1)) / (1 - rho^(k+1));

% Drop rate
Dr = lambda * P_loss;

% Average response time
R = D * (1 - (k + 1) * rho^k + k * rho^(k+1)) / ((1 - rho) * (1 - rho^k));

% Average number of jobs in the system
N = R * lambda * (1 - P_loss);

% Average Time spent in the queue
Time_queue = R - D;

% Print
fprintf(1, "M/M/1/K - scenario\n");
fprintf(1, "Average Utilization: %g\n", U);
fprintf(1, "Loss probability: %g\n", P_loss);
fprintf(1, "Average Number of jobs in the system: %g (every second)\n", N);
fprintf(1, "Drop rate: %g (every second)\n", Dr);
fprintf(1, "Average Response Time: %g\n", R);
fprintf(1, "Average time spent in the queue: %g\n", Time_queue);

%%% M/M/2/K - scenario
lambda2 = 250 / 60; % req per min
c = 2;

% Total and average utilization of the system
U2_avg = (lambda2 * D) / c;
rho2 = U2_avg;
U2 = U2_avg * 2;

% Average number of jobs in the system
part1 = (((c * rho2)^c) / (factorial(c))) * ((1 - rho2^(k-c+1)) / (1 - rho2));
part2 = ((c * rho2^1) / factorial(1)) + (1 / factorial(0));
p0 = 1 / (part1 + part2);
N2 = 0;
for i = 1: k
    if(i < c)
        pi(i,1) = (p0 / factorial(i)) * (c * rho2)^i;
        N2 = N2 + i * pi(i,1);
    end
    if(i <= k && c <= i)
        pi(i,1) = (p0 * c^c * rho2^i) / factorial(c);
        N2 = N2 + i * pi(i,1);
    end  
end

% Loss probability
P_loss2 = pi(32,1);

% Drop rate
Dr2 = lambda2 * P_loss2;

% Average response time
R2 = N2 / (lambda2 * (1 - P_loss2));

% Average Time spent in the queue
Time_queue2 = R2 - D;

% Print
fprintf(1, "\nM/M/2/K - scenario\n");
fprintf(1, "Utilization: %g\n", U2);
fprintf(1, "Average Utilization: %g\n", U2_avg);
fprintf(1, "Loss probability: %g\n", P_loss2);
fprintf(1, "Average Number of jobs in the system: %g (every second)\n", N2);
fprintf(1, "Drop rate: %g (every second)\n", Dr2);
fprintf(1, "Average Response Time: %g\n", R2);
fprintf(1, "Average time spent in the queue: %g\n", Time_queue2);
