%close all; clear all; clc
% This script automatically creates SOFA files containing sound radiation
% directivity data for instruments specified in the spreadsheet
% 'Anechoic Microphone Array Measurements of Musical Instruments_Documentation 
% of the Musical Instruments.docx'. 32 channel measurements as .wav files are
% the basis of the export.

% Dependent methods:
% - SOFA_FreeFieldDirectivityTF_RawData_singleTone.m
% - AKmidiConversion.m
% - detect_tone.m
% - import_spreadsheet.m

%%%%%%%%%% INPUT DECK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SOFA] = SOFA_Recording_export_main_1(p,s,pitch)
%% Set paths and import data
    addpath(genpath('functions/'));
    addpath(genpath('inputData/'));
    addpath(genpath('ThirdParty/'));


%general meta data to involve in SOFA file
    general.title                       = 'Directivity measurement: ';
    general.authorcontact               = 'l.campanella@tu-berlin.de';
    general.organization                = 'TU Berlin - Audio Communication Group';
    general.license                     = 'cc by-nc-sa 4.0';
    general.applicationname             = 'Matlab';
    general.applicationversion          = version;
    general.comment                     = 'Contains single sided complex TFs for 58 directions @fs = 44100 Hz';
    general.history                     = 'Originally recorded data';
    general.references                  = 'dx.doi.org/10.14279/depositonce-5861.2';
    general.origin                      = 'Acoustic recordings of single notes played in the anechoic chamber of the Technical Universtiy of Berlin';
    general.databasename                = 'A Database of Anechoic Microphone Array Measurements of Musical Instruments';

    general.compression                 = 0;
    general.mic_array_radius            = [0.1;6.3]; %[m]


%%%%%%%%%%%% END OF INPUT DECK
%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start Sofa
    SOFAstart
    SOFAcompileConventions

%% loop instruments
    for idx = 1:pitch.amount 
   %noteName = pitch.all(pitch.start+idx);
        p.to_wav = [p.to_input, '/wav_files/', convertStringsToChars(s.meta_data.GLOBAL_EmitterShortName)];
        s.idx = idx;
    % get filenames of all tones of the given instrument in 'et' play modi
        s.dynamic = dir(fullfile(p.to_wav));
    % remove '.' and '..' 
        s.dynamic = s.dynamic(~ismember({s.dynamic(:).name},{'.','..','.DS_Store','outputData'}));
        

    % keep only 'et' and delete the remaining data
        delet = fullfile(strcat(p.to_wav,'/',{s.dynamic(~contains({s.dynamic(:).name},{'.DS_Store'})).name}));

    % folder for output data
    % mkdir outputData SOFA_files   
        
         disp(['Raw SOFA export started for: ', s.dynamic(idx).name])
         p.to_record = [p.to_input,'/wav_files/',convertStringsToChars(s.meta_data.GLOBAL_EmitterShortName),'/', s.dynamic(idx).name];
         s.data = dir(fullfile(p.to_record)); 
        %p.to_record = [p.to_input,'/wav_files/',convertStringsToChars(s.meta_data.GLOBAL_EmitterShortName)];
        
        % loop over the tones and write to SOFA file for dynamic modi     
         
          obj = SOFAgetConventions('FreeFieldDirectivityTF','m');
  
          writeSOFARecordings(p, s.dynamic(idx), s.meta_data, general, obj);  
   
        
%         % delete input data
%         if exist(strcat(p.to_input, '\1_Recordings\', s.meta_data{idx,2}), 'dir')
%             rmdir(strcat(p.to_input, '\1_Recordings\', s.meta_data{idx,2}), 's')
%         end

    end 
end


