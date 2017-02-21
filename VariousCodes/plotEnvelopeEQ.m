clear
clc
close



% load data

datadir = '~/MatData/TriggerTohhoku3/';
d=dir(datadir);
d(1:2)=[];
outdir ='envelopesquakes';
mkdir(outdir)

for id = 1 : length(d)
    load([datadir '/' d(id).name])
    
    FB = [5 25];
    [a1,b1]=butter(2,FB*2*data.tau);
    [a2,b2]=butter(2,.1*2*data.tau,'low');
    
    
    tp = 0:data.tau:(length(data.data)-1)*data.tau;
    % protcessing
    for i1 =70 : length(data.slat)
        dist = distance(data.slat(i1),data.slon(i1),data.slat,data.slon);
        [~,ix] = sort(dist);
        
        for ipl = 1 : 4
            [s,f,t]= spectrogram(data.data(ix(ipl),:),hanning(256),round(256*0.75),256,1/data.tau);
            subplot(5,1,5-ipl)
            imagesc(t,f,log10(abs(s)))
            xlim([0 max(tp)])
            ylim([0 1/data.tau/2])
            
            subplot(5,1,5)
            plot(tp,-1+normalizeMy((data.data(i1,:))).*4,'r')
            
            tmp = filtfilt(a1,b1,data.data(ix(ipl),:));
            
            norm = sort(abs(tmp),'descend');norm=mean(norm(1:3));
            
            hold on
            
            
            plot(tp,ipl+tmp./norm,'k');
            
        end
        
        xlim([0 max(tp)])
        title(data.staname{i1})
        pause
        close
    end
    
    
    
    %
    %     [ttp1,s2] = TravelTimeTaupPhasesDistance(dd(1),'ttp+',data.evdep,'prem');
    %     [tts1,s2] = TravelTimeTaupPhasesDistance(dd(1),'tts+',data.evdep,'prem');
    %     hold on
    %     plot((ttp1-ttp1(1)+data.winbeforephase)./data.tau,ones(size(ttp1)).*i1+1,'gs')
    %     plot((tts1-ttp1(1)+data.winbeforephase)./data.tau,ones(size(tts1)).*i1+1,'gs')
    pause
    eval(['print -depsc ' outdir '/env_' data.nameevent])
    close
end