clc; clear all;

filename = 'barrier.log';
log = readtable(filename);
log.Properties.VariableNames = ["YEARS", "DAYS", "HOURS", "MINUTES", "SECONDS", "TENTH+EVENT"];

N = log(: , 6);
matrice = table2array(N);
% Number of arrivals
in = contains (matrice, 'IN');
A = sum(in);

% Number of completions
out = contains (matrice, 'OUT');
C = sum(out);

% Number of jobs
N = (A + C) / 2;

% Finding the first IN in the log
for i = 1: +1: (N * 2) 
    if in(i,1) == 1
        first_in = i;
        break
    end
end
% Finding the last OUT in the log
for j = (N * 2): -1: 1
    if out(j,1) == 1
        last_out = j;
        break
    end
end

log.YEARS = strrep(log.YEARS, '[', '');
log.YEARS = str2double(log.YEARS);

split_cell = split(matrice, ']');

diff_year = (log(last_out, "YEARS") - log(first_in, "YEARS")) .* 365 .* 12 .* 30 .* 24 .* 60 .* 60 .* 1000;
diff_days = (log(last_out, "DAYS") - log(first_in, "DAYS")) .* 24 .* 60 .* 60 .* 1000;
diff_days = diff_days.DAYS(1);
T = 0;

if (diff_days == 86400000)
    in_hours = (log(first_in, "HOURS")) .*60 .*60 .*1000;
    in_mins = (log(first_in, "MINUTES")) .*60 .*1000;
    in_seconds = (log(first_in, "SECONDS")) .*1000;
    in_tenth = str2double(split_cell{first_in}) * 100;
    in_time = in_hours.HOURS + in_mins.MINUTES + in_seconds.SECONDS + in_tenth;

    out_hours = (log(last_out, "HOURS")) .*60 .*60 .*1000;
    out_mins = (log(last_out, "MINUTES")) .*60 .*1000;
    out_seconds = (log(last_out, "SECONDS")) .*1000;
    out_tenth = str2double(split_cell{last_out}) * 100;
    out_time = out_hours.HOURS + out_mins.MINUTES + out_seconds.SECONDS + out_tenth;
    % Time between the first IN and the last OUT
    T = (86400000 - abs(out_time - in_time));
    resto = mod(T, 1000);
    T = ((T - resto) / 1000) + (resto / 1000); % in seconds
end

% Arrival rate
Lambda = A / T;

% Average inter-arrival time
A_intertime = 1 / Lambda;

% Throughput
X = C / T;

j = 1;
k = 1;
for i = 1: +1: (N * 2)
    if (in(i,1) == 1)
        data_ora = datetime(log(i,"YEARS").YEARS, 1, 1, log(i,"HOURS").HOURS, log(i,"MINUTES").MINUTES, log(i,"SECONDS").SECONDS) + days(log(i,"DAYS").DAYS - 1) + milliseconds(str2double(split_cell(i,1))*100);
        data_formattata(j,1) = datetime(data_ora, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        j = j + 1;
    else
        data_ora = datetime(log(i,"YEARS").YEARS, 1, 1, log(i,"HOURS").HOURS, log(i,"MINUTES").MINUTES, log(i,"SECONDS").SECONDS) + days(log(i,"DAYS").DAYS - 1) + milliseconds(str2double(split_cell(i,1))*100);
        data_formattata(k,2) = datetime(data_ora, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        k = k + 1;
    end
end

% Response time i-th
Rt = data_formattata(:,2) - data_formattata(:,1);
% Area of the difference between arrivals and departures functions
W = sum(Rt);
W = seconds(W);

% Average response time
R = W / C;
% Average number of jobs
Naverage = W / T;
% Probability to have a response time less than 30 sec
PRless30 = sum(Rt < "00:00:30") / C;
% Probability to have a response time less than 3 mins
PRless3min = sum(Rt < "00:03:00") / C;

evs = [posixtime(data_formattata(:,1)), ones(A, 1), zeros(A, 4); posixtime(data_formattata(:,2)), -ones(C,1), zeros(C, 4)];
evs = sortrows(evs, 1);
evs(:,3) = cumsum(evs(:,2));
evs(1:end-1, 4) = evs(2:end,1) - evs(1:end-1,1);
evs(:,5) = (evs(:,3) > 0) .* evs(:,4);
evs(:,6) = evs(:,3) .* evs(:,4);

% Busy time
B = sum(evs(:,5));
% Utilization
U = B / T;
% Average service time
S = B / C;

% Probability of having 0 jobs in queue
P0jobs = sum((evs(:,3) == 0) .* evs(:,4)) / T;
% Probability of having 1 jobs in queue
P1jobs = sum((evs(:,3) == 1) .* evs(:,4)) / T;
% Probability of having 2 jobs in queue
P2jobs = sum((evs(:,3) == 2) .* evs(:,4)) / T;

% Probabily of having inter-arrival time shorter than 1 min
for i = 1: +1: (N - 1)
    intertime(i,1) = ((posixtime(data_formattata(i+1,1)) - posixtime(data_formattata(i,1))) / 60);
end
Pintertime = sum(intertime < 1) / A;

% Probability of having a service time greater than 1 min
serviceTime(1,1) = (posixtime(data_formattata(i, 2)) - posixtime(data_formattata(i, 1))) / 60;
for i = 2: +1: N
    serviceTime(i,1) = (posixtime(data_formattata(i, 2)) - max(posixtime(data_formattata(i, 1)), posixtime(data_formattata(i-1, 2)))) / 60;
end
Pservicetime = sum(serviceTime > 1) / C;

% Prints
fprintf(1, "Arrival Rate: %g, Throughput %g\n", Lambda, X);
fprintf(1, "Average Inter-arrival Time: %g\n", A_intertime);
fprintf(1, "Utilization: %g\n", U);
fprintf(1, "Average Service Time: %g\n", S);
fprintf(1, "Average Number of jobs: %g\n", Naverage);
fprintf(1, "Average Response Time: %g\n", R);
fprintf(1, "Pr(0 jobs in the machine): %g\n", P0jobs);
fprintf(1, "Pr(1 jobs in the machine): %g\n", P1jobs);
fprintf(1, "Pr(2 jobs in the machine): %g\n", P2jobs);
fprintf(1, "Pr(Response time < 30 seconds): %g\n", PRless30);
fprintf(1, "Pr(Response time < 3 min): %g\n", PRless3min);
fprintf(1, "Pr(Inter-arrival time < 1 min): %g\n", Pintertime);
fprintf(1, "Pr(Service time > 1 min): %g\n", Pservicetime);
