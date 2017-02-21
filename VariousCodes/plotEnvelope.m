clear
clc
close
%% addpaths

addpath /Users/pieropoli/GISMO_r362/GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/ContinuosDataScanning/mat
addpath /Users/pieropoli/Seismic_Matlab_Functions
startup_GISMO

dw = 3600*2; % in sec

datadir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/DataChileTJ';
d=dir(datadir);
d(1:2)=[];
outdir ='EnvelopesChileTJ';
mkdir(outdir)

btord=3;
FB = [3 9];

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
    win = 1:3600:86400;
    for ih = 1 : length(win) -1
        for is = 1 : size(W,2)
            
            norm = sort(W(win(ih):win(ih+1),is),'descend');
            norm= norm(1:100);
            hold on
            plot((W(win(ih):win(ih+1),is)./mean(norm))+is,'k');
            text(3604,0,char(staname(is)))
        end
         ylim([0 size(W,2)+2])
        dateplot = addtodate(datei,win(ih),'second');
        title(datestr(dateplot)) 
        xlim([1 3700])
        box on
        eval(['print -dpng ' outdir '/env_' datestr(dateplot,'mmmyydd') 'H' num2str(round(ih))])
        close
        
    end

    
    
end