clear
clc
close

n = 1;
%% load file
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/DataNavidad/data_01-Jan-2016.mat')
data = get(W(n),'data');

%% spec parameters
FB = [0.02 0.05];
FB1 = [1 9];
% The relevance of high-frequency analysis artifacts to remote triggering
% Z Peng, LT Long, P Zhao - Seismological Research Letters, 2011 - srl.geoscienceworld.org


%  spectrograms with the following parameters: specgram(a,n
% fft,fs,window,noverlap), where a is the data, nfft is the number
% of points used to calculate the discrete fast Fourier transform
% (FFT), fs is the sampling rate, window is a periodic Hanning
% window, and noverlap is the number of samples by which two
% consecutive sections overlap. In this study, we use nfft = 256,
% window = nfft, and noverlap = window x 0.75 = 192. For the
% sampling rate fs =100/s, the window length is 2.56 s. These
% parameters are either the default or typical values used in computing
% the spectrogram. We have set those parameters to different
% values (nfft from 64 to 512, and noverlap from 50 to 250),
% and the results are generally similar to those shown below. We
% also use another MATLAB command spectrogram(a, window,
% noverlap, nfft, fs) with the same values. The main difference
% is that the ?specgram? command uses the Hanning window, 

nfft = 256;
noverlap = 0.75*nfft;
fs = get(W(n),'Fs');

t = 0 : 1/fs : (length(data)-1)/fs;
t = t./3600;

[a1,b1]=butter(2,FB*2/fs);
datafilt = filtfilt(a1,b1,data).*tukeywin(length(data),.1);

[a2,b2]=butter(2,FB1*2/fs);

datafilt1 = filtfilt(a2,b2,data).*tukeywin(length(data),.1);

figure(1)
subplot(311)
hold all
plot(t,datafilt1./max(abs(datafilt1)),'r')
plot(t,datafilt./max(abs(datafilt)),'b')

xlim([0 24])
%% spectrogram
[s,f,t] =spectrogram(data,hamming(nfft),noverlap,[],fs);
t = t./3600;

%[s,f,t] = spectrogram(x,window,noverlap,f,fs)

figure(1)
subplot(3,1,[2 3])
imagesc(t,f,log10(abs(s)))
ylim([0 fs/2])
xlim([0 24])