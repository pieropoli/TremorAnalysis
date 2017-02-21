clear
clc
close
addpath /Users/pieropoli/GISMO_r362/GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat
addpath /Users/pieropoli/Seismic_Matlab_Functions
startup_GISMO


load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation1day/data_03-Jan-2013.mat')
FB = [2 8];
btord=3;

% filter
Filt   = filterobject('B',FB,btord); % create a frequency filter for waveform
W = power((filtfilt(Filt,W)),2); % apply the filter to the data

%  low pass
Filt   = filterobject('L',0.1,btord);
W = filtfilt(Filt,W); % apply the filter to the data

% resample
W = (abs(power(resample(W,'mean', 20),1/2)));

W = (double(W));

%% correlation
win = 5; % in minutes

windowH = 1 : win*60 : length(W);


for ih = 1 : length(windowH) - 1
    
   tmp = detrend(W(windowH(ih):windowH(ih+1),:)); 
    
   [DataAlign,corrCoeff,delay] = MccAlignment(tmp');
    
   C(ih) = mean(mean(corrCoeff));
end

