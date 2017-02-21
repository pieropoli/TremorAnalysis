clear
clc
close
addpath /Users/pieropoli/GISMO_r362/GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/SourceScanning/mat
startup_GISMO
addpath /Users/pieropoli/Seismic_Matlab_Functions

julDayDir = ('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/chile'); % directory for writing julian day data

inputDirectory= '/Users/pieropoli/Data/ZWtry/2005-06-25_2005-06-26/'; % this is the directory in which you have the data

%% parse the catalog to retrieve the events
%mkdir(outDirectory);
fid1 = fopen(char([char(inputDirectory) '/EVENTS-INFO/catalog_table.txt']),'r');
[attributes]=textscan(fid1,'%f %f %f %f %s %f %s %s %s','headerlines',5);
fclose(fid1);

resampleFrequency = 50; % (Hz)
nameEvents=attributes(8);
eventTime=attributes(5);

tmp_ii = pwd;
mkdir(julDayDir)

for i1 = 1 : size(eventTime{1},1)
    
    
    cd([char(inputDirectory) '/' nameEvents{1}{i1} '/BH_VEL']);
    
    sacFile = dir('*HZ'); % list of displacement waveforms
    
    tev = char(eventTime{1,1}(i1));
    dateev=obspyTimeToMat(tev);
    dateevend=dateev;
    dateevend(4)=23;dateevend(5)=59;dateevend(6)=59;
    
    % Load each sac file and process
    for kk = 1:numel(sacFile);
        Wadd = loadsacfile({sacFile(kk).name});
        Wadd = align(Wadd,datestr(dateev,'mm/dd/yyyy HH:MM:SS.FFF'),get(Wadd,'freq'));
        
        [year,month,day,hour,min,sec] = datevec(get(Wadd,'Duration'));
        if 24*day + hour + min/60 + sec/3600 > 1
            Wadd  = fillgaps(Wadd,0); % fill data gaps with zeros
            % add this waveform to existing julian day Structure or
            % create a new structure
            trace = zeros(floor(86400*get(Wadd,'Fs')),1);
            D = double(Wadd);
            isflip = 0;
            if size(D,2) > 1
                D      = transpose(D); % make column vector
                isflip = 1; % a flag to flip back
            end
            % checkt the beginning of the trace
            [startTimeAdd,endTimeAdd]     = gettimerange(Wadd); % MATLAB date index
            DTbeginning = etime(datevec(startTimeAdd),dateev);

            %% take care of the beginning of the trace
            nTapBeginning      = floor(DTbeginning*get(Wadd,'Fs'));
            if nTapBeginning > 0
              D    = padarray(D,nTapBeginning,0,'pre');  % data starts after midnight this day
                
            else
              D(1:abs(nTapBeginning)) = [];  % data starts before midnight this day
                
            end
            
            %% now end of the trace
            if length(D)<length(trace);
                trace(1:length(D))=D; % data starts before midnight day after
            else
                trace=D(1:length(trace)); % data starts after midnight day after
            end

            % Resample waveform
            Q    = round(get(Wadd,'Fs')/resampleFrequency); % resample factor
            
            trace   = resample(trace,1,Q); % resample the data
            if isflip % make correct shape
                trace = transpose(trace);
            end
            
            Wadd         = set(Wadd,'start',datenum(dateev)); % set new start time
            Wadd = set(Wadd,'data',trace,'Freq',resampleFrequency); % set header and data
            clear trace
            
            
            %--------------------------------------------------------------------------
            % Add this data to the julian day matrix
            julDay=datestr(get(Wadd,'start'));
            fname = [julDayDir '/data_' num2str(julDay) '.mat'];
            
            if exist(fname,'file')
                load(fname); % append new data in W
                wIdx = strcmp(get(W,'station'),get(Wadd,'station'));
                if sum(wIdx) == 0
                    fprintf('Adding new waveform from station %s\n',get(Wadd,'station'));
                    W(numel(W)+1) = Wadd;
                else
                    fprintf('Station %s already in matrix\n',get(Wadd,'station'));
                    fprintf('Replacing waveform with current waveform\n');
                    W(wIdx) = Wadd;
                end
            else
                fprintf('Adding new waveform from station %s\n',get(Wadd,'station'));
                W = Wadd; % make new waveform for output
            end
            %--------------------------------------------------------------------------
            % write matrix
            save(fname,'-v7.3','W');

        else
            fprintf('Waveform has less than 1 hour of data. Skipping station %s\n',get(Wadd,'station'));
        end
        
        
        
        
        
    end
    cd(tmp_ii); % go backward
end