clear
clc
addpath /Users/pieropoli/NoiseBrasil2016/gismotools-read-only/GISMO
startup_GISMO
addpath /Users/pieropoli/NoiseBrasil2016/matlab

inputdirectory = 'test';




%outputdirectory = ['/Volumes/BUCA4/BrazilCorrelation2016/stackCorrelationALL_' num2str(fmin(i5)) '-' num2str(fmax(i5)) '_window' num2str(windowMin(i3)) 'min_Nstd' num2str(Nstd(i4))];


dirdata = dir(inputdirectory);
dirdata(1:2) = [];


for i1 = 2 : length(dirdata)
    
    dirlevel2 = dir([char(inputdirectory) '/' char(dirdata(i1).name) ]);
    dirlevel2(1:2) = [];
    
    for i2 = 1 %: length(dirlevel2)
        load([char(inputdirectory) '/' char(dirdata(i1).name) '/' char(dirlevel2(i2).name)])
        
        
        
        c = get(C,'C1');
        c = mean(c);
        
        d = distance(get(C,'wala'),get(C,'walo'),get(C,'wbla'),get(C,'wblo'));
        
        
        hold on
        plot(d+normalizeMy((c))./10)
        
    end
    
    
end

