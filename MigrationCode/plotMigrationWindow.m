clear 
clc
close

d = 'MigrationsDaily';

out = loaddatafromdir(d);
dir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/DataProcessed';

pl = [1 2;3 4; 5 6; 7 8;9 10];
load('stacoord.mat')
for i1 = 1 : length(out)
    
    
    
    load([d '/' out(i1).name])
    
    for i2 = 1 : size(gridout,1)
    
       tmp  = squeeze(gridout(i2,:,:)); 
       m(i2) = max(tmp(:)); 
        
        
        
    end
    

end


