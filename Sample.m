clear

format long

%instrhwinfo('visa','ni')
%% OPEN POWER SUPPLY PROGRAMMER
gpower = visa('ni', 'ASRL1::INSTR');
fopen(gpower)

%% CLOSE POWER SUPPLY PROGRAMMER

fclose(gpower);
delete(gpower);
clear(gpower);