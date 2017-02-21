clear
clc
close



% load data

datadir = '~/MatData/TriggerTohhoku3/';
d=dir(datadir);
d(1:2)=[];
outdir ='envelopesquakes';
mkdir(outdir)


X = 5 :1: 21;
Y = 34 :1: 47;

win=3000;
NSTA=3;
wind=100;



for id = 1 %: length(d)
    load([datadir '/' d(id).name])
    
    FB = [5 20];
    [a1,b1]=butter(2,FB*2*data.tau);
    [a2,b2]=butter(2,.1*2*data.tau,'low');
    
    
    tp = 0:data.tau:(length(data.data)-1)*data.tau;
    
    
    
    for ix = 1 : length(X) -1
        for iy = 1 : length(Y) -1
            
            F = find(data.slat>Y(iy)&data.slat<Y(iy+1)&data.slon>X(ix)&data.slon<X(ix+1));
            length(F)
            if length(F)>NSTA
                
                %% prepare data
                dataplot = data.data(F,:);
                latplot = data.slat(F);
                lonplot = data.slon(F);
                dist = data.evdist(F);
                
                subplot(224)
                plot(mean(lonplot),mean(latplot),'o')
                
                [tts1,~] = TravelTimeTaupPhasesDistance(max(dist),'tts+',data.evdep,'prem');
                [ttp1,~] = TravelTimeTaupPhasesDistance(max(dist),'ttp+',data.evdep,'prem');
                t1 = round(tts1(1)-ttp1(1)+data.winbeforephase);
                t2 = round((t1 + win+data.winbeforephase));
                
                for ik = 1 : size(dataplot,1)
                    
                    tmp = (filtfilt(a1,b1,(dataplot(ik,:))).^2);
                    tmp = filtfilt(a2,b2,tmp);
                    tmp = resample(tmp,1,1/data.tau);
                    tmp=real(sqrt(tmp));
                    tmp = detrend(tmp(t1:t2));
                    tmp=tmp.*tukeywin(length(tmp),.1)';
                    norm = sort(tmp,'descend');norm = mean(norm(1:50));
                    tmp=tmp./norm;
                    
                    dataanalysis(ik,:) = tmp;
                    datatoplot(ik,:) = (filtfilt(a1,b1,(dataplot(ik,round(t1/data.tau):round(t2/data.tau)))));
                    clear tmp;
                    
                    
                end
                
                %% make correlation
                
                T = 1 : wind/2 : length(dataanalysis)-wind*2;
                
                for it = 1 : length(T)
                    tmpcorr = dataanalysis(:,T(it):T(it)+wind);
                    tmpplot = datatoplot(:,round(T(it)/data.tau):round((T(it)+wind)/data.tau));
                    cnt=1;
                    [DataAlign,corrCoeff,delay,IDD] = MccAlignment2(tmpcorr);
                    C = median(corrCoeff);
                    delay = mean(delay,1);
  
                    
                    
                    
                    
                    F = find(C>0.6);
                    tp = 0:data.tau:(length(tmpplot)-1)*data.tau;
                    if length(F)>3
                        dt = round(delay(F)/data.tau);
                        dataplot=DataAlign(F,:);
                        dataraplot = tmpplot(F,:);
                        for iplo = 1 : size(dataplot)
                            subplot(221)
                            hold on
                            plot(normalizeMy(dataplot(iplo,:))+iplo)
                            xlim([0 wind])
                            subplot(223)
                            hold on
                            out=delayTrace(dataraplot(iplo,:),dt(iplo));
                            plot(tp,normalizeMy(out)+iplo);
                            xlim([0 wind])
                            
                            
                        end
                        subplot(222)
                            plot(mean(normalizeMy(dataplot)))
                        
                        pause
                        close
                        
                    end
                    clear delay cstore  diststa tmpcorr  idc datasave idww datasaveplot idsav
                    
                end
                
                
                
            end
            
            
            clear dataplot latplot lonplot dist dataanalysis datatoplot
        end
    end
    
end