clc; clear all;

%%% Case with 1 server
lambda1 = 40; % jobs per second
D1 = 16 / 1000; % ms to s

mu1 = 1 / D1;

% Utilization
U1 = lambda1 * D1;
rho1 = U1;

% Probability of having exact 1 job in the queue
Pr1_exact_1 = (1 - rho1) * rho1;
% Probability of having less than 10 jobs in the queue
Pr1_less_10 = 1 - (rho1 ^ (9 + 1));

% Average queue length
Avg_queue_length1 = (rho1 ^ 2) / (1 - rho1);

% Average response time
Avg_resp_time1 = D1 / (1 - rho1);

% Probability of having the response time is greater than 0.5 s
Pr1_R_greater_05 = exp(-0.5 / Avg_resp_time1);

% 90 percentile of the response time distribution
Perc90 = -log(1 - 90/100) * Avg_resp_time1;

% Print
fprintf(1, "M/M/1 - Case with 1 server\n");
fprintf(1, "Utilization: %g\n", U1);
fprintf(1, "Probability of having exact 1 job in the system: %g\n", Pr1_exact_1);
fprintf(1, "Probability of having less than 10 jobs in the system: %g\n", Pr1_less_10);
fprintf(1, "Average Queue Length: %g\n", Avg_queue_length1);
fprintf(1, "Average Response Time: %g\n", Avg_resp_time1);
fprintf(1, "Probability that the response time > 0.5: %g\n", Pr1_R_greater_05);
fprintf(1, "Percentile 90 of response time distribution: %g\n", Perc90);

%%% Case with 2 servers
lambda2 = 90; % jobs per second

mu2 = 2 * mu1;

% Utilization and Average Utilization
U2 = lambda2 / mu1;
Avg_U2 = lambda2 / mu2;
rho2 = Avg_U2;

% Probability of having exact 1 job in the queue
Pr2_exact_1 = 2 * (1 - rho2) / (1 + rho2) * rho2;
% Probability of having less than 10 jobs in the queue
Pr2_less_10 = (1 - rho2) / (1 +  rho2);
for i = 1 : 9
    Pr2_i = 2 * ((1 - rho2) / (1 + rho2)) * (rho2 ^ i);
    Pr2_less_10 = Pr2_less_10 + Pr2_i;
end

% Average queue length
Avg_queue_length2 = ((2 * rho2) / (1 - rho2 ^ 2)) - U2;

% Average response time
Avg_response_time2 = ((2 * rho2) / (1 - rho2 ^ 2)) / lambda2;

% Print
fprintf(1, "\nM/M/2 - Case with 2 servers\n");
fprintf(1, "Utilization: %g\n", U2);
fprintf(1, "Average Utilization: %g\n", Avg_U2);
fprintf(1, "Probability of having exact 1 job in the system: %g\n", Pr2_exact_1);
fprintf(1, "Probability of having less than 10 jobs in the system: %g\n", Pr2_less_10);
fprintf(1, "Average Queue Length: %g\n", Avg_queue_length2);
fprintf(1, "Average Response Time: %g\n", Avg_response_time2);
