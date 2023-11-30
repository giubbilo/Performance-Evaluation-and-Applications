clc; clear all;

%%% Open model

% SelfCheck = 1
% AppServer = 2
% Storage = 3
% DBMS = 4

lambdaIn = [3, 2, 0, 0];
lambda0 = sum(lambdaIn); % Throughput

X = lambda0;

P2 = [ 0, 0.8,   0,   0;
       0,   0, 0.3, 0.5;
       0,   1,   0,   0;
       0,   1,   0,   0;
     ];

l2 = lambdaIn / lambda0;

% Visits
Vk = l2 * inv(eye(4) - P2);

% Demands time
Sk = [2, 30/1000, 100/1000, 80/1000];
Dk = Vk .* Sk;

% Response time of the system
U = X .* Dk;
Rk = Dk ./ (1 - U);
R = Dk(1,1) + Rk(1,2) + Rk(1,3) + Rk(1,4);

% Number of jobs in the system
N = X * R;

% Print
fprintf(1, "Throughput of the system: %g\n", X);
fprintf(1, "Average number of jobs in the system: %g\n", N);
fprintf(1, "Average response time of the system: %g\n", R);
