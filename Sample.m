clear

format long

%instrhwinfo('visa','ni')
%% OPEN POWER SUPPLY PROGRAMMER
gpower = visa('ni', 'GPIB0::22::INSTR');
fopen(gpower)

%% CLOSE POWER SUPPLY PROGRAMMER

fclose(gpower);
delete(gpower);
clear(gpower);