clc; clear all;

% STATES
% 1 = SleepNight
% 2 = ScanNight
% 3 = SleepDaySun
% 4 = SleepDayCloud
% 5 = ScanDay

% All in minutes
l_ScanX_x = 1/2;
l_SleepN_ScanN = 1/18;
l_SleepDS_ScanD = 1/3;
l_SleepDC_ScanD = 1/8;
l_N_D = 1/(12 * 60);
l_DS_DC = 1/(6 * 60);
l_DC_DS = 1/(3 * 60);

Q = [-l_SleepN_ScanN - l_N_D - l_N_D - l_N_D, l_SleepN_ScanN, l_N_D, l_N_D, l_N_D;
     l_ScanX_x, -l_ScanX_x - l_N_D - l_N_D - l_N_D, l_N_D, l_N_D, l_N_D;
     l_N_D, l_N_D, l_N_D - l_N_D - l_DS_DC - l_SleepDS_ScanD, l_DS_DC, l_SleepDS_ScanD;
     l_N_D, l_N_D, l_DC_DS, l_N_D - l_N_D - l_DC_DS - l_SleepDC_ScanD, l_SleepDC_ScanD;
     l_N_D, l_N_D, l_ScanX_x, l_ScanX_x, l_N_D - l_N_D - l_ScanX_x - l_ScanX_x
    ];

alpha_power = [0.1, 12, 0.1, 0.1, 12];
alpha_utilization = [0, 1, 0, 0, 1];

Xi_X = [0, 0, 0, 0, 0;
        1, 0, 1, 1, 0;
        0, 0, 0, 0, 0;
        0, 0, 0, 0, 0;
        1, 0, 1, 1, 0;
       ];

Qp = [ones(5,1), Q(:,2:5)];
pi = [1, 0, 0, 0, 0] * inv(Qp); % Steady-state probability of the system

avg_Power = pi * alpha_power';
U = pi * alpha_utilization';
X = pi * sum((Xi_X .* Q)')';

fprintf(1, "Average Power Consumption: %g Watt\n", avg_Power);
fprintf(1, "Utilization: %g \n", U);
fprintf(1, "Throughput: %g scans per day \n", X * 1440);
