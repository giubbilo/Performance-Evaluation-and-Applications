clc; clear all;

%%% Closed model

% Terminals = 1
% AppServer = 2
% StorageCtrl = 3
% DBMS = 4
% Disk1 = 5
% Disk2 = 6

N = 80; % Employees
Z = 40; % seconds

P0 = [ 0, 1,   0,   0,   0,   0;     
       0, 0, 0.4, 0.5,   0,   0;
       0, 0,   0,   0, 0.6, 0.4;
       0, 1,   0,   0,   0,   0;
       0, 1,   0,   0,   0,   0;
       0, 1,   0,   0,   0,   0;
     ];

l = [1, 0, 0, 0, 0, 0];

Vk = l * inv(eye(6) - P0);

Sk = [40, 50/1000, 2/1000, 80/1000, 80/1000, 120/1000];
Dk = Vk .* Sk;

R_tot = 0;
X = 0;
for k = 1: 6
    Qk(1,k) = 0;
end
for n = 1: N
    for k = 2: 6
        R(1,k) = Dk(1,k) * (1 + Qk(1,k));
    end
    % Average system response time
    R_tot = sum(R);
    % Throughput of the system
    X = (n / (Z + R_tot));
    for k = 2: 6
        Qk(1,k) = X * R(1,k);
    end
end

% Utilization
U = X .* Dk;

% Print
fprintf(1, "Throughput of the system: %g\n", X);
fprintf(1, "Average response time of the system: %g\n", R_tot);
fprintf(1, "Utilization of AppServer: %g\n", U(2));
fprintf(1, "Utilization of DBMS: %g\n", U(4));
fprintf(1, "Utilization of Disk1: %g\n", U(5));
fprintf(1, "Utilization of Disk2: %g\n", U(6));
