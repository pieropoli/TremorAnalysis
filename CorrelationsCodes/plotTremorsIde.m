clear
clc
close
n = 1;

T0 = 4;
to = 3600;
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed/julDay_5.mat')

Filt   = filterobject('B',[2,4],3); % create a frequency filter for waveform
W1 = filtfilt(Filt,W); % apply the filter to the data

Filt   = filterobject('B',[0.01,0.05],3); % create a frequency filter for waveform
W2 = filtfilt(Filt,W); % apply the filter to the data

for i1 = 1 : 8
    
    Wp = double(W1(i1));
     Wp2 = double(W2(i1));
    
    Wp = Wp(T0*3600*25:T0*3600*25+to*25);
     Wp2 = Wp2(T0*3600*25:T0*3600*25+to*25);
    
    
    plot(i1+Wp./max(Wp)./2)
    hold on
     plot(i1+Wp2./max(Wp2),'r')
    
    
end