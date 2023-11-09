clc; clear all;

% 0 = Initial state
% 1 = Crate 1
% 2 = Crate 2
% 3 = Exit - Win
% 4 = Fall down - Lost

s0 = 0;
s = s0;
t = 0;
i = 0;
j = 1;
durata = 0;
T = 10000; % Minutes

trace = [T, s0];

while(t < T)
    if(s == 0) % Initial state - entrance
        if(rand() <= 0.3)
            if(rand() <= 0.3) % From Entrance to C2 - light blue path
                ns = 2;
                dt = 3 + rand() * (6-3); 
                durata = durata + dt;
                else % From Entrance to Fall down - light blue path
                        ns = 4;
                        dt = -log (rand()) / 0.25;
                        durata = durata + dt;
            end
            else
                if(rand() <= 0.2) % From Entrance to Fall down - yellow path
                    ns = 4;
                    dt = -log (rand()) / 0.5;
                    durata = durata + dt;
                    else % From Entrance to C1 - yellow path
                        ns = 1;
                        dt = -log(prod(rand(4,1))) / 1.5;
                        durata = durata + dt;
                end
        end
    end
    if(s == 1) % C1 - state
        if(rand() <= 0.5) 
            if(rand() <= 0.4) % From C1 to Fall down - white path
                ns = 4;
                dt = -log(rand()) / 0.2;
                durata = durata + dt;
                else % From C1 to C2 - white path
                        ns = 2;
                        dt = -log (rand()) / 0.15;
                        durata = durata + dt;
            end
            else  
                if(rand() <= 0.25) % From C1 to C2 - yellow path
                    ns = 2; % C2 - state
                    dt = -log(prod(rand(3,1))) / 2;
                    durata = durata + dt;
                    else % From C1 to Fall down - yellow path
                            ns = 4;
                            dt = -log (rand()) / 0.4;
                            durata = durata + dt;
                end
        end
    end
    if(s == 2) % C2 - state
        if(rand() <= 0.4) % From C2 to Fall down
            ns = 4;
            dt = -log(prod(rand(5,1))) / 4;
            durata = durata + dt;
            else 
                ns = 3; % Win - Exit
                dt = -log(prod(rand(5,1))) / 4;
                durata = durata + dt;
        end
    end
    if(s == 3) % Exit state
        ns = 0; % Go back to Entrance
        dt = 5; % 5 minutes to add
    end
    if(s == 4) % Fall down state
        ns = 0; % Go back to Entrance
        dt = 5; % 5 minutes to add
    end

    s = ns;
    t = t + dt; 
    if(ns == 0)
        durataTrace(j,1) = durata;
        durata = 0;
        j = j + 1;
    end
    i = i + 1;
    trace(i, :) = [t, s];
end

Tot_games = sum(trace(:,2) == 0);
Tot_wins = sum(trace(:,2) == 3);
Prob_wins = Tot_wins / Tot_games;
Average_Game = sum(durataTrace) / Tot_games;
Throughput = (Tot_games / t) * 60;

fprintf(1, "Winning probability: %g%%\n", Prob_wins * 100);
fprintf(1, "Average game duration: %g minutes (not considering 5 mins between every game)\n", Average_Game);
fprintf(1, "Throughput: %g games per hour\n", Throughput);
fprintf(1, "Number of simulations: %g\n", Tot_games);
