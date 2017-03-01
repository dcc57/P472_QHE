clear

format long

%instrhwinfo('visa','ni')
%% OPEN POWER SUPPLY PROGRAMMER
gpower = gpib('ni', 0, 22);
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
glock3 = visa('ni', 'GPIB0::2::INSTR');
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

%% LOCKIN1 SET OUTPUT
Vout = 0.005;
fout = 100;


A = ['SLVL ',num2str(Vout)];
B = ['FREQ ',num2str(fout)];
fprintf(glock1,A);
fprintf(glock1,B);

%% LOCKIN1 READ SIGNAL

fprintf(glock1,'OUTR? 1');
Vin = fscanf(glock1)
fprintf(glock1,'OUTR? 2');
Deg = fscanf(glock1)


%% Power Supply Command
fprintf(gpower, 'FIELD:MAG?;')
%out = fscanf(gpower)
%fprintf(gpower, 'SYST:ERR?;')
out = fscanf(gpower)
%fprintf(gpower, 'CONF:RAMP:RATE:CURR 0.02')


%% Power Supply Errors
fprintf(gpower, 'SYST:ERR?;')
out = fscanf(gpower)


%% MEASUREMENT

tic
i = 0;
MaxTime = 1500; %Seconds
dT = 0.5; %Seconds
T = zeros(ceil(MaxTime/dT),1);
B  = T;
V1 = T;
V2 = T;
V3 = T;
while T(ceil(MaxTime/dT)) == 0
    pause(dT - 0.0222)
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
end

%% MEAN TIME-STEP
X = zeros(nnz(T),1);
for i = 2:nnz(T) - 1
    X(i) = T(i + 1) - T(i);
end
X = X(X > 0);
mean(X)

%% DATA ANALYSIS

R = 1000; %Ohms
Q = 6.62607004E-34 * (1.60217662E-19)^(-2); %[h/e^2] = Ohms
Ohms2Q = 1/Q;

Current = V1 ./ R;
RLong = Ohms2Q * V2 ./ Current;
RTran = Ohms2Q * V3 ./ Current;

%% DATA PLOTALYSIS

figure(1)
hold on
plot(T, RLong)
title('Longitudinal Resistance Across Semiconductor Vs. Time','Interpreter','latex')
xlabel('Time (s)','Interpreter','latex')
ylabel('$\rho_{xx}$ $({h}/{e^2})$','Interpreter','latex')
hold off

figure(2)
hold on
plot(T, RTran)
title('Transverse Resistance Across Semiconductor Vs. Time','Interpreter','latex')
xlabel('Time (s)','Interpreter','latex')
ylabel('$\rho_{xy}$ $({h}/{e^2})$','Interpreter','latex')
hold off