clear
clc
close

addpath /Users/pieropoli/GISMO_r362/GISMO
startup_GISMO
%addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat


load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed/julDay_5.mat')


btord=3;
FB = [0.1 0.5];
FB2 = [2 8];

FB3 = [0.02 0.05];
% filter
Filt   = filterobject('B',FB,btord); % create a frequency filter for waveform
W1 = filtfilt(Filt,W); % apply the filter to the data

Filt   = filterobject('B',FB2,btord); % create a frequency filter for waveform
W2 = filtfilt(Filt,W); % apply the filter to the data

Filt   = filterobject('B',FB3,btord); % create a frequency filter for waveform
W3 = filtfilt(Filt,W); % apply the filter to the data

w = double(W1);
w2 = double(W2);
w3 = double(W3);


load('stacoord.mat')

for i1 = 3 %1 : size(W,2)
    
    plot(i1+(w2(:,i1)')./max(abs((w2(:,i1)'))))
    hold on
%     plot(i1+(w(:,i1)')./max(abs((w2(:,i1)'))),'k')
    plot(i1+(w3(:,i1)')./max(abs((w3(:,i1)'))),'r')
    plot(lo,la,'ok')
    
    
end