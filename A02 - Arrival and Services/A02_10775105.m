clc; clear all;

%%% TRACE 1 %%%
filename1 = 'trace1.csv';
trace1 = readtable(filename1);
trace1.Properties.VariableNames = ["INTER-ARRIVAL", "SERVICE TIME"];

sizeTrace1 = size(trace1(:,1));
sizeTrace1 = sizeTrace1(1,1);
sumInterArrivalTime1 = double(sum(trace1(:,1).("INTER-ARRIVAL")));
sumServiceTime1 = double(sum(trace1(:,2).("SERVICE TIME")));
T1 = sumInterArrivalTime1;
B1 = sumServiceTime1;

% Utilization
U1 = B1 / T1;

% Idle 
Idle1 = T1 - B1;

% A
for i = 1: +1: sizeTrace1-1
    A1 = cumsum(trace1(:,1));
end

% C
C1(1,1) = trace1(1,1).("INTER-ARRIVAL") + trace1(1,2).("SERVICE TIME");
for i = 2: +1: sizeTrace1
    C1(i,1) = max(A1(i,1).("INTER-ARRIVAL"),C1(i-1,1)) + trace1(i,2).("SERVICE TIME");
end

% Response time
Rt1 = C1(:,1) - A1(:,1);
W1 = sum(Rt1);
Average_Rt1 = W1.("INTER-ARRIVAL") / sizeTrace1;

evs1 = [A1(:,1).("INTER-ARRIVAL"), ones(sizeTrace1, 1), zeros(sizeTrace1, 4); C1(:,1), -ones(sizeTrace1,1), zeros(sizeTrace1, 4)];
evs1 = sortrows(evs1, 1);
evs1(:,3) = cumsum(evs1(:,2));
evs1(1:end-1, 4) = evs1(2:end,1) - evs1(1:end-1,1);
evs1(:,5) = (evs1(:,3) > 0) .* evs1(:,4);
evs1(:,6) = evs1(:,3) .* evs1(:,4);

size_evs1 = double(size(evs1(:,1)));

% Frequency at which the system is idle
count1 = 0;
for i = 1: +1: size_evs1
    if (evs1(i,3) == 0)
        count1 = count1 + 1;
    end
end
Frequency_idle1 = count1 / T1;

% Average Idle Time
Average_IdleTime1 = Idle1 / count1;

% Prints
fprintf(1, "TRACE 1\n");
fprintf(1, "Total Time = %g\n", T1);
fprintf(1, "Utilization = %g\n", U1);
fprintf(1, "Average Response Time = %g\n", Average_Rt1);
fprintf(1, "Frequency at which the system is idle = %g\n", Frequency_idle1);
fprintf(1, "Average Idle Time = %g\n\n", Average_IdleTime1);


%%% TRACE 2 %%%
filename2 = 'trace2.csv';
trace2 = readtable(filename2);
trace2.Properties.VariableNames = ["INTER-ARRIVAL", "SERVICE TIME"];

sizeTrace2 = size(trace2(:,1));
sizeTrace2 = sizeTrace2(1,1);
sumInterArrivalTime2 = double(sum(trace2(:,1).("INTER-ARRIVAL")));
sumServiceTime2 = double(sum(trace2(:,2).("SERVICE TIME")));
T2 = sumInterArrivalTime2;
B2 = sumServiceTime2;

% Utilization
U2 = B2 / T2;

% Idle 
Idle2 = T2 - B2;

% A
for i = 1: +1: sizeTrace2 - 1
    A2 = cumsum(trace2(:,1));
end

% C
C2(1,1) = trace2(1,1).("INTER-ARRIVAL") + trace2(1,2).("SERVICE TIME");
for i = 2: +1: sizeTrace2
    C2(i,1) = max(A2(i,1).("INTER-ARRIVAL"),C2(i-1,1)) + trace2(i,2).("SERVICE TIME");
end

% Response time
Rt2 = C2(:,1) - A2(:,1);
W2 = sum(Rt2);
Average_Rt2 = W2.("INTER-ARRIVAL") / sizeTrace2;

evs2 = [A2(:,1).("INTER-ARRIVAL"), ones(sizeTrace2, 1), zeros(sizeTrace2, 4); C2(:,1), -ones(sizeTrace2,1), zeros(sizeTrace2, 4)];
evs2 = sortrows(evs2, 1);
evs2(:,3) = cumsum(evs2(:,2));
evs2(1:end-1, 4) = evs2(2:end,1) - evs2(1:end-1,1);
evs2(:,5) = (evs2(:,3) > 0) .* evs2(:,4);
evs2(:,6) = evs2(:,3) .* evs2(:,4);

size_evs2 = double(size(evs2(:,1)));

% Frequency at which the system is idle
count2 = 0;
for i = 1: +1: size_evs2
    if (evs2(i,3) == 0)
        count2 = count2 + 1;
    end
end
Frequency_idle2 = count2 / T2;

% Average Idle Time
Average_IdleTime2 = Idle2 / count2;

% Prints
fprintf(1, "TRACE 2\n");
fprintf(1, "Total Time = %g\n", T2);
fprintf(1, "Utilization = %g\n", U2);
fprintf(1, "Average Response Time = %g\n", Average_Rt2);
fprintf(1, "Frequency at which the system is idle = %g\n", Frequency_idle2);
fprintf(1, "Average Idle Time = %g\n\n", Average_IdleTime2);

%%% TRACE 3 %%%
filename3 = 'trace3.csv';
trace3 = readtable(filename3);
trace3.Properties.VariableNames = ["INTER-ARRIVAL", "SERVICE TIME"];

sizeTrace3 = size(trace3(:,1));
sizeTrace3 = sizeTrace3(1,1);
sumInterArrivalTime3 = double(sum(trace3(:,1).("INTER-ARRIVAL")));
sumServiceTime3 = double(sum(trace3(:,2).("SERVICE TIME")));
T3 = sumInterArrivalTime3;
B3 = sumServiceTime3;

% Utilization
U3 = B3 / T3;

% Idle 
Idle3 = T3 - B3;

% A
for i = 1: +1: sizeTrace3-1
    A3 = cumsum(trace3(:,1));
end

% C
C3(1,1) = trace3(1,1).("INTER-ARRIVAL") + trace3(1,2).("SERVICE TIME");
for i = 2: +1: sizeTrace3
    C3(i,1) = max(A3(i,1).("INTER-ARRIVAL"),C3(i-1,1)) + trace3(i,2).("SERVICE TIME");
end

% Response time
Rt3 = C3(:,1) - A3(:,1);
W3 = sum(Rt3);
Average_Rt3 = W3.("INTER-ARRIVAL") / sizeTrace3;

evs3 = [A3(:,1).("INTER-ARRIVAL"), ones(sizeTrace3, 1), zeros(sizeTrace3, 4); C3(:,1), -ones(sizeTrace3,1), zeros(sizeTrace3, 4)];
evs3 = sortrows(evs3, 1);
evs3(:,3) = cumsum(evs3(:,2));
evs3(1:end-1, 4) = evs3(2:end,1) - evs3(1:end-1,1);
evs3(:,5) = (evs3(:,3) > 0) .* evs3(:,4);
evs3(:,6) = evs3(:,3) .* evs3(:,4);

size_evs3 = double(size(evs3(:,1)));

% Frequency at which the system is idle
count3 = 0;
for i = 1: +1: size_evs3
    if (evs3(i,3) == 0)
        count3 = count3 + 1;
    end
end
Frequency_idle3 = count3 / T3;

% Average Idle Time
Average_IdleTime3 = Idle3 / count3;

% Prints
fprintf(1, "TRACE 3\n");
fprintf(1, "Total Time = %g\n", T3);
fprintf(1, "Utilization = %g\n", U3);
fprintf(1, "Average Response Time = %g\n", Average_Rt3);
fprintf(1, "Frequency at which the system is idle = %g\n", Frequency_idle3);
fprintf(1, "Average Idle Time = %g\n", Average_IdleTime3);
