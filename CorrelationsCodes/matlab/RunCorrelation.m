function RunCorrelation(InputDirectory,outputDirectory,dataname,fmin,fmax,btord,windowMin,overlapPercent)
warning off
% low-cutt of filter (Hz)
% high-cut of filter (Hz)
% number of poles in Butterworth filter
% can be 'taper' or 'median'
% Wn = 1000;
% window length (min)
% window overlap used to calculate the corr.

% add these folders to your MATLAB path so MATLAB knows to look for
% the codes here.


%% create directory

if exist(outputDirectory,'dir');
    fprintf('Output directory already exists\n');
else
    mkdir(outputDirectory)
end


if exist([char(InputDirectory) '/' dataname],'file')==2
    load([char(InputDirectory) '/' dataname]);
    %disp(['Run correlation for:' char(InputDirectory) '/julDay_' int2str(JulDay) '.mat']);
    
    % These data come into MATLAB as WAVEFORM objects. This way they
    % contain all the META-information we need. If you have not done so
    % already, go to this website and check out this code with svn:
    % https://code.google.com/p/gismotools/source/checkout
    % SVN is like GITHUB, but the old version. If you do not want to use
    % SVN, you can simply download this toolbox and add it to your MATLAB
    % path, after you save it somewhere on your machine. All of the codes
    % are buuilt on this WAVEFORM object. Plus this toolbox offers some
    % useful plotting and processing tools for passive seismic data.
    
    %% setup the correlation output structure
    
    % make directory for output of the correlations
    %[success,message,messageID] = checkOutputDir(outputDirectory);
    
    %% plot to see raw data
    
    
    %% remove any blank traces
    
    blankIdx    = ( sum(double(W),1) == 0 ); % find blank traces
    W(blankIdx) = []; % remove blank traces
    
    %% index of zeros
    zerosIdx    = ( (double(W)) == 0 );

    %% frequency filter data
    
    Filt   = filterobject('B',[fmin,fmax],btord); % create a frequency filter for waveform
    W = filtfilt(Filt,W); % apply the filter to the data
    
    %% from here start dylan's fucntion
    %
    % This function computes crosscorrelations of all traces in a waveform
    % object for the given time window size (winLength). The windows will
    % overlap based on overlapPercent. The correlations are linearly
    % stacked over the day-long waveform traces. More complex stacking
    % strategies can be applied to the day-long correlations later.
    %
    % USAGE: Wout = runCorrelations(W,winLength,overlapPercent)
    %
    % INPUT:
    %   W              = input waveform object, assuming 1 day length
    %   winLength      = window length in seconds
    %   overlapPercent = percent that the windows overlap
    % OUTPUT:
    %   C = a waveform objection containing all of the stacked
    %   correlations with relevant META-data.
    %
    % Written by Dylan Mikesell (mikesell@mit.edu)
    % Last modified 8 June 2014
    
    % set up windowing parameters
    Fs          = get(W(1),'FREQ');
    npts        = 86400*Fs;
    nSampWin    = windowMin * Fs*60; % number of sample in the window
    nSlideWin   = floor(nSampWin*overlapPercent); % number of samples to move from window to nex
    windowStart = 1 : nSlideWin : npts ; % starting index of windows
    nWindows    = numel(windowStart) - 1; % number of windows

%% main loop

    
    % this are the raw data

    data = double(W);
    % one bit
    data= sign(data);
    
    
    for jj = 1 : size(data,2)
        for yy = jj+1 : size(data,2)
            C = waveform(); % blank waveform object to store new correlations
            
            % preallocate c1 c2 and c3
            C1 = zeros(nWindows,nSampWin*2-1);
            
            % this is the loop over the windows for a given couple of
            % stations
            
            for tt = 1 : nWindows
                
                
               % if WindTest(tt)==1 % check there are no eqs
                    % check zero samples
                    winSampIdx = windowStart(tt) : windowStart(tt) + nSampWin - 1; % smaple indices for this window
                    
                    zeroIdxA = (zerosIdx(winSampIdx,jj));
                    zeroIdxB = (zerosIdx(winSampIdx,yy));
                    if sum(zeroIdxA) < nSampWin*0.85 && sum(zeroIdxB) < nSampWin*0.85
                        c = xcorr(data(winSampIdx,jj),data(winSampIdx,yy),'coeff');
                        
                        %[c1,c2,c3] = normalizedCorrelation(data(winSampIdx,jj), data(winSampIdx,yy), Fs, smoothMethod, Wn, K);
                        if isnan(sum(c))==0
                            C1(tt,:)=c;
                            %C2(tt,:)=c2;
                            %C3(tt,:)=c3;
                        end
                    else
                        disp('too many zeros')
                    end
                    
                %end
            end
            
            % now average the correlations
            FF = find(sum(C1,2)==0);
            
            if length(FF)<size(C1,1) % check there are data left
                
                winstartsave = windowStart;
                % remove zero traces
                C1(FF,:)=[];
                winstartsave(FF)=[];
                clear FF
                                
                % get the information about the data used for this
                % correlation pairs
                
                % set the basic WAVEFORM properties
                C = set(C, 'FREQ', Fs);
                C = set(C, 'Data_Length', numel(winSampIdx));
                C = set(C, 'Station', [get(W(jj),'Station') '-' get(W(yy),'Station')]);
                C = set(C, 'Channel', [get(W(jj),'Channel') '-' get(W(yy),'Channel')]);
                C = set(C, 'Start', get(W(yy),'Start') + datenum(0,0,0,0,0,(windowStart(tt)-1)/Fs));
                C = set(C, 'Network', [get(W(yy),'Network') '-' get(W(jj),'Network')]);
                
                % add station location information
                C = addfield(C, 'windowT0', winstartsave);clear winstartsave
                C = addfield(C, 'WALA', get(W(yy),'STLA'));
                C = addfield(C, 'WALO', get(W(yy),'STLO'));
                C = addfield(C, 'WAEL', get(W(yy),'STEL'));
                C = addfield(C, 'WBLA', get(W(jj),'STLA'));
                C = addfield(C, 'WBLO', get(W(jj),'STLO'));
                C = addfield(C, 'WBEL', get(W(jj),'STEL'));
                C = addfield(C, 'FBmin', fmin);
                C = addfield(C, 'FBmax', fmax);
                % add correlation information
                C = addfield(C, 'c1', C1);clear C1
                
                if exist('C','var')==1
                    station   = get(C,'station'); % get station pair
                    mkdir([char(outputDirectory) '/' char(station)])
                    name = ['corr_' dataname];
                    save([outputDirectory '/' station '/' dataname],'C');
                    disp(['save ' name])
                    %eval(['save  ' char(outputDirectory) '/' char(station) '/corr_Day' num2str(JulDay) '_' char(station) '.mat C']);
                    %disp(['save  ' char(outputDirectory) '/' char(station) '/corr_Day' num2str(JulDay) '_' char(station) '.mat C']);
                    
                    clear C
                end
                
            else
                disp('no data left, no saved correlation')
            end
        end
        
    end
    
else
    disp([char(InputDirectory) '/julDay_' int2str(JulDay) '.mat not existing'])
    
end
