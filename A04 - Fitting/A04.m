clc; clear all;

filename1 = 'Trace1.csv';
filename2 = 'Trace2.csv';
trace1 = csvread(filename1);
trace2 = csvread(filename2);

Trace = [trace1 trace2];
N = size(Trace,1);

% X-axis
for i = 0: 100
    t(i+1,1) = i;
end

Mean = sum(Trace) / N;
Moment2 = sum(Trace .^2) / N;
Moment3 = sum(Trace .^3) / N;

% Coefficient of variation
sortedTrace = sort(Trace);
Variance = var(sortedTrace);
CoV = sqrt(Variance) ./ Mean;
CoV_size = size(CoV, 2);

% Uniform left and right bounds & Uniform distribution (CDF formula)
Uni_a = Mean - (sqrt(12 * (Moment2 - Mean .^ 2)) / 2);
Uni_b = Mean + (sqrt(12 * (Moment2 - Mean .^ 2)) / 2);
Uni_Dist(:,1) = max(0, min(1, (t > Uni_a(:,1)) .* (t < Uni_b(:,1)) .* (t - Uni_a(:,1)) ./ (Uni_b(:,1) - Uni_a(:,1)) + (t >= Uni_b(:,1))));
Uni_Dist(:,2) = max(0, min(1, (t > Uni_a(:,2)) .* (t < Uni_b(:,2)) .* (t - Uni_a(:,2)) ./ (Uni_b(:,2) - Uni_a(:,2)) + (t >= Uni_b(:,2))));

% Exponential distribution (CDF formula)
Expo_lambda = 1 ./ Mean;
Expo_Dist(:,1) = max(0, (1 - exp(-Expo_lambda(:,1) .* t)));
Expo_Dist(:,2) = max(0, (1 - exp(-Expo_lambda(:,2) .* t)));

% Erlang distribution (CDF formula)
Erlang_k = round(1 ./ (CoV .^ 2));
Erlang_lambda = Erlang_k ./ Mean;
for i = 1: CoV_size
    if CoV(1,i) < 1
        Erlang_CDF = 1 - (sum(exp(-Erlang_lambda(:,1) .* t) .* (Erlang_lambda(:,1) .* t) .^ (0: (Erlang_k(:,1) - 1)) ./ factorial(0: (Erlang_k(:,1) - 1)), 2));
    end
end

% Weibull with method of moments
% x(1) = lambda | x(2) = k
weq1 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,1), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,1)];
weq2 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,2), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,2)];
x1 = fsolve(weq1, [1,1]);
x2 = fsolve(weq2, [1,1]);
Weibull_lambda = [x1(1) x2(1)];
Weibull_k = [x1(2) x2(2)];
Weibull_Dist(:,1) = 1 - exp(-(t ./ Weibull_lambda(:,1)) .^ Weibull_k(:,1));
Weibull_Dist(:,2) = 1 - exp(-(t ./ Weibull_lambda(:,2)) .^ Weibull_k(:,2));

% Pareto with method of moments
% x(1) = alpha | x(2) = m
peq1 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,1), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,1)];
peq2 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,2), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,2)];
y1 = fsolve(peq1, [3, min(sortedTrace(:,1))]);
y2 = fsolve(peq2, [3, min(sortedTrace(:,2))]);
Pareto_alpha = [y1(1) y2(1)];
Pareto_m = [y1(2) y2(2)];
for j = 1: 2
    for i = 1: 101
        if t(i,1) >= Pareto_m(j)
            Pareto_Dist(i,j) = 1 - (Pareto_m(j) ./ t(i,1)) .^ Pareto_alpha(j);
            else
                Pareto_Dist(i,j) = 0;
        end
    end
end

% Print
fprintf(1, "Mean: %g %g\n", Mean(1,1), Mean(1,2));
fprintf(1, "Moment2: %g %g\n", Moment2(1,1), Moment2(1,2));
fprintf(1, "Moment3: %g %g\n", Moment3(1,1), Moment3(1,2));
fprintf(1, "Uniform a: %g %g\n", Uni_a(1,1), Uni_a(1,2));
fprintf(1, "Uniform b: %g %g\n", Uni_b(1,1), Uni_b(1,2));
fprintf(1, "Exponential rate (lambda): %g %g\n", Expo_lambda(1,1), Expo_lambda(1,2));
fprintf(1, "Erlang stages (k): %g %g\n", Erlang_k(1,1), Erlang_k(1,2));
fprintf(1, "Erlang rate (lambda): %g %g\n", Erlang_lambda(1,1), Erlang_lambda(1,2));
for i = 1: CoV_size 
    if(CoV(1,i) > 1)
        fprintf(1, "Erlang distribution is NOT available for trace %g\n", i);
    end
end
fprintf(1, "Weibull shape (k): %g %g\n", Weibull_k(1,1), Weibull_k(1,2));
fprintf(1, "Weibull scale (lambda): %g %g\n", Weibull_lambda(1,1), Weibull_lambda(1,2));
fprintf(1, "Pareto shape (alpha): %g %g\n", Pareto_alpha(1,1), Pareto_alpha(1,2));
fprintf(1, "Pareto scale (m): %g %g\n", Pareto_m(1,1), Pareto_m(1,2));

% Hyper-exponential & Hypo-exponential parameters with maximum likelihood method
Hyper_PDF = @(x,l1,l2,p1) (x > 0) .* (p1 * l1 * exp(-l1 * x) + (1 - p1) * l2 * exp(-l2 * x));
Hyper_Param1 = mle(sortedTrace(:,1), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,2), 1.2 / Mean(1,2), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
Hyper_Param2 = mle(sortedTrace(:,2), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,2), 1.2 / Mean(1,2), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
fprintf(1, "Hyper-exponential parameters for Trace 1: %g %g %g\n", Hyper_Param1(1,1), Hyper_Param1(1,2), Hyper_Param1(1,3));
fprintf(1, "Hyper-exponential parameters for Trace 2: %g %g %g\n", Hyper_Param2(1,1), Hyper_Param2(1,2), Hyper_Param2(1,3));

Hypo_PDF = @(x,l1,l2) (x > 0) .* (l1 * l2 / (l1 - l2) * (exp(-l2 * x) - exp(-l1 * x)));
Hypo_Param1 = mle(sortedTrace(:,1), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,1)), 1 / (0.7 * Mean(1,1))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
Hypo_Param2 = mle(sortedTrace(:,2), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,1)), 1 / (0.7 * Mean(1,1))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
fprintf(1, "Hypo-exponential parameters for Trace 1: %g %g\n", Hypo_Param1(1,1), Hypo_Param1(1,2));
fprintf(1, "Hypo-exponential parameters for Trace 2: %g %g\n", Hypo_Param2(1,1), Hypo_Param2(1,2));

for i = 1: CoV_size
    if CoV(:,i) > 1
        % Hyper-exponential distribution
        fprintf(1, "Hyper-exponential distribution is NOT available for Trace1 (CoV > 1)\n");
        Hyper_Dist = 1 - (Hyper_Param2(1,3) .* exp(-Hyper_Param2(1,1) .* t(:,1))) - (1 - Hyper_Param2(1,3)) .* exp(-Hyper_Param2(1,2) .* t(:,1));
    else
        % Hypo-exponential distribution
        fprintf(1, "Hypo-exponential distribution is NOT available for Trace2 (CoV < 1)\n");
        Hypo_Dist = 1 - (Hypo_Param1(1,2) * exp(-Hypo_Param1(1,1) .* t(:,1)) ./ (Hypo_Param1(1,2) - Hypo_Param1(1,1))) + (Hypo_Param1(1,1) .* exp(-Hypo_Param1(1,2) .* t(:,1)) ./ (Hypo_Param1(1,2) - Hypo_Param1(1,1)));
    end
end

% Empirical CDF
for i = 1: N
    counter(i,:) = i;
end
FunctionX = counter ./ N;

% Plot - Trace 1
figure;
plot(sortedTrace(:,1), FunctionX, 'y', t, sort(Uni_Dist(:,1)), 'r', t, sort(Expo_Dist(:,1)), 'g', t, sort(Erlang_CDF(:,1)), 'b', t, sort(Weibull_Dist(:,1)), 'm', t, sort(Pareto_Dist(:,1)), 'c', t, sort(Hypo_Dist(:,1)), 'k', 'LineStyle', '-', 'LineWidth', 2);
xlim([0 100]);
title('CDF Trace 1');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'Hypo-exponential');
grid on;

% Plot - Trace 2
figure;
plot(sortedTrace(:,2), FunctionX, 'y', t, sort(Uni_Dist(:,2)), 'r', t, sort(Expo_Dist(:,2)), 'g', t, sort(Weibull_Dist(:,2)), 'm', t, sort(Pareto_Dist(:,2)), 'c', t, sort(Hyper_Dist(:,1)), 'k', 'LineStyle', '-', 'LineWidth', 2);
xlim([0 100]);
title('CDF Trace 2');
xlabel('Value');
ylabel('Probability');
legend('Empirical', 'Uniform', 'Exponential', 'Weibull', 'Pareto', 'Hyper-exponential');
grid on;
