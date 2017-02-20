clear

format long

%instrhwinfo('visa','ni')
%% OPEN POWER SUPPLY PROGRAMMER
gpower = visa('ni', 'GPIB0::22::INSTR');
fopen(gpower);

%% CLOSE POWER SUPPLY PROGRAMMER

fclose(gpower);
delete(gpower);

%% OPEN POWER SUPPLY PROGRAMMER
glock = visa('ni', 'GPIB0::8::INSTR');
fopen(glock);

%% CLOSE POWER SUPPLY PROGRAMMER

fclose(glock);
delete(glock);