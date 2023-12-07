clc; clear all;

% 3 classes - A, B, C
% 2 stations - Production, Packaging

% Throughput of the stations
X1 = 2 / 60;
X2 = 3 / 60;
X3 = 2.5 / 60;

% Throughput of the system
X = X1 + X2 + X3;

% Service time
S1 = [10, 12];
S2 = [4, 3];
S3 = [6, 6];

% Demand
D1 = S1;
D2 = S2;
D3 = S3;

% Utilization per class
U1 = X1 * D1;
U2 = X2 * D2;
U3 = X3 * D3;

% Utilization per station
Uprod = U1(1,1) + U2(1,1) + U3(1,1);
Upack = U1(1,2) + U2(1,2) + U3(1,2);

% Response time per station & per class
R1prod = D1(1,1) ./ (1 - Uprod);
R1pack = D1(1,2) ./ (1 - Upack);
R1 = R1prod + R1pack;

R2prod = D2(1,1) ./ (1 - Uprod);
R2pack = D2(1,2) ./ (1 - Upack);
R2 = R2prod + R2pack;

R3prod = D3(1,1) ./ (1 - Uprod);
R3pack = D3(1,2) ./ (1 - Upack);
R3 = R3prod + R3pack;

% Average number of jobs per class
Q1 = X1 * R1;
Q2 = X2 * R2;
Q3 = X3 * R3;

% Class-independent average system response time
R = (X1 / X) * R1 + (X2 / X) * R2 + (X3 / X) * R3;

% Print
fprintf(1, "3 classes - A B C\n");
fprintf(1, "2 stations - Production and Packaging\n\n");
fprintf(1, "Utilization per station: %g %g\n", Uprod, Upack);
fprintf(1, "Average number of jobs for each class: %g %g %g\n", Q1, Q2, Q3);
fprintf(1, "Average response time for each type of product: %g %g %g\n", R1, R2, R3);
fprintf(1, "Class-indipendent average system response time: %g\n", R);
