clear
clc


inputdirectory = '/Users/pieropoli/CorrelationTAserver/corrStack';
win=10;

dirlevel2 = dir([char(inputdirectory)]);
dirlevel2(1:2) = [];
cnt=1;
for i2 = 1 : length(dirlevel2)
    load([char(inputdirectory) '/' char(dirlevel2(i2).name)]);
    t = -0.5*(length(get(C,'c1'))-1)/get(C,'freq') : 1/get(C,'freq') : 0.5*(length(get(C,'c1'))-1)/get(C,'freq');

    if get(C,'distance') < 20
    Ctoto(cnt,:) =get(C,'c1');
    d(cnt) = get(C,'distance');
    %hold on
    %plot(t,get(C,'distance')+normalizeMy(fliplr(get(C,'c1')))./10,'k')    

    cnt = cnt+1;
    end
end


[d,ix] = sort(d);
Ctoto=Ctoto(ix,:);

%% make beam
F = find(t>=0);

causal = (Ctoto(:,F));

F = find(t<=0);
acausal = (fliplr(Ctoto(:,F)));

fold  = causal + acausal;
mutetime = 60;

Tc = t(t>=0);
F=find(Tc<=mutetime);

ds = deg2km(mean(d)-d);

fold(:,F)=0;

p=-.5:0.01:.5;
[mc] = inverse_radon_freq(fold',1/5,ds,p,1,0.1,0.3,0.1,'adj');

subplot(221)
imagesc(Tc,p,Hilbert_envelope(mc'))
[tP2,qP] = TravelTimeTaupPhasesDistance(0,'Pv410P',0);
hold on
plot(tP2,qP.p(1)/deg2km(1),'ok')

[tP2,qP] = TravelTimeTaupPhasesDistance(0,'Pv660P',0);
hold on
plot(tP2,qP.p(1)/deg2km(1),'ok')

xlim([0 300])

