clear
clc
close
btord=3;
%% load file
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/DataChileTJ/data_02-Jan-2007.mat')

%% spec parameters
FB = [0.02 0.05];

Filt   = filterobject('B',FB,btord); % create a frequency filter for waveform
W = ((filtfilt(Filt,W))); % apply the filter to the data

Wp = double(W);

for i1 = 1 : size(Wp,2)
    hold on
   plot(i1+Wp(:,i1)./max(abs(Wp(:,i1))),'k') 
    
    
end

% The relevance of