clear

format long

%% RUN NUMBER RESET

RunNumber = 0;

%instrhwinfo('visa','ni')
%% OPEN POWER SUPPLY PROGRAMMER
gpower = visa('ni', 'GPIB0::22::INSTR');
fopen(gpower);

%% CLOSE POWER SUPPLY PROGRAMMER
fclose(gpower);
delete(gpower);

%% OPEN LOCKIN1
glock1 = visa('ni', 'GPIB0::3::INSTR');
fopen(glock1);

%% OPEN LOCKIN2
glock2 = visa('ni', 'GPIB0::1::INSTR');
fopen(glock2);

%% OPEN LOCKIN3
glock3 = visa('ni', 'GPIB0::8::INSTR');
fopen(glock3);

%% CLOSE LOCKIN1

fclose(glock1);
delete(glock1);

%% CLOSE LOCKIN2

fclose(glock2);
delete(glock2);

%% CLOSE LOCKIN3

fclose(glock3);
delete(glock3);

%% MEASUREMENT
close all
tic
i = 0;
MaxTime = 800; %Seconds
dT = 0.5; %Seconds
T = zeros(ceil(MaxTime/dT),1);
B  = T;
V1 = T;
V2 = T;
V3 = T;

%plot(T,B,T,V1,T,V2,T,V3)
%fprintf(gpower, 'RAMP;')
figure(3)
hold on
hB = animatedline;
figure(4)
h1 = animatedline;
figure(5)
h2 = animatedline;
figure(6)
h3 = animatedline;
RunNumber = RunNumber + 1;
while T(ceil(MaxTime/dT)) == 0
    pause(dT - 0.061908834472458)
    i = i + 1;
    fprintf(gpower, 'FIELD:MAG?;')
    fprintf(glock1,'OUTR? 1');
    fprintf(glock2,'OUTR? 1');
    fprintf(glock3,'OUTR? 1');
    B(i)  = str2double(fscanf(gpower));
    V1(i) = str2double(fscanf(glock1));
    V2(i) = str2double(fscanf(glock2));
    V3(i) = str2double(fscanf(glock3));
    T(i) = toc;
    addpoints(hB,T(i),B(i))
    addpoints(h1,T(i),V1(i))
    addpoints(h2,T(i),V2(i))
    addpoints(h3,T(i),V3(i))
    drawnow
end
hold off

%% MEAN TIME-STEP
X = zeros(nnz(T),1);
for i = 2:nnz(T) - 1
    X(i) = T(i + 1) - T(i);
end
X = X(X > 0);
mean(X)

%% DATA ANALYSIS

R = 4.7E3; %Ohms
Q = 6.62607004E-34 * (1.60217662E-19)^(-2); %[h/e^2] = Ohms
Ohms2Q = 1/Q;

Current = V1 ./ R;
RLong = Ohms2Q * V3 ./ Current;
RTran = Ohms2Q * V2 ./ Current;

P = ['RLong',num2str(RunNumber)];
Q = ['RTran',num2str(RunNumber)];
R = ['B',num2str(RunNumber)];
S = ['Current',num2str(RunNumber)];

save(P,'RLong')
save(Q,'RTran')
save(R,'B')
save(S,'Current')

%% DATA PLOTALYSIS

figure(1)
hold on
plot(B, RLong)
title('Longitudinal Resistance Across Semiconductor Vs. Magnetic Field','Interpreter','latex')
xlabel('Magnetic Field (KG)','Interpreter','latex')
ylabel('$\rho_{xx}$ $({h}/{e^2})$','Interpreter','latex')
hold off

figure(2)
hold on
plot(B, RTran)
title('Transverse Resistance Across Semiconductor Vs. Magnetic Field','Interpreter','latex')
xlabel('Magnetic Field (KG)','Interpreter','latex')
ylabel('$\rho_{xy}$ $({h}/{e^2})$','Interpreter','latex')
hold off