clear
clc
close


t1 = 13*20*3600+1;
t2 = t1+1*3600*20-1;


%load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation1day/data_03-Jan-2013.mat')
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation1day_2/data_07-Jan-2013.mat')
%load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/ATFOneStation/data_03-Jan-2013.mat')


ref = 6;
% d = distance(get(W(6),'stla'),get(W(6),'stlo'),get(W,'stla'),get(W,'stlo'));
% [d,ix] = sort(d);



btord=3;
Filt   = filterobject('B',[2 8],btord); % create a frequency filter for waveform
W2 = double(filtfilt(Filt,W)); % apply the filter to the data


%W2 = W2(t1:t2,:);
windowSize = 100;
b = (1/windowSize)*ones(1,windowSize);
a = 1;

%W2 = W2(:,1:4);

%W2 = W2(:,ix);
t = 0:1/20:(length(W2)-1)*(1/20);
t = t./3600;
F = find(t>12.5&t<13.5);

for i1 = 1 : size(W2,2)
    
   hold on
   plot(i1+normalizeMy(((W2(:,i1)))').*0.7,'r')
%    hold on
%    plot(50046,i1,'or')
end


%% autocorr

data = W2(F,:);
template = data(850:950,:);

cc = zeros(3,length(data) - length(template) - 1);
for i1 = 1 : length(data) - length(template) - 1
    
    
   tmp = data(i1:i1+length(template)-1,:); 
    for ic = 1 : 3
    cc(ic,i1) = corrc_norm(tmp(:,ic), template(:,ic));
    end
    
end

cstack = sum(cc,1);

MAD = median(abs(median(cstack)-cstack));

plot(cstack)
hold on
plot(ones(size(cstack)).*MAD,'--r')
plot(ones(size(cstack)).*MAD.*5,'--k')
Fm = find(cstack>MAD*5);

for is = 1 : length(Fm)
    
    
   res(:,is) =  data(Fm(is):Fm(is)+length(template)-1,4);
    
    
    
end
