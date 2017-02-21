clear
clc
close
%% addpaths

addpath /Users/pieropoli/GISMO_r362/GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat
addpath /Users/pieropoli/Seismic_Matlab_Functions
startup_GISMO

dw = 3600*2; % in sec

datadir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/DataGro';
d=dir(datadir);
d(1:2)=[];
outdir ='envelopesGROnet';
mkdir(outdir)

btord=3;
FB = [2 5];

for i1 = 1 : length(d)
    
    
    %% load the data
    load([datadir '/' char(d(i1).name)])
    
    F = find(strcmp(get(W,'station'),'GO03')==1);
    
    if isempty(F) == 0
        
        W = demean(W);
        W = detrend(W);
        stala=get(W,'stla');
        stalo=get(W,'stlo');
        
        datei = get(W(1),'start');
        lat = get(W,'STLA');
        staname = get(W,'station');
        %% remove any blank traces
        
        blankIdx    = ( sum(double(W),1) == 0 ); % find blank traces
        W(blankIdx) = []; % remove blank traces
        Fs = get(W(1),'Fs');
        %% data processing
        % filter
        Filt   = filterobject('B',FB,btord); % create a frequency filter for waveform
        W = ((filtfilt(Filt,W))); % apply the filter to the data
        
        %  low pass
%         Filt   = filterobject('L',0.1,btord);
%         W = filtfilt(Filt,W); % apply the filter to the data
%         
%         % resample
%         W = (abs(power(resample(W,'mean', Fs),1/2)));
%         
%         W = (double(W));
        
        

        hold on
        plot(W(F),'k');
       
        
        
        box on
        eval(['print -dpng ' outdir '/env_' datestr(datei,'mmmyydd') ])
        close
        
    end
    
end


