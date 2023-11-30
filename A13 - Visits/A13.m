clc; clear all;

%%% Closed model

% Terminal station = 1
% CPU = 2
% Disk = 3
% RAM = 4

N = 10; % users
Z = 10; % seconds

P1 = [   0,    1,    0,    0;
       0.1,    0,  0.3,  0.6;
         0, 0.85,    0, 0.15;
         0, 0.75, 0.25,    0;
     ];

P0 = [  0,    1,    0,    0;
        0,    0,  0.3,  0.6;
        0, 0.85,    0, 0.15;
        0, 0.75, 0.25,    0;
     ];

l1 = [1, 0, 0, 0];

% Visits
Vk1 = l1 * inv(eye(4) - P0);

% Demand time
Sk1 = [10, 20/1000, 10/1000, 3/1000];
Dk1 = Vk1 .* Sk1;

% Print
fprintf(1, "Closed model - Scenario 1\n");
fprintf(1, "Visits: %g %g %g %g\n", Vk1);
fprintf(1, "Demand: %g %g %g %g\n", Dk1);

%%% Open model

% CPU = 1
% Disk = 2
% RAM = 3

lambdaIn = [0.3, 0, 0];
lambda0 = sum(lambdaIn); % Throughput

P2 = [    0,  0.3,  0.6;
        0.8,    0, 0.15;
       0.75, 0.25,    0; 
     ];

l2 = lambdaIn / lambda0;

% Visits
Vk2 = l2 * inv(eye(3) - P2);

% Throughput
Xk2 = Vk2 .* lambda0;

% Demands time
Sk2 = [20/1000, 10/1000, 3/1000];
Dk2 = Vk2 .* Sk2;

% Print
fprintf(1, "\nOpen model - Scenario 2\n");
fprintf(1, "Visits: %g %g %g\n", Vk2);
fprintf(1, "Demands: %g %g %g\n", Dk2);
fprintf(1, "Throughput: %g %g %g\n", Xk2);
