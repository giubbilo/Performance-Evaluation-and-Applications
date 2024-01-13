clc; clear all;

filename1 = 'TraceA-I.txt';
trace1 = csvread(filename1);
filename2 = 'TraceA-II.txt';
trace2 = csvread(filename2);
filename3 = 'TraceA-III.txt';
trace3 = csvread(filename3);
filename4 = 'TraceA-IV.txt';
trace4 = csvread(filename4);

% All traces values are expressed in minutes

sizeTrace1 = size(trace1(:,1));
sizeTrace1 = sizeTrace1(1,1);
sizeTrace2 = size(trace2(:,1));
sizeTrace2 = sizeTrace2(1,1);
sizeTrace3 = size(trace3(:,1));
sizeTrace3 = sizeTrace3(1,1);
sizeTrace4 = size(trace4(:,1));
sizeTrace4 = sizeTrace4(1,1);

Trace = [trace1 trace2 trace3 trace4];
N = size(Trace, 1);
sortedTrace = sort(Trace);

% X-axis
for i = 0: 100
    t(i+1, 1) = i;
end

% Empirical CDF
for i = 1: N
    counter(i,:) = i;
end
FunctionX = counter ./ N;

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
Uni_Dist(:,3) = max(0, min(1, (t > Uni_a(:,3)) .* (t < Uni_b(:,3)) .* (t - Uni_a(:,3)) ./ (Uni_b(:,3) - Uni_a(:,3)) + (t >= Uni_b(:,3))));
Uni_Dist(:,4) = max(0, min(1, (t > Uni_a(:,4)) .* (t < Uni_b(:,4)) .* (t - Uni_a(:,4)) ./ (Uni_b(:,4) - Uni_a(:,4)) + (t >= Uni_b(:,4))));

% Exponential distribution (CDF formula)
Expo_lambda = 1 ./ Mean;
Expo_Dist(:,1) = max(0, (1 - exp(-Expo_lambda(:,1) .* t)));
Expo_Dist(:,2) = max(0, (1 - exp(-Expo_lambda(:,2) .* t)));
Expo_Dist(:,3) = max(0, (1 - exp(-Expo_lambda(:,3) .* t)));
Expo_Dist(:,4) = max(0, (1 - exp(-Expo_lambda(:,4) .* t)));

% Erlang distribution (CDF formula)
Erlang_k = round(1 ./ (CoV .^ 2));
Erlang_lambda = Erlang_k ./ Mean;
for i = 1: CoV_size 
    if(CoV(1,i) > 1)
        fprintf(1, "Erlang distribution is NOT available for Trace%g\n", i);
        else
            Erlang_Dist(:,i) = 1 - (sum(exp(-Erlang_lambda(:,i) .* t) .* (Erlang_lambda(:,i) .* t) .^ (0: (Erlang_k(:,i) - 1)) ./ factorial(0: (Erlang_k(:,i) - 1)), 2));
    end
end

options = optimoptions('fsolve','Display','off');

% Weibull with method of moments
% x(1) = lambda | x(2) = k
weq1 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,1), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,1)];
weq2 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,2), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,2)];
weq3 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,3), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,3)];
weq4 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,4), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,4)];
x1 = fsolve(weq1, [1,1], options);
x2 = fsolve(weq2, [1,1], options);
x3 = fsolve(weq3, [1,1], options);
x4 = fsolve(weq4, [1,1], options);
Weibull_lambda = [x1(1) x2(1) x3(1) x4(1)];
Weibull_k = [x1(2) x2(2) x3(2) x4(2)];
Weibull_Dist(:,1) = 1 - exp(-(t ./ Weibull_lambda(:,1)) .^ Weibull_k(:,1));
Weibull_Dist(:,2) = 1 - exp(-(t ./ Weibull_lambda(:,2)) .^ Weibull_k(:,2));
Weibull_Dist(:,3) = 1 - exp(-(t ./ Weibull_lambda(:,3)) .^ Weibull_k(:,3));
Weibull_Dist(:,4) = 1 - exp(-(t ./ Weibull_lambda(:,4)) .^ Weibull_k(:,4));

% Pareto with method of moments
% x(1) = alpha | x(2) = m
peq1 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,1), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,1)];
peq2 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,2), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,2)];
peq3 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,3), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,3)];
peq4 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,4), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,4)];
y1 = fsolve(peq1, [3, min(sortedTrace(:,1))], options);
y2 = fsolve(peq2, [3, min(sortedTrace(:,2))], options);
y3 = fsolve(peq3, [3, min(sortedTrace(:,3))], options);
y4 = fsolve(peq4, [3, min(sortedTrace(:,4))], options);
Pareto_alpha = [y1(1) y2(1) y3(1) y4(1)];
Pareto_m = [y1(2) y2(2) y3(2) y4(2)];
for j = 1: 4
    for i = 1: 101
        if t(i,1) >= Pareto_m(j)
            Pareto_Dist(i,j) = 1 - (Pareto_m(j) ./ t(i,1)) .^ Pareto_alpha(j);
            else
                Pareto_Dist(i,j) = 0;
        end
    end
end

% Hyper-exponential & Hypo-exponential parameters with maximum likelihood method
Hyper_PDF = @(x,l1,l2,p1) (x > 0) .* (p1 * l1 * exp(-l1 * x) + (1 - p1) * l2 * exp(-l2 * x));
Hyper_Param1 = mle(sortedTrace(:,1), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,1), 1.2 / Mean(1,1), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
Hyper_Param2 = mle(sortedTrace(:,2), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,2), 1.2 / Mean(1,2), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
Hyper_Param3 = mle(sortedTrace(:,3), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,3), 1.2 / Mean(1,3), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
Hyper_Param4 = mle(sortedTrace(:,4), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,4), 1.2 / Mean(1,4), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);

Hypo_PDF = @(x,l1,l2) (x > 0) .* (l1 * l2 / (l1 - l2) * (exp(-l2 * x) - exp(-l1 * x)));
Hypo_Param1 = mle(sortedTrace(:,1), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,1)), 1 / (0.7 * Mean(1,1))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
Hypo_Param2 = mle(sortedTrace(:,2), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,2)), 1 / (0.7 * Mean(1,2))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
Hypo_Param3 = mle(sortedTrace(:,3), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,3)), 1 / (0.7 * Mean(1,3))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
Hypo_Param4 = mle(sortedTrace(:,4), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,4)), 1 / (0.7 * Mean(1,4))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);

if CoV(1,:) < 1
    % Hyper & Hypo distribution
    fprintf(1, "Hyper-exponential distribution is NOT available for Trace1 (CoV < 1)\n");
    fprintf(1, "Hyper-exponential distribution is NOT available for Trace2 (CoV < 1)\n");
    fprintf(1, "Hyper-exponential distribution is NOT available for Trace3 (CoV < 1)\n");
    fprintf(1, "Hyper-exponential distribution is NOT available for Trace4 (CoV < 1)\n");   
end

Hypo_Dist(:,1) = 1 - (Hypo_Param1(1,2) * exp(-Hypo_Param1(1,1) .* t(:,1)) ./ (Hypo_Param1(1,2) - Hypo_Param1(1,1))) + (Hypo_Param1(1,1) .* exp(-Hypo_Param1(1,2) .* t(:,1)) ./ (Hypo_Param1(1,2) - Hypo_Param1(1,1)));
Hypo_Dist(:,2) = 1 - (Hypo_Param2(1,2) * exp(-Hypo_Param2(1,1) .* t(:,1)) ./ (Hypo_Param2(1,2) - Hypo_Param2(1,1))) + (Hypo_Param2(1,1) .* exp(-Hypo_Param2(1,2) .* t(:,1)) ./ (Hypo_Param2(1,2) - Hypo_Param2(1,1)));
Hypo_Dist(:,3) = 1 - (Hypo_Param3(1,2) * exp(-Hypo_Param3(1,1) .* t(:,1)) ./ (Hypo_Param3(1,2) - Hypo_Param3(1,1))) + (Hypo_Param3(1,1) .* exp(-Hypo_Param3(1,2) .* t(:,1)) ./ (Hypo_Param3(1,2) - Hypo_Param3(1,1)));
Hypo_Dist(:,4) = 1 - (Hypo_Param4(1,2) * exp(-Hypo_Param4(1,1) .* t(:,1)) ./ (Hypo_Param4(1,2) - Hypo_Param4(1,1))) + (Hypo_Param4(1,1) .* exp(-Hypo_Param4(1,2) .* t(:,1)) ./ (Hypo_Param4(1,2) - Hypo_Param4(1,1)));

% Print
fprintf(1, "\nParameters:\n");
fprintf(1, "Uniform a: %g %g %g %g\n", Uni_a(1,1), Uni_b(1,2), Uni_a(1,3), Uni_a(1,4));
fprintf(1, "Uniform b: %g %g %g %g\n", Uni_b(1,1), Uni_b(1,2), Uni_b(1,3), Uni_b(1,4));
fprintf(1, "Exponential rate (lambda): %g %g %g %g\n", Expo_lambda(1,1), Expo_lambda(1,2), Expo_lambda(1,3), Expo_lambda(1,4));
fprintf(1, "Erlang stages (k): %g %g %g %g\n", Erlang_k(1,1), Erlang_k(1,2), Erlang_k(1,3), Erlang_k(1,4));
fprintf(1, "Erlang rate (lambda): %g %g %g %g\n", Erlang_lambda(1,1), Erlang_lambda(1,2), Erlang_lambda(1,3), Erlang_lambda(1,4));
fprintf(1, "Weibull shape (k): %g %g %g %g\n", Weibull_k(1,1), Weibull_k(1,2), Weibull_k(1,3), Weibull_k(1,4));
fprintf(1, "Weibull scale (lambda): %g %g %g %g\n", Weibull_lambda(1,1), Weibull_lambda(1,2), Weibull_lambda(1,3), Weibull_lambda(1,4));
fprintf(1, "Pareto shape (alpha): %g %g %g %g\n", Pareto_alpha(1,1), Pareto_alpha(1,2), Pareto_alpha(1,3), Pareto_alpha(1,4));
fprintf(1, "Pareto scale (m): %g %g %g %g\n", Pareto_m(1,1), Pareto_m(1,2), Pareto_m(1,3), Pareto_m(1,4));
fprintf(1, "Hypo-exponential parameters for Trace 1: %g %g\n", Hypo_Param1(1,1), Hypo_Param1(1,2));
fprintf(1, "Hypo-exponential parameters for Trace 2: %g %g\n", Hypo_Param2(1,1), Hypo_Param2(1,2));
fprintf(1, "Hypo-exponential parameters for Trace 3: %g %g\n", Hypo_Param3(1,1), Hypo_Param3(1,2));
fprintf(1, "Hypo-exponential parameters for Trace 4: %g %g\n", Hypo_Param4(1,1), Hypo_Param4(1,2));

% Plot
figure;
plot(sortedTrace(:,1), FunctionX, 'k', t, sort(Uni_Dist(:,1)), 'c', t, sort(Expo_Dist(:,1)), 'g', t, sort(Erlang_Dist(:,1)), 'r', t, sort(Weibull_Dist(:,1)), 'y', t, sort(Pareto_Dist(:,1)), 'b', t, sort(Hypo_Dist(:,1)), 'm', 'LineStyle', '-', 'LineWidth', 2);
xlim([0 100]);
title('Trace 1');
legend('Empirical', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'Hypo');
grid on;

figure;
plot(sortedTrace(:,2), FunctionX, 'k', t, sort(Uni_Dist(:,2)), 'c', t, sort(Expo_Dist(:,2)), 'g', t, sort(Erlang_Dist(:,2)), 'r', t, sort(Weibull_Dist(:,2)), 'y', t, sort(Pareto_Dist(:,2)), 'b', t, sort(Hypo_Dist(:,2)), 'm', 'LineStyle', '-', 'LineWidth', 2);
xlim([0 100]);
title('Trace 2');
legend('Empirical', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'Hypo');
grid on;

figure;
plot(sortedTrace(:,3), FunctionX, 'k', t, sort(Uni_Dist(:,3)), 'c', t, sort(Expo_Dist(:,3)), 'g', t, sort(Erlang_Dist(:,3)), 'r', t, sort(Weibull_Dist(:,3)), 'y', t, sort(Pareto_Dist(:,3)), 'b', t, sort(Hypo_Dist(:,3)), 'm', 'LineStyle', '-', 'LineWidth', 2);
xlim([0 100]);
title('Trace 3');
legend('Empirical', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'Hypo');
grid on;

figure;
plot(sortedTrace(:,4), FunctionX, 'k', t, sort(Uni_Dist(:,4)), 'c', t, sort(Expo_Dist(:,4)), 'g', t, sort(Erlang_Dist(:,4)), 'r', t, sort(Weibull_Dist(:,4)), 'y', t, sort(Pareto_Dist(:,4)), 'b', t, sort(Hypo_Dist(:,4)), 'm', 'LineStyle', '-', 'LineWidth', 2);
xlim([0 100]);
title('Trace 4');
legend('Empirical', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'Hypo');
grid on;
