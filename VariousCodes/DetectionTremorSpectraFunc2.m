function DetectionTremorSpectraFunc2(data,outdir,i1)

%% FBs =
FB1 = [0.02 0.1];
FB2 = [2 5];
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
load(data)
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

Filt   = filterobject('B',FB2,btord); % create a frequency filter for waveform
W2 = double(filtfilt(Filt,W)); % apply the filter to the data

Filt   = filterobject('B',FB3,btord); % create a frequency filter for waveform
W3 = double(filtfilt(Filt,W)); % apply the filter to the data

Filt   = filterobject('B',FB1,btord); % create a frequency filter for waveform
W1 = double(filtfilt(Filt,W)); % apply the filter to the data


for sta=1 : size(W2,2);
    if   exist(([outdir '/' get(W(sta),'station')]),'dir') == 0
        mkdir([outdir '/' get(W(sta),'station')])
    end
    windowH = 1 : 3600*Fs : length(W2);
    window = 1 : (dw*Fs) : 3600*Fs ;
    data2 = W2(:,sta);
    data3 = W3(:,sta);
    data1 = W1(:,sta);
    % make hour data
    for ih = 1 : length(windowH) - 1
        tmp3 = abs(data3(windowH(ih):windowH(ih)+3600*Fs-1));

        tmp2 = abs(data2(windowH(ih):windowH(ih)+3600*Fs-1));
        tmp1 = abs(data1(windowH(ih):windowH(ih)+3600*Fs-1));

        for im = 1 : length(window)
            L(im,ih) = mean(tmp1(window(im):window(im)+dw*Fs-1));

            T(im,ih) = mean(tmp2(window(im):window(im)+dw*Fs-1));
            E(im,ih) = mean(tmp3(window(im):window(im)+dw*Fs-1));
        end
        clear tmp2 %tmp1 tmp2 tmp3
    end
    

    
    datedata=datestr(get(W(sta),'start'));
    stationname = get(W(sta),'station');
    fname = [outdir '/' get(W(sta),'station') '/detection_' datedata '_' get(W(sta),'station') '.mat'];
    %% save
    day = get(W(1),'NZJDAY');
    lat=get(W,'stla');
    lon=get(W,'stlo');
    start=get(W(1),'start');
    save(fname,'day','lat','lon','stationname','windowH','Fs','start','T','datedata','E','L');

end