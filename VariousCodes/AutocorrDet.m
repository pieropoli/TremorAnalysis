clear
clc
close

load sigcorr

ref = sigcorr(1.0679e+04:1.0877e+04);

cc = zeros(1,length(sigcorr) - length(ref) - 1);
for i1 = 1 : length(sigcorr) - length(ref) - 1
    
    
   tmp = sigcorr(i1:i1+length(ref)-1); 
    
    cc(i1) = corrc_norm(tmp, ref);
    
    
end

F = find(cc>0.45);

F(F>1.0679e+04-1000&F<1.0679e+04+1000)=[];



plot(normalizeMy(ref'),'r')

for i1 = 1 : length(F)
   hold on
   
   plot(i1+1+normalizeMy(sigcorr(F(i1):F(i1)+length(ref))')) 
    
    
    
end