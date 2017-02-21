function [c1] = c1_normalizedCorrelation(s1, s2)
%
% This function computes crosscorrelation of s1 and s2. The returned
% data each have a different normalization applied. The computations
% use 3 different approaches. See Bendat & Piersol 2000
%
% USAGE: [c1,c2,c3] = normalizedCorrelation(s1, s2, Fs, SmoothMethod, Wn, K)
%
% INPUT:
%   s1 = first trace (i.e., the virtual source)
%   s2 = second trace
%   Fs = sample frequency (Hz)
%   smoothMethod = 'taper' or 'median'
%   Wn = for 'taper' method, Wn=first 2*Wn discrete prolate spheroidal
%   sequences; for 'median' method, Wn=Wn order in medfilt1.m
%   K = the K most band-limited discrete prolate spheroidal sequences
%   when using the 'taper' mehtod. Default is K=2*Wn-1
%
% 1) array normalization (Transfer function) using estimated spectra based on array observation
% 2) station normalization (Transfer function) spectrum must be smoothed
% 3) simple normalization (Coherence)
% 4) Autocorr energy normalization
%
% INPUT PARAMETERS:
%
% s1 and s2 : traces to be treated
% Wn: time bandwidth product
%
% OUTPUT:
%
% c1: Autocorr energy normalized correlation: C12(t)/(C11(0)C22(0))
% c2: simple normalization (Coherence) C12(w)/({abs(S1(w))}{abs(S2(w))})
% c3: Transfer function station normalization C12(w)/({abs(S1(w))^2})
% c4: Transfer function array normalization C12(w)/({abs(Sarray(w))^2})
%
%
% CREATED BY Piero Poli Massachussets Institute of Technology
% V.1.1 - 18 Sept 2013
% Modified by Dylan Mikesell (mikesell@mit.edu)
% Last modified 2 June 2014

% UPDATE: Piero Poli Oct 20 2014, the median filter function is now
% completely defined inside the function, without calling the medfilt1
% fucntion in matlab, this should speedup the correlaiton


% general formulation

npts = numel(s1);
taper = tukeywin(npts,0.1); % taper 5% on each side of trace 
s1 = s1.*taper; 
s1 = transpose(s1);
s2 = s2.*taper;
s2 = transpose(s2);

nfft = 2*npts - 1; % get the final correlation length

% Do the FFT once up front for each trace
s1FFT = fft(s1, nfft);
s2FFT = fft(s2, nfft);

%---------------------------------------------------------------------
% c1: Autocorr energy normalized correlation: C12(t)/(C11(0)C22(0))
%---------------------------------------------------------------------

SpectralDomainCorr = s1FFT.*conj(s2FFT); % correlation in frequency domain

% 1) get the normalized correlation as in Bendat Piersol pp. 125 eq. 5.16
sigma1 = fftshift( ifft( s1FFT.*conj(s1FFT) ) ); % autocorr s1
sigma2 = fftshift( ifft( s2FFT.*conj(s2FFT) ) ); % autocorr s2

norm1=sigma1( (length(sigma1) + 1) / 2 ).*ones(1, nfft); % get t=0 enrgy for autocorr s1
norm2=sigma1( (length(sigma2) + 1) / 2 ).*ones(1, nfft); % get t=0 enrgy for autocorr s2

c1 = fftshift( ifft(SpectralDomainCorr) )./( sqrt(norm1).*sqrt(norm2) ); % normalize
