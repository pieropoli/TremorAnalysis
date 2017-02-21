clear
clc
close

dir = 'CorrFB0.02-0.05';
out = loaddatafromdir(dir);

day = 5;
h = 2;

for i1 = 1 : length(out)
   load([dir '/' out(i1).name '/julDay_' num2str(day) '.mat']); 
    
   c = get(C,'C1'); 
   c = mean(c);
   
   d = distance(get(C,'wala'),get(C,'walo'),get(C,'wbla'),get(C,'wblo'));
   if deg2km(d)<100
    
    hold on
    plot(d+normalizeMy((c))./50)
   end
end