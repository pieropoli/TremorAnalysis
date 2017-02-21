clear
clc
close



% load data

datadir = '~/MatData/TriggerTohhoku4/';
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
    for i1 = 1 : length(data.slat)
        dist = distance(data.slat(i1),data.slon(i1),data.slat,data.slon);
        [~,ix] = sort(dist);

            
            tmp = filtfilt(a1,b1,data.data(i1,:));
            
            norm = sort(abs(tmp),'descend');norm=mean(norm(1:3));
            
            hold on
            
            
            plot(tp,i1+tmp./norm,'k');

        
        xlim([0 max(tp)])
        title(data.staname{i1})

    end
    

    pause
 %   eval(['print -depsc ' outdir '/env_' data.nameevent])
    close
end