clc; clear all;

% X-axis
for i = 0: 100
    t(i+1,1) = i;
end

% Linear Congruent Generator
N = 10000;
m = 2 ^ 32;
a = 1664525;
c = 1013904223;
seed = 521191478;

Uni_sample(1,1) = seed;
for i = 2: N
    Uni_sample(i,1) = mod(a * Uni_sample(i-1, 1) + c, m);
end
Uni_sample = Uni_sample ./ (m-1);

% Exponential generation
Expo_lambda = 0.1;
Expo_sample = -log(Uni_sample) ./ Expo_lambda;
Expo_size = size(Expo_sample, 1);
Expo_CDF = max(0, (1 - exp(-Expo_lambda .* t)));

% Pareto generation
Pareto_alpha = 1.5;
Pareto_m = 5;
Pareto_sample = Pareto_m ./ (Uni_sample .^ (1 / Pareto_alpha));
Pareto_size = size(Pareto_sample, 1);
for i = 1: 101
    if t(i,1) >= Pareto_m
        Pareto_CDF(i,1) = 1 - (Pareto_m ./ t(i,1)) .^ Pareto_alpha;
        else
            Pareto_CDF(i,1) = 0;
    end
end

% Erlang generation
Erlang_k = 4;
Erlang_lambda = 0.4;
j = 1;
for i = 1: +4: N
    Erlang_sample(j,1) = -(log(prod(Uni_sample(i: i + Erlang_k - 1))) ./ Erlang_lambda);
    j = j + 1;
end
Erlang_size = size(Erlang_sample, 1);
Erlang_CDF = 1 - (sum(exp(-Erlang_lambda .* t) .* (Erlang_lambda .* t) .^ (0: (Erlang_k - 1)) ./ factorial(0: (Erlang_k - 1)), 2));

% Hypo-Exponential generation
Hypo_lambda1 = 0.5;
Hypo_lambda2 = 0.125;
u1 = Uni_sample(1:5000, 1);
u2 = Uni_sample(5001:10000, 1);
Hypo_sample = (-log(u1) ./ Hypo_lambda1) + (-log(u2) ./ Hypo_lambda2);
Hypo_size = size(Hypo_sample, 1);
Hypo_CDF = 1 - (Hypo_lambda2 * exp(-Hypo_lambda1 .* t) ./ (Hypo_lambda2 - Hypo_lambda1)) + (Hypo_lambda1 .* exp(-Hypo_lambda2 .* t) ./ (Hypo_lambda2 - Hypo_lambda1));

% Hyper-exponential generation
Hyper_lambda1 = 0.5;
Hyper_lambda2 = 0.05;
Hyper_p1 = 0.55;
for i = 1: (N/2)
    if Uni_sample(i,1) <= Hyper_p1
        Hyper_sample(i,1) = -(log(Uni_sample(i+(N/2), 1)) / Hyper_lambda1);
        else
            Hyper_sample(i,1) = -(log(Uni_sample(i+(N/2), 1)) / Hyper_lambda2);
    end
end
Hyper_size = size(Hyper_sample, 1);
Hyper_CDF = 1 - (Hyper_p1 .* exp(-Hyper_lambda1 .* t)) - (1 - Hyper_p1) .* exp(-Hyper_lambda2 .* t);

% Plot Exponential
figure('Name', 'Exponential');
plot(sort(Expo_sample), [1:Expo_size]/Expo_size, "r", t, sort(Expo_CDF), "b", "LineStyle", "-", "LineWidth", 1);
xlim([0 25]);
title('Comparison case N1 - Exponential');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Real CDF');
grid on;

% Plot Pareto
figure('Name', 'Pareto');
plot(sort(Pareto_sample), [1:Pareto_size]/Pareto_size, "r", t, sort(Pareto_CDF), "b", "LineStyle", "-", "LineWidth", 1);
xlim([0 25]);
title('Comparison case N2 - Pareto');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Real CDF');
grid on;

% Plot Erlang
figure('Name', 'Erlang');
plot(sort(Erlang_sample), [1:Erlang_size]/Erlang_size, "r", t, sort(Erlang_CDF), "b", "LineStyle", "-", "LineWidth", 1);
xlim([0 25]);
title('Comparison case N3 - Erlang');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Real CDF');
grid on;

% Plot Hypo
figure('Name', 'Hypo-exponential');
plot(sort(Hypo_sample), [1:Hypo_size]/Hypo_size, "r", t, sort(Hypo_CDF), "b", "LineStyle", "-", "LineWidth", 1);
xlim([0 25]);
title('Comparison case N4 - Hypo-exponential');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Real CDF');
grid on;

% Plot Hyper
figure('Name', 'Hyper-exponential');
plot(sort(Hyper_sample), [1:Hyper_size]/Hyper_size, "r", t, sort(Hyper_CDF), "b", "LineStyle", "-", "LineWidth", 1);
xlim([0 25]);
title('Comparison case N5 - Hyper-exponential');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Real CDF');
grid on;

% Cost
for i = 1: Expo_size
    if (Expo_sample(i,1) < 10)
        Expo_cost(i,1) = 0.01 * Expo_sample(i,1);
        else 
            if (Expo_sample(i,1) >= 10)
                Expo_cost(i,1) = 0.02 * Expo_sample(i,1);
            end
    end
    if (Pareto_sample(i,1) < 10)
        Pareto_cost(i,1) = 0.01 * Pareto_sample(i,1);
        else 
            if (Pareto_sample(i,1) >= 10)
                Pareto_cost(i,1) = 0.02 * Pareto_sample(i,1);
            end
    end
end

for i = 1: Erlang_size
    if (Erlang_sample(i,1) < 10)
        Erlang_cost(i,1) = 0.01 * Erlang_sample(i,1);
        else 
            if (Erlang_sample(i,1) >= 10)
                 Erlang_cost(i,1) = 0.02 * Erlang_sample(i,1);
            end
    end
end

for i = 1: Hypo_size
    if (Hypo_sample(i,1) < 10)
        Hypo_cost(i,1) = 0.01 * Hypo_sample(i,1);
        else 
            if (Hypo_sample(i,1) >= 10)
                 Hypo_cost(i,1) = 0.02 * Hypo_sample(i,1);
            end
    end
    if (Hyper_sample(i,1) < 10)
        Hyper_cost(i,1) = 0.01 * Hyper_sample(i,1);
        else 
            if (Hyper_sample(i,1) >= 10)
                 Hyper_cost(i,1) = 0.02 * Hyper_sample(i,1);
            end
    end
end

Expo_tot = sum(Expo_cost, 1);
Pareto_tot = sum(Pareto_cost, 1);
Erlang_tot = sum(Erlang_cost, 1);
Hypo_tot = sum(Hypo_cost, 1);
Hyper_tot = sum(Hyper_cost, 1);

% Print
fprintf(1, "First sample generated by the Linear Congruent Generator: %g\n", Uni_sample(1,1));
fprintf(1, "Second sample generated by the Linear Congruent Generator: %g\n", Uni_sample(2,1));
fprintf(1, "Third sample generated by the Linear Congruent Generator: %g\n", Uni_sample(3,1));
fprintf(1, "N1) Exponential case - cost for storing %g files: %g$\n", Expo_size, Expo_tot);
fprintf(1, "N2) Pareto case - cost for storing %g files: %g$\n", Pareto_size, Pareto_tot);
fprintf(1, "N3) Erlang case - cost for storing %g files: %g$\n", Erlang_size, Erlang_tot);
fprintf(1, "N4) Hypo-exponential case - cost for storing %g files: %g$\n", Hypo_size, Hypo_tot);
fprintf(1, "N5) Hyper-exponential case - cost for storing %g files: %g$\n", Hyper_size, Hyper_tot);
