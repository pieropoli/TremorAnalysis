clear
clc
close

directory = '/Volumes/DataChile_2/MASE_20050320';
D = loaddatafromdir([directory '/*HN.sac']);



for i1 = 7:14%1 : 10%length(D)

   s = readsac([directory '/' D(i1).name]); 
   [a1,b1]=butter(2,[1 2]*2*s.tau);
   data =filtfilt(a1,b1,s.trace).^2;
   [a1,b1]=butter(2,.1*2*s.tau,'low');
   
   data=filtfilt(a1,b1,data);
   
   data=resample(data,1,100);
   hold on
   plot(normalizeMy(real(sqrt(data))')+s.slat)

end