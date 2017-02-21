clear
clc
close




%% FBs =
FB1 = [0.01 0.05];
FB2 = [2 8];
FB3 = [7 9];


%% addpaths

addpath /Users/pieropoli/GISMO_r362/GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat
addpath /Users/pieropoli/Seismic_Matlab_Functions
startup_GISMO


%% parameters detection
%filter
btord=3;
dw = 5*60; % in minutes

%% load the data
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/SourceScanning/ChileSouth2005/julDay_1.mat')
W = demean(W);
W = detrend(W);
stala=get(W,'stla');
stalo=get(W,'stlo');
staname = get(W,'station');

%% remove any blank traces

blankIdx    = ( sum(double(W),1) == 0 ); % find blank traces
W(blankIdx) = []; % remove blank traces
Fs = get(W(1),'Fs');
%% data processing

Filt   = filterobject('B',FB1,btord); % create a frequency filter for waveform
W1 = double(filtfilt(Filt,W)); % apply the filter to the data

Filt   = filterobject('B',FB2,btord); % create a frequency filter for waveform
W2 = double(filtfilt(Filt,W)); % apply the filter to the data

Filt   = filterobject('B',FB3,btord); % create a frequency filter for waveform
W3 = double(filtfilt(Filt,W)); % apply the filter to the data


for sta = 10 : 26;

plot((normalizeMy(W1(min(x)-100:max(x)+1000,sta)')))
hold on
plot(normalizeMy(W2(min(x)-1000:max(x)+1000,sta)'),'r')
% plot(normalizeMy(W3(:,sta)'),'g')
pause
close
end

d = distance(get(W(10),'stla'),get(W(10),'stlo'),get(W,'stla'),get(W,'stlo'))