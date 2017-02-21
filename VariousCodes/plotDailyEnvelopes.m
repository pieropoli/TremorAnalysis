clear
clc
close
%% addpaths

addpath /Users/pieropoli/GISMO_r362/GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat
addpath /Users/pieropoli/Seismic_Matlab_Functions
startup_GISMO

dw = 3600*2; % in sec

datadir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed';
d=dir(datadir);
d(1:2)=[];
outdir ='envelopeschileS_daily';
mkdir(outdir)

btord=3;
FB = [0.01 0.05];

for i1 = 1 : length(d)
    
    
    %% load the data
    load([datadir '/' char(d(i1).name)])
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
    W = power((filtfilt(Filt,W)),2); % apply the filter to the data
    
    %  low pass
    Filt   = filterobject('L',0.1,btord);
    W = filtfilt(Filt,W); % apply the filter to the data
    
    % resample
    W = (abs(power(resample(W,'mean', Fs),1/2)));
    
    W = (double(W));
    
    [lat,ix] = sort(lat);
    W = W(:,ix);
    staname = staname(ix);
    
    
    %% plot hourly

        for is = 1 : size(W,2)
            
            norm = sort(W(:,is),'descend');
            norm= norm(1:100);
            hold on
            plot(is+W(:,is)./mean(norm).*tukeywin(length(W),.1),'k');
            text(86604,is,char(staname(is)))
        end
        ylim([0 size(W,2)+2])
        %dateplot = addtodate(datei,win(ih),'second');
        title(datestr(datei)) 
        xlim([1 87000])
        box on
        eval(['print -dpng ' outdir '/env_' datestr(datei,'mmmyy') ])
        close
        

    
    
    
    
end