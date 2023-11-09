clc; clear all;

% State 1 = LOW
% State 2 = MEDIUM
% State 3 = HIGH
% State 4 = DOWN

l_1_2 = 0.33;    % LOW --> MEDIUM
l_2_1 = 0.6;     % MEDIUM --> LOW
l_2_3 = 0.4;     % MEDIUM --> HIGH
l_3_2 = 1;       % HIGH --> MEDIUM
l_x_3 = 0.05;    % X --> TO DOWN
l_4_1 = 6 * 0.6; % DOWN --> LOW
l_4_2 = 6 * 0.3; % DOWN --> MEDIUM
l_4_3 = 6 * 0.1; % DOWN --> HIGH

Q = [-l_1_2 - l_x_3,      l_1_2,                    0,                l_x_3;
     l_2_1,               -l_2_1 - l_2_3 - l_x_3,   l_2_3,            l_x_3;
     0,                   l_3_2,                    -l_3_2 - l_x_3,   l_x_3;
     l_4_1,               l_4_2,                    l_4_3,            -l_4_1 - l_4_2 - l_4_3];

% Plot - MEDIUM
Start_MEDIUM = [0, 1, 0, 0];
[t, Sol] = ode45(@(t, x) Q'*x, [0 8], Start_MEDIUM');

figure;
plot(t, Sol, "LineWidth", 2);
title("Evolution of the states of the system starting from MEDIUM traffic state");
xlim([0, 8]);
xlabel('Hours');
ylabel('Probability');
legend("LOW", "MEDIUM", "HIGH", "DOWN");

% Plot - DOWN
Start_DOWN = [0, 0, 0, 1];
[t, Sol] = ode45(@(t, x) Q'*x, [0 8], Start_DOWN');

figure;
plot(t, Sol, "LineWidth", 2);
title("Evolution of the states of the system starting from DOWN traffic state");
xlim([0, 8]);
xlabel('Hours');
ylabel('Probability');
legend("LOW", "MEDIUM", "HIGH", "DOWN");
