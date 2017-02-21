clear
clc

addpath /Users/pieropoli/GISMO_r362/GISMO
startup_GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat

%% correlation parameters
Nstd=1; % paramter to multiply the std of the correlation rms and remove spkes

InputDirectory = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed';
fmin = 2; % low-cutt of filter (Hz)
fmax = 8; % high-cut of filter (Hz)
btord = 3; % number of poles in Butterworth filter
smoothMethod = 'median'; % can be 'taper' or 'median'
Wn = 10; % smoothing in samples
K = 2*Wn-1;
windowMin = 60; % window length (min)
overlapPercent = 0.5; % window overlap used to calculate the corr.
DistLim = 150;

outputDirectory = 'CorrFB2-8';
%%
out = loaddatafromdir(InputDirectory);

%% run the code
for i1 = 1 : length(out)
    
RunCorrelation(InputDirectory,outputDirectory,out(i1).name,fmin,fmax,btord,windowMin,overlapPercent)
% RunCorrelation(InputDirectory,outputDirectory,out(i1).name,fmin,fmax,btord,windowMin,overlapPercent)    
end
