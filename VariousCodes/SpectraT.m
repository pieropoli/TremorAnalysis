clear
clc
close

load sig2
addpath /Users/pieropoli/Italy2016SeismicSequence/src_energy

[s2,freq] = mtspec(sig,1/20);
%[n2,freqn] = mtspec(sig,1/20);

% F = find(freqn>1&freqn<10);
% freqn=freqn(F);
% n2=n2(F);

F = find(freq>1&freq<10);
freq=freq(F);
s2=s2(F);

loglog(freq,s2),hold on
%loglog(freqn,n2,'r')
xlim([.1 15])