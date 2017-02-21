clear
clc
close

%% code to make autocorrelation detection as in Brwon paper. [very slow right now]
% GISMO NEEDED as this code loead waveform object. But can be easily
% adapted.

%% Feb. 2017
% ppoli@mit.edu


 %% read the data

load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed/julDay_5.mat')

%% use parameters
FB =[0.01,0.1]; % frequency band
win = 250; % size og the window (note that the movout shoud be less than this otherwise no detection)
lag = 0.5;
btord = 3;


%% selef determined paramters
Fs = get(W(1),'Fs');

%% filtering

Filt   = filterobject('B',FB,btord); % create a frequency filter for waveform
W1 = filtfilt(Filt,W); % apply the filter to the data
data = double(W1);

T = 1 : lag*Fs : length(data)-win*Fs-1;
ctoto = eye(length(T),'single');

%% Run the scanning

for ij = 1 : length(T)
    for ii = ij+1 : length(T)
        data1 = data(T(ij):T(ij)+win*25,:);
        data2 = data(T(ii):T(ii)+win*25,:);
        c = zeros(1,size(data1,2));
        for is = 1 : size(data,2)
            c(is) = corrc_norm(data1(:,is),data2(:,is)); 
        end
        ctoto(ij,ii) = sum(c);
    end
end
ctoto = ctoto + ctoto' - eye(size(ctoto));



%% save  the output