clc; clear all;

filename1 = 'Trace1.csv';
filename2 = 'Trace2.csv';
filename3 = 'Trace3.csv';
trace1 = csvread(filename1);
trace2 = csvread(filename2);
trace3 = csvread(filename3);

Trace = [trace1 trace2 trace3];
N = size(Trace,1);

sortedTrace = sort(Trace);

% Mean | Moment 2 | Moment 3 | Moment 4
Mean = sum(sortedTrace) / N;
Moment2 = sum(sortedTrace .^2) / N;
Moment3 = sum(sortedTrace .^3) / N;  
Moment4 = sum(sortedTrace .^4) / N;

% Variance | Centered Moment 3 | Centered Moment 4
centeredMean = sortedTrace - Mean;
Variance = var(sortedTrace);
CenteredMoment3 = sum(centeredMean .^3) / (N-1);
CenteredMoment4 = sum(centeredMean .^4) / (N-1);

% Standard Deviation | Standard Moment 4
STD = std(Trace);
stdMoment4 = sum((centeredMean ./ STD) .^4) / N;

% Skewness
Skewness = skewness(sortedTrace);

% excess_Kurtosis
Kurtosis = kurtosis(sortedTrace);
excess_Kurtosis = Kurtosis - 3;

% Coefficient of variation
CoV = sqrt(Variance) ./ Mean;

% Median | First Percentile (25) | Third Percentile (75)
Median = median(sortedTrace);
Percentile25 = prctile(sortedTrace, 25);
Percentile75 = prctile(sortedTrace, 75);

% Approximated CDF of the corresponding distribution
for i = 1: +1: N
    counter(i,:) = i;
end
FunctionX = counter ./ N;

figure('Name', 'Approximated CDF');
plot(sortedTrace, FunctionX, 'LineWidth', 2);
title('Approximated CDF');

% Pearson Correlation Coefficient for lags m=1 to m=100
partialCrossCovariance = [zeros(100, 1), zeros(100, 1), zeros(100, 1)];
crossCovariance = [zeros(100, 1), zeros(100, 1), zeros(100, 1)];
PearsonCorrCoefficient = [zeros(100, 1), zeros(100, 1), zeros(100, 1)];
for i = 1: +1: 3
    for m = 1: 100
        for j = 1: (N - m)
            partialCrossCovariance(m, i) = partialCrossCovariance(m, i) + (Trace(j, i) - Mean(1, i)) .* (Trace(j + m, i) - Mean(1, i));
        end
        crossCovariance(m, i) = (1 / (N - m)) .* partialCrossCovariance(m, i);
        PearsonCorrCoefficient(m, i) = crossCovariance(m, i) ./ Variance(1, i);
    end    
end
figure();
plot([1:100], PearsonCorrCoefficient, 'LineWidth', 1);
title('Pearson Correlation Coefficient for lags m=1 to m=100');
xlabel('Lag');
ylabel('Pearson Coefficient');

% Print
fprintf(1, "Mean = %g %g %g", Mean(1,1), Mean(1,2), Mean(1,3));
fprintf(1, "\nMoment 2 = %g %g %g", Moment2(1,1), Moment2(1,2), Moment2(1,3));
fprintf(1, "\nMoment 3 = %g %g %g", Moment3(1,1), Moment3(1,2), Moment3(1,3));
fprintf(1, "\nMoment 4 = %g %g %g", Moment4(1,1), Moment4(1,2), Moment4(1,3));

fprintf(1, "\n\nVariance = %g %g %g", Variance(1,1), Variance(1,2), Variance(1,3));
fprintf(1, "\nCentered Moment 3 = %g %g %g", CenteredMoment3(1,1), CenteredMoment3(1,2), CenteredMoment3(1,3));
fprintf(1, "\nCentered Moment 4 = %g %g %g", CenteredMoment4(1,1), CenteredMoment4(1,2), CenteredMoment4(1,3));

fprintf(1, "\n\nSkewness = %g %g %g", Skewness(1,1), Skewness(1,2), Skewness(1,3));
fprintf(1, "\nStandardized Moment 4 = %g %g %g", stdMoment4(1,1), stdMoment4(1,2), stdMoment4(1,3));

fprintf(1, "\n\nStandard Deviation = %g %g %g", STD(1,1), STD(1,2), STD(1,3));
fprintf(1, "\nCoefficient of Variation = %g %g %g", CoV(1,1), CoV(1,2), CoV(1,3));
fprintf(1, "\nExcess Kurtosis = %g %g %g", excess_Kurtosis(1,1), excess_Kurtosis(1,2), excess_Kurtosis(1,3));

fprintf(1, "\n\nMedian = %g %g %g", Median(1,1), Median(1,2), Median(1,3));
fprintf(1, "\nFirst percentile (25) = %g %g %g", Percentile25(1,1), Percentile25(1,2), Percentile25(1,3));
fprintf(1, "\nThird percentile (75) = %g %g %g\n", Percentile75(1,1), Percentile75(1,2), Percentile75(1,3));
