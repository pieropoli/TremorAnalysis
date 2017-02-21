clear
clc
close
n = 1;

T0 = 4;
to = 3600;
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed/julDay_5.mat')

Filt   = filterobject('B',[0.01,0.1],3); % create a frequency filter for waveform
W1 = filtfilt(Filt,W); % apply the filter to the data
data = double(W1);
%data = data(T0*3600*25:T0*3600*25+to*25,:);

win = 250;
lag = 0.5;

T = 1000*25 : lag*25 : length(data)-win*25-1;
ctoto = eye(length(T),'single');

for ij = 1 : length(T)
    for ii = ij+1 : length(T)
        
        data1 = data(T(ij):T(ij)+win*25,:);
        data2 = data(T(ii):T(ii)+win*25,:);
        c = zeros(1,size(data1,2));
        for is = 1 : size(data,2)
            c(is) = corrc_norm(data1(:,is),data2(:,is));
            
            
        end
        
        
        ctoto(ij,ii) = sum(c);
    end
end
ctoto = ctoto + ctoto' - eye(size(ctoto));


for ic = 1 : size(ctoto,2)
    
    [m(ic),iy(ic)] = max(ctoto(:,ic));
    
    
end

plot(m)
% 
% [M,ix] = max(m);
% ctoto(ix,iy(ix))
% M
% 
% for ij = 1458 
%     for ii = 1460
%         
%         data1 = data(T(ij):T(ij)+win*25,:);
%         data2 = data(T(ii):T(ii)+win*25,:);
%         
%         for is = 1 : size(data,2)
%             hold on
%             plot(is+normalizeMy(data1(:,is)'));
%             plot(is+normalizeMy(data2(:,is)'),'r');
%             
%         end
%         
%         
%     end
% end