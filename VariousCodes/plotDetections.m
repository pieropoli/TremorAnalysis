clear
clc
close

datadir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/DetectionGRO';
d=dir(datadir);
d(1:2)=[];

for i1 = 1 : length(d) 
    load([datadir '/' d(i1).name]);
    tmp = sum(detectionMatrix,1);
    F = find(tmp>3);
    N(i1)=length(F);
    dayout(i1) = day;
    if i1 == 1
       Rtot = Rh; 
       Rtottot = Rhtoto;  
    else
        Rtot=cat(2,Rtot,Rh);
        Rtottot=cat(2,Rtottot,Rhtoto);
        
    end
end


detectionmatrix=zeros(size(Rtottot));
for is = 1 : size(Rtottot,1)
    Rtottot(is,:) = detrend(Rtottot(is,:));
 m=mean(abs(Rtottot(isnan(Rtottot(is,:))==0)));
 s=std(Rtottot(isnan(Rtottot(is,:))==0));   
    
 F = find(Rtottot(is,:)>(m+s*.9)) ;  
 detectionmatrix(is,F)=1;   
    (m+s*.9)
    
    
end


% stem(dayout,N)
% ylim([0 24])
% 
% 
% figure(2)
% stem(Rtot)
% m=mean(Rtot(isnan(Rtot)==0));
% s=std(Rtot(isnan(Rtot)==0));
% hold all
% plot([0 length(Rtot)],[m+s*.95 m+s*.95],'--r')