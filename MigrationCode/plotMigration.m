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
    m(i1) = max(gridout(:));
    m2(i1) = min(gridout(:));
    
     gridout = (gridout - m2(i1))./(m(i1)-m2(i1));
    subplot(3,2,i1)
    pcolor(X,Y,gridout)
    colorbar
     shading flat

      [minM,idx] = max(gridout(:));
      [ix,iy] = ind2sub(size(gridout),idx)
       hold on
       plot(X(iy),Y(ix),'ok')
      
%          plot(lo,la,'ow')

     axis equal
%     caxis([0 30])
end


Rref = mean(m-m2);

Rtoto = 100.* ((m-m2)./Rref);