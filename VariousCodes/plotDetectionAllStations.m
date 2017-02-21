clear
clc
close


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


subplot(4,1,1)
stem(Tplot,(Nev))
datetick('x')
xlim([Tid(1) Tid(end)])
dire = 'DetectionNavidad';
D = dir(dire);D(1:2)=[];


subplot(4,1,[2 3 4])
for ik = 1 : length(D)

station = D(ik).name;
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
        
        
%            % check mag
%         F = find(Te>min(time)&Te<max(time));
%         
%         if isempty(F) ==0
%             1
%             Rh = zeros(size(Rh));
%         end
        
        
        
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


% % Highpass
[a1,b1]=butter(2,(1/7*24)*2/24,'high');
Rplot = abs(filtfilt(a1,b1,Rplot));

% % smooth

%Rplot = smooth(Rplot,7*24);



%Rplot(Fplot)=0;

hold on
stairs(timeplot,normalizeMy(Rplot)+ik,'-k')
clear Rplot Rh 
end
xlim([min(timeplot) max(timeplot)])

subplot(4,1,1)

datetick('x')
xlim([min(timeplot) max(timeplot)])