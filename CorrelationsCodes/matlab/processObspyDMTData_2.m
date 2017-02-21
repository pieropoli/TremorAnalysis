clear all
close all
clc

addpath /Users/pieropoli/GISMO_r362/GISMO
startup_GISMO
addpath /Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/matlab
% Last modified 6 May 2014
% Dylan Mikesell (mikesell@mit.edu)
% Piero adde decimate and stretch resampling [Feb 2017]
%--------------------------------------------------------------------------
% User Input

channel = 'BH*';
datatype = 'BH_VEL';
julDayDir = ('/Volumes/MIT_01/MAT/ChileTJ_3c'); % directory for writing julian day data
resampleFrequency = 25; % (Hz)
jday       = 1;
dateFolder = '/Volumes/MIT_01/DataPiero/ChileTJoneday/2007-01-05_2007-01-06'; % all folders have this date so hard coded for now

%% CODE
tmp_ii = pwd;
mkdir(julDayDir)
for jj = jday % loop through julian days
    fprintf('Checking Julian day: %d\n',jj);
    cd([char(dateFolder) '/continuous' sprintf('%02d',jj) ]);
    if exist(datatype,'dir') % process deconvoled data
        cd(datatype);
        sacFile = dir(['*' channel]); % list of displacement waveforms
        
        % Load each sac file and process
        for kk = 1 :numel(sacFile);
            
            
            Wadd = loadsacfile({sacFile(kk).name});
            % check data length; no point if less than 1 hour of data
            [year,month,day,hour,min,sec] = datevec(get(Wadd,'Duration'));
            if 24*day + hour + min/60 + sec/3600 > 1
                % add this waveform to existing julian day Structure or
                % create a new structure
                W = addJulDayWaveform(Wadd,julDayDir,jj,resampleFrequency);
                
            else
                fprintf('Waveform has less than 1 hour of data. Skipping station %s\n',get(Wadd,'station'));
            end
 
        end
        
    else % no data on this julian day in this longitude range
        fprintf('No waveform data in %s\n',['continuous' sprintf('%02d',jj) ]);
    end
    cd(tmp_ii); % go backward
    % go to next ['continuous' num2str(jj)]
end
