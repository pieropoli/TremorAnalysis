clear
clc
close

dire = 'DetectionNavidad';

[timeevent,lat,lon,depth,mag,magtype] = ParseUSGS_Catalog('catalogEvents.csv');
Te= datenum(timeevent);
Tid = min(Te):max(Te);

for il = 1 : length(Tid)-1
F = find(Te>Tid(il)&Te<Tid(il+1));
    if isempty(F) == 0
    
       Nev(il)=length(F); 
        
    else
        Nev(il)=0;
    end
    
    Tplot(il) = Tid(il)+0.5;
end


station = 'BO01';
d = dir([ dire '/' station ]);d(1:2)=[];

for i1 = 1 : length(d)
    
    
    load([dire '/' station '/' d(i1).name])
    w = windowH(1:end)./Fs;
    

    Rm = (T.^2)./(L.*E);
    
    % hourly mean
    for ih = 1 : size(E,2)
        rtmp = Rm(:,ih);
        
        Fd = find(rtmp>(mean(rtmp)+std(rtmp)*3));
        
        rtmp(Fd)=0;
        
        Rh(ih) = mean(rtmp);
        
    end
    

        
        for id = 1 : length(w) -1
            time(id) = addtodate(start,round(w(id)/3600),'hour');
        end
        
        
           % check mag
        F = find(Te>min(time)&Te<max(time));
        
        if isempty(F) ==0
           
            Rh = zeros(size(Rh));
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
Rplotf = sqrt(Rplot);
Lplot = Lplot(Fplot);
Tplot = Tplot(Fplot);
Eplot = Eplot(Fplot);
% % Highpass
[a1,b1]=butter(2,(1/7*24)*2/24,'high');
Rplotf = abs(filtfilt(a1,b1,Rplotf));

% % smooth
windowSize = 10*24;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Rplotf = normalizeMy((filter(b,a,Rplotf)));

subplot(4,1,1)
plot(timeplot,sqrt(Tplot))
datetick('x')
title('Tremor')

subplot(4,1,2)
plot(timeplot,sqrt(Eplot))
datetick('x')
title('High freq.')


subplot(4,1,3)
plot(timeplot,sqrt(Lplot))
datetick('x')
title('Low freq.')


subplot(414)
stairs(timeplot,Rplotf,'-b')
datetick('x')
title('Rh')


hold on
plot(timeplot,ones(size(timeplot)).*mean(Rplotf),'--r')

plot(timeplot,ones(size(timeplot)).*(mean(Rplotf)+3*std(Rplotf)),'-k')

plot(timeplot,ones(size(timeplot)).*(mean(Rplotf)+2*std(Rplotf)),'--k')

datetick('x')
title(['Station' stationname])
