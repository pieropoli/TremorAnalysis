clear
clc
close


dire = 'detectionRampChile';
d = dir(dire);d(1:2)=[];



for stationN=1:7;

    
    
for i1 = 1 : length(d)
    
    
   load([dire '/' d(i1).name]) 
   w = windowH(1:end)./Fs; 
   Ti = squeeze(T(:,:,stationN));
   
   S = rms(Ti,1);
   
   F = find(S>mean(S)*2);
   Ti(:,F) = 0;
   
   
   for id = 1 : length(w) 
   time(id) = addtodate(start,round(w(id)/3600),'hour');
   end


   if i1 ==1
   timeplot = time;
   Rplot = mean(Ti);
   else
   timeplot = cat(2,timeplot,time);
   Rplot=cat(2,Rplot,mean(Ti));
       
   end
   
   clear Ti
end

if stationN==1
   MatrixDetection =zeros(7,length(Rplot));  
    
    
end


[timeplot,ix] = sort(timeplot);
Rplot=Rplot(ix);

% Highpass
[a1,b1]=butter(2,0.14*2*1,'high');
Rplotf = abs(filtfilt(a1,b1,Rplot));

% smooth
windowSize = 5;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Rplotf = normalizeMy(filter(b,a,Rplotf));

lim = mean(Rplotf)+3*std(Rplotf);
F = find(Rplotf>lim);

MatrixDetection(stationN,:) = Rplotf;
stalon(stationN) = lon(stationN);
clear Rplot  Rplotf F
end

[stalon,ix] = sort(stalon);
subplot(3,1,[1 2])
imagesc(timeplot,stalon,MatrixDetection)
datetick('x')
subplot(313)
stairs(timeplot,mean(MatrixDetection))
datetick('x')
hold on
plot(timeplot,ones(size(timeplot)).*(mean(mean(MatrixDetection))+3*std(mean(MatrixDetection))),'-r')

F = find(mean(MatrixDetection)>(mean(mean(MatrixDetection))+3*std(mean(MatrixDetection))));
datestr(timeplot(F))