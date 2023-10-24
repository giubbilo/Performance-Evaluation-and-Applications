clc; clear all;

% Scenario 1

M = 1000; % Number of jobs in one batch
gam = 0.95;
d_gamma = norminv((1 + gam)/2);
Max_Rel_Err = 0.04;

K0 = 1000;
maxK = 20000;
DK = 100;
K = K0;

tA = 0;
tC = 0;
U = 0;
U2 = 0;
R = 0;
R2 = 0;
X = 0;
X2 = 0;
N = 0;
N2 = 0;
Var = 0;
Var2 = 0;

newIters = K;

while (K < maxK)
	for i = 1: newIters
		Busy_time = 0;
		Wi = 0;
		tA0 = tA;
	
		for j = 1: M
			arr_ji = arrivalRand();
			serv_ji = serviceRand();
			
            tA = tA + arr_ji;
			tC = max(tA, tC) + serv_ji;
			Resp_time = tC - tA;
			Resp_trace((i-1) * M + j, 1) = Resp_time;
			Trace_var(j,1) = Resp_time;

			Busy_time = Busy_time + serv_ji;
			
			Wi = Wi + Resp_time;
		end
		
		Avg_Resp_Time = Wi / M;
		R = R + Avg_Resp_Time;
		R2 = R2 + Avg_Resp_Time^2;
		
		Ti = tC - tA0;
		Ui = Busy_time / Ti;
		U = U + Ui;
		U2 = U2 + Ui^2;

        Xi = M / Ti;
        X = X + Xi;
        X2 = X2 + Xi^2;

        Ni = Wi / Ti;
        N = N + Ni;
        N2 = N2 + Ni^2;

        Var_i = var(Trace_var);
        Var = Var + Var_i;
        Var2 = Var2 + Var_i^2;
	end
	
	Rm = R / K;
	Rs = sqrt((R2 - R^2 / K) / (K-1));
	CiR = [Rm - d_gamma * Rs / sqrt(K), Rm + d_gamma * Rs / sqrt(K)];
	errR = 2 * d_gamma * Rs / sqrt(K) / Rm;
	
	Um = U / K;
	Us = sqrt((U2 - U^2 / K) / (K-1));
	CiU = [Um - d_gamma * Us / sqrt(K), Um + d_gamma * Us / sqrt(K)];
	errU = 2 * d_gamma * Us / sqrt(K) / Um;

    Xm = X / K;
    Xs = sqrt((X2 - X^2 / K) / (K-1));
    CiX = [Xm - d_gamma * Xs / sqrt(K), Xm + d_gamma * Xs / sqrt(K)];
	errX = 2 * d_gamma * Xs / sqrt(K) / Xm;

    Nm = N / K;
    Ns = sqrt((N2 - N^2 / K) / (K-1));
    CiN = [Nm - d_gamma * Ns / sqrt(K), Nm + d_gamma * Ns / sqrt(K)];
	errN = 2 * d_gamma * Ns / sqrt(K) / Nm;

    Varm = Var / K;
    Vars = sqrt((Var2 - Var^2 / K) / (K-1));
    CiVar = [Varm - d_gamma * Vars / sqrt(K), Varm + d_gamma * Vars / sqrt(K)];
	errVar = 2 * d_gamma * Vars / sqrt(K) / Varm;
	
	if (errR < Max_Rel_Err && errU < Max_Rel_Err && errX < Max_Rel_Err && errN < Max_Rel_Err && errVar < Max_Rel_Err)
		break;
	else
		K = K + DK;
		newIters = DK;
	end
end

fprintf(1, "Scenario 1: \n");
if (errR < Max_Rel_Err && errU < Max_Rel_Err && errX < Max_Rel_Err && errN < Max_Rel_Err && errVar < Max_Rel_Err)
	fprintf(1, "Maximum Relative Error reached in %d Iterations\n", K);
else
	fprintf(1, "Maximum Relative Error NOT REACHED in %d Iterations\n", K);
end	

fprintf(1, "Utilization in [%g, %g], with %g confidence. Relative Error: %g\n", CiU(1,1), CiU(1,2), gam, errU);
fprintf(1, "Resp. Time in [%g, %g], with %g confidence. Relative Error: %g\n", CiR(1,1), CiR(1,2), gam, errR);
fprintf(1, "Throughput in [%g, %g], with %g confidence. Relative Error: %g\n", CiX(1,1), CiX(1,2), gam, errX);
fprintf(1, "Average number of jobs in [%g, %g], with %g confidence. Relative Error: %g\n", CiN(1,1), CiN(1,2), gam, errN);
fprintf(1, "Variance of the response time in [%g, %g], with %g confidence. Relative Error: %g\n", CiVar(1,1), CiVar(1,2), gam, errVar);

% Arrival - Hyper-exponential
function F_arr = arrivalRand()
    Hyper_lambda1 = 0.2;
    Hyper_lambda2 = 0.02;
    Hyper_p1 = 0.1;
    n1 = rand();
    n2 = rand();
    if(Hyper_p1 <= n1)
        F_arr = -log(n2) / Hyper_lambda1;
        else
            F_arr = -log(n2) / Hyper_lambda2;
    end
end

% Service - Erlang
function F_serv = serviceRand()
    Erlang_lambda = 1.5;
    Erlang_k = 10;
    n_serv = rand(Erlang_k, 1);
    F_serv = -(sum(log(n_serv)) / Erlang_lambda);
end
