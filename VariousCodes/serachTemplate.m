clear
clc
close


Fs = 20;
clim=0.7;
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation1day/data_03-Jan-2013.mat')
%load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation1day_2/data_07-Jan-2013.mat')
%load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation/data_03-Jan-2013.mat')


ref = 6;
% d = distance(get(W(6),'stla'),get(W(6),'stlo'),get(W,'stla'),get(W,'stlo'));
% [d,ix] = sort(d);

btord=3;

FB = [4 9]
% filter
Filt   = filterobject('B',FB,btord); % create a frequency filter for waveform
W1 = double(filtfilt(Filt,W));
W = power((filtfilt(Filt,W)),2); % apply the filter to the data

%  low pass
Filt   = filterobject('L',0.1,btord);
W = filtfilt(Filt,W); % apply the filter to the data

% resample
W = (abs(power(resample(W,'mean', 20),1/2)));

W2 = (double(W));
%W2 = W2(:,1:4);


timewin = 150;
window = 1 : (timewin) : 86400 ;
window2 = 1 : (timewin)*Fs : 86400*Fs ;
t1 = 0:timewin;
t2 = 0:1/Fs:timewin;

for it = 1 : length(window) - 1
    subplot(3,2,[1 3 5])
    for i1 = 1 : size(W2,2)
        
        hold on
        plot(t2,i1+normalizeMy(((W1(window2(it):window2(it+1),i1)))').*0.7,'b')
        
        plot(t1,i1+normalizeMy((detrend(W2(window(it):window(it+1),i1)))').*0.7,'r')
        
        D(i1,:) = (detrend(W2(window(it):window(it+1),i1)))';
        
        
    end
    [DataAlign,corrCoeff,delay] = MccAlignment(D);
    cnt = 1;
    for ii1 = 1 : size(corrCoeff,1)
        for ii2 = ii1 + 1 : size(corrCoeff,2)
            
            if corrCoeff(ii1,ii2) > clim
                ind(cnt,:) = [ii1,ii2];
                dt(cnt,:) = [delay(ii1,ii2) delay(ii1,ii2)];
                cnt = cnt+1;
            end
            
        end
    end
    subplot(322)
    imagesc(corrCoeff)
    caxis([clim 1])
    if exist('ind','var') == 1 && length(ind)>4
        [ind,idx] = unique(reshape(ind,size(ind,1)*size(ind,2),1));
        dt = (reshape(dt,size(dt,1)*size(dt,2),1))
        
        subplot(324)
        for ir = 1 : length(ind)
            hold on
            plot(t1,ir+normalizeMy(DataAlign(ind(ir),:)))
            snr(ir,:) = normalizeMy(DataAlign(ind(ir),:));
        end
        
                subplot(326)
        for ir = 1 : length(ind)
            hold on
        plot(t2,ir+normalizeMy(((W1(window2(it):window2(it+1),ind(ir))))').*0.7,'b')
            
        end
   subplot(324)
   plot(t1,ir+1+mean(snr,1),'r')      
   pause
    end
   
   
    median(corrCoeff)
    
    close
    clear ind snr dt
end

