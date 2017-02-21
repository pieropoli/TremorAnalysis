clear
clc
close

dire = 'ATFdetectionhighfreq';


station = 'ATVO';
d = dir([ dire '/' station ]);d(1:2)=[];

for i1 = 1 : length(d)
    
    
    load([dire '/' station '/' d(i1).name])
    w = windowH(1:end)./Fs;
    

    Rm = E;
    
    % hourly mean
    for ih = 1 : size(E,2)
        rtmp = E(:,ih);
        
        Fd = find(rtmp>(mean(rtmp)+std(rtmp)*2));
        
        rtmp(Fd)=0;
        
        Rh(ih) = mean(rtmp);
        
    end
    

        
        for id = 1 : length(w) -1
            time(id) = addtodate(start,round(w(id)/3600),'hour');
        end
        
        
        if i1 ==1
            timeplot = time;
            Rplot = Rh;
            Tplot = mean(T);
            Eplot = mean(E);
            Lplot = mean(L);
        else
            timeplot = cat(2,timeplot,time);
            Rplot=cat(2,Rplot,Rh);
            Tplot=cat(2,Tplot,mean(T));
            Eplot=cat(2,Eplot,mean(E));
            Lplot=cat(2,Lplot,mean(L));
            
        end
        
        

    
    clear Ti time
end

[timeplot,ix] = sort(timeplot);
Rplot=Rplot(ix);
Fplot = find(Rplot>0);
Rplot = Rplot(Fplot);
timeplot = timeplot(Fplot);
Rplotf = Rplot;
Lplot = Lplot(Fplot);
Tplot = Tplot(Fplot);
Eplot = Eplot(Fplot);

% % Highpass
[a1,b1]=butter(2,1/3*2*1,'high');
Rplotf = abs(filtfilt(a1,b1,Rplotf));

% smooth
windowSize = 7;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Rplotf = normalizeMy((filter(b,a,Rplotf)));


% subplot(4,1,1)
% plot(timeplot,Tplot)
% datetick('x')
% title('Tremor')
% 
% subplot(4,1,2)
% plot(timeplot,Eplot)
% datetick('x')
% title('High freq.')
% 
% 
% subplot(4,1,3)
% plot(timeplot,Lplot)
% datetick('x')
% title('Low freq.')


subplot(4,1,[1 2])
plot(timeplot,Rplotf,'-b')
datetick('x')
title('Rh')


hold on
plot(timeplot,ones(size(timeplot)).*mean(Rplotf),'--r')

plot(timeplot,ones(size(timeplot)).*(mean(Rplotf)+3*std(Rplotf)),'-k')

plot(timeplot,ones(size(timeplot)).*(mean(Rplotf)+2*std(Rplotf)),'--k')

datetick('x')
title(['Station' stationname])



%% plot data
close
Fdetection = find(Rplotf>(mean(Rplotf)+3*std(Rplotf)));
da = datestr(timeplot(Fdetection));
time = datevec(da);
% F = find(time(:,4)>8&time(:,4)<21);
% da(F,:)=[];
FB = [2 8]
[a1,b1]=butter(2,FB*2*(1/20));
for i1 = 1 : length(da)

    load(['ATFOneStation/data_' da(i1,1:11) '.mat']);

    dataplot = get(W,'data');
    time = datevec(da(i1,:));
    t1 = time(4)*20*3600+1;
    t2 = t1+1*3600*20-1;
    t = 0:1/20:(length(dataplot(t1:t2))-1)*(1/20);

    plot(t,(filtfilt(a1,b1,dataplot(t1:t2))))
    title(da(i1,:))
    pause
    close
end


