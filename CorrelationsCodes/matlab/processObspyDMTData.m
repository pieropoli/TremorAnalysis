
function processObspyDMTData(jday)

addpath /net/hypocenter/home/ppoli/CorrelationNoiseTA/MITcorrelations/gismotools-read-only/GISMO
startup_GISMO
addpath /net/hypocenter/home/ppoli/CorrelationNoiseTA/MITcorrelations/matlab
addpath /net/hypocenter/home/ppoli/CorrelationNoiseTA/MITcorrelations/waveform_suite_r339/waveform_suite_r339

% This script creates day long matrices of all seismic data data in the
% directory USArray. The data is organized as such.

% -Longitude of stations in 2 deg increments; e.g.,
%   Data-146.0-144.0
% -Date Range (the same for all data); e.g.,
%   2006-01-01_2013-12-31_5.5_9.9
% -Julian day from start date; e.g.,
%   continuous101
%   This is the 101 day after 2006-01-01
%   In total there are 2921 days between the start and end date
% -Data information; e.g.,
%   A) BH_RAW/ file(s) (empty if no data); e.g., TA.BGNE..BHZ (a 24 SAC file)
%   B) Resp/ file(s) (empty if no data); e.g., STXML.TA.BGNE..BHZ (a response file)
%   C) info/ folder
%       1) exception file
%       2) quake file
%       3) report_st
%       4) station_event
%
% It seems to me that the easiest approach to this data is to write a
% Structure for each day that contains all waveforms, each with a header.
% (We could even use the waveform object from GISMO). Therefore, we will
% have 2921 binary MATLAB .mat files of various sizes depending on how many
% stations are live at that time. In this way, we can stick all data for
% the day into one file. We can then resample and align waveforms on the
% same start time. We can also pad at the beginning and end to fill in
% gaps.
%
% Then for each station-station pair, we can write a correlation Structure
% containing the correlations for that pair of stations. Then we can stack
% as we choose for all station pairs. The correlation structure would
% contain all of the different parameters form Piero's correlation
% routines.
%
% Last modified 6 May 2014
% Dylan Mikesell (mikesell@mit.edu)

%--------------------------------------------------------------------------
% User Input
lonDir    = ('/data/NoisePiero/'); % directory containing data subdivided by longitude
julDayDir = ('/data/TA_JulianDayData_2009/'); % directory for writing julian day data
resampleFrequency = 5; % (Hz)
%--------------------------------------------------------------------------
% Get longitude folder information
lonFolder      = dir([lonDir]);      % list of longitude folder
lonFolder(1:2) = [];               % get rid of '.' and '..' in dir() output
nFolder        = numel(lonFolder); % number of folders
%--------------------------------------------------------------------------
% Make output folder
if exist(julDayDir,'dir');
    fprintf('Output directory already exists\n');
else
    Success = mkdir(julDayDir);
    if Success
        fprintf('Created Output directory: %s\n',julDayDir);
    else
        error('MATLAB:processObspyDMTData:mkdir','Problem creating output data directory.');
    end
end
%--------------------------------------------------------------------------
%
% This code goes through each of the latitude folders and writes the data
% within each longitude range to a single julian day file
 % number of days between 2006/01/01 - 2013/12/31
dateFolder = '2009-01-01_2010-01-01_5.5_9.9'; % all folders have this date so hard coded for now


for ii = 1 : nFolder % loop through longitudes
    fprintf('Checking folder %s\n',lonFolder(ii).name);
    tmp_ii = [lonDir lonFolder(ii).name '/' ];
    cd(tmp_ii);

    for jj = jday % loop through julian days
        
        
        if jj<10
        check=exist([char(dateFolder) '/continuous00' num2str(jj)],'dir');
        elseif jj>10&&jj<100
        check=exist([char(dateFolder) '/continuous0' num2str(jj)],'dir');
        else    
        check=exist([char(dateFolder) '/continuous' num2str(jj)],'dir');  
        end  
        
        
        if check>0
        fprintf('Checking Julian day: %d\n',jj);
        
        if jj<10
        cd([char(dateFolder) '/continuous00' num2str(jj)]);
        elseif jj>10&&jj<100
        cd([char(dateFolder) '/continuous0' num2str(jj)]);
        else    
        cd([char(dateFolder) '/continuous' num2str(jj)]);  
        end    
        
        
        
        if exist('BH_VEL','dir') % process deconvoled data
            cd('BH_VEL');
            sacFile = dir('vel*'); % list of velocity waveforms
            
            % Load each sac file and process
            for kk = 1:numel(sacFile);
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
            fprintf('No waveform data in %s\n',['continuous' num2str(jj)]);
        end
        end
        cd(tmp_ii); % go backward
        % go to next ['continuous' num2str(jj)]
    end
end

