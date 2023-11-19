clc; clear all;

%%% G/G/1 - scenario
lambda = 10; % jobs per sec
mu1 = 50;
mu2 = 5;
p1 = 0.8;

hyper_m1 = (p1 / mu1) + ((1 - p1) / mu2);
hyper_m2 = 2 * ((p1 / (mu1)^2) + ((1 - p1) / (mu2)^2));

D1 = hyper_m1;
rho1 = lambda * D1;

% Utilization
U1 = rho1;

% Average response time
w1 = (lambda * hyper_m2) / 2;
R1 = D1 + (w1 / (1 - rho1));

% Average number of jobs in the queue
N1 = rho1 + ((lambda^2 * hyper_m2) / (2 * (1 - rho1)));

fprintf(1, "M/G/1 - Scenario 1\n");
fprintf(1, "Utilization: %g\n", U1);
fprintf(1, "Average Response Time: %g\n", R1);
fprintf(1, "Average number of jobs in the queue: %g\n", N1);

%%% G/G/3 - scenario
erlang_k = 5;
erlang_lambda = 240; 
c = 3;

T = erlang_k / erlang_lambda;
lambda2 = 1 / T;
rho2 = D1 / (3 * T);

ca = 1 / sqrt(erlang_k);
hyper_cv = sqrt(hyper_m2 - hyper_m1^2) / hyper_m1;

part = 0;
for i = 0: (c-1)
    part = part + ((c * rho2)^i) / factorial(i);
end

% Average utilization
Avg_U2 = rho2;

% Average response time
theta = (D1 / (c * (1 - rho2))) / (1 + (1 - rho2) * ((factorial(c)) / ((c * rho2)^c)) * part);
R2 = D1 + (((ca^2 + hyper_cv^2) / 2) * theta);

% Average number of jobs in the queue
N2 = (R2 * lambda2);

fprintf(1, "\nG/G/3 - Scenario 2\n");
fprintf(1, "Utilization: %g\n", Avg_U2);
fprintf(1, "Average Response Time: %g (approx)\n", R2);
fprintf(1, "Average number of jobs in the queue: %g (approx)\n", N2);
