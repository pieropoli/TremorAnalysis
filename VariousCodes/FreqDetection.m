clear
clc
close
%% FBs =
FB1 = [0.02 0.3];
FB2 = [1 4];
FB3 = [8 9];


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
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/chileRamp/julDay_1.mat')
W = demean(W);
W = detrend(W);
stala=get(W,'stla');
stalo=get(W,'stlo');
staname = get(W,'station');

%% remove any blank traces

blankIdx    = ( sum(double(W),1) == 0 ); % find blank traces
W(blankIdx) = []; % remove blank traces
Fs = get(W(1),'Fs');
%% index of zeros
zerosIdx    = ( (double(W)) == 0 );
%% data processing

Filt   = filterobject('B',FB1,btord); % create a frequency filter for waveform
W1 = double(filtfilt(Filt,W)); % apply the filter to the data

Filt   = filterobject('B',FB2,btord); % create a frequency filter for waveform
W2 = double(filtfilt(Filt,W)); % apply the filter to the data

Filt   = filterobject('B',FB3,btord); % create a frequency filter for waveform
W3 = double(filtfilt(Filt,W)); % apply the filter to the data


%% make detection

detectionMatrix=zeros(size(W1,2),24);

for sta=2 : size(W1,2);
windowH = 1 : 3600*Fs : length(W3);
window = 1 : (dw*Fs) : 3600*Fs ;

data1 = W1(:,sta);
data2 = W2(:,sta);
data3 = W3(:,sta);

% make hour data
for ih = 1 : length(windowH) 
    
    tmp1 = abs(data1(windowH(ih):windowH(ih)+3600*Fs-1));
    tmp2 = abs(data2(windowH(ih):windowH(ih)+3600*Fs-1));
    tmp3 = abs(data3(windowH(ih):windowH(ih)+3600*Fs-1));
    for im = 1 : length(window) - 1
    
    E(im,ih) = mean(tmp1(window(im):window(im)+dw*Fs-1));
    T(im,ih) = mean(tmp2(window(im):window(im)+dw*Fs-1));    
    S(im,ih) = mean(tmp3(window(im):window(im)+dw*Fs-1));     
    Ratio(im,ih) = (T(im,ih)^2)/( S(im,ih)* E(im,ih));    

    end
    clear tmp1 tmp2 tmp3
end

Sh = mean(S,1);
Sd = min(min(S));
Sn = Sh./Sd;
subplot(411)
t = 0 :1/Fs : (size(data1,1)-1)/Fs;
plot(t./3600,normalizeMy(data2'))
hold on
plot(t./3600,normalizeMy(data1'),'r')
xlim([-1 25])
subplot(412)
imagesc((windowH./Fs)./3600,[],Ratio)
xlim([-1 25])

for i1 = 1 : size(Ratio,2)
 tmp = Ratio(:,i1); 
    M = mean(tmp)+0.66*std(tmp);
   
    F = find(tmp<M);
  Rh(i1) = mean(Ratio(F,i1));



end
Rh = mean(Ratio,1);


subplot(413)
plot((windowH(2:end)./Fs)./3600,Rh)
hold on
plot([0 25],[mean(Rh) mean(Rh)],'--k')
plot([0 25],[mean(Rh)+0.99*std(Rh) mean(Rh)+0.99*std(Rh)],'--r')
xlim([-1 25])


%% plot detections
F = find(Rh>mean(Rh)+0.99*std(Rh));
 detectionMatrix(sta,F)=1;
if isempty(F) ==0
   for ip = 1 : length(F) 
    f = find(t>windowH(F(ip))/Fs&t<windowH(F(ip))/Fs+3600);
    subplot(414),hold on
    plot(t(f)./3600,normalizeMy(data2(f)'))
    
   end
end
xlim([-1 25])

pause
close
end