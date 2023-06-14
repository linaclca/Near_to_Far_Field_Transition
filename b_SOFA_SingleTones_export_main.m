close all; clear all; clc
% This script automatically exports the tone specific directivity data as
% Tensor data for the instruments given in the 'Anechoic Microphone Array 
% Measurements of Musical Instruments SOFA-files created in 
% a_Reading_H5_Sep_Stat_to_SOFA_Main.m. The data basis is a SOFA file 
% containing the Raw measurements of 58 channels as transfer functions. 
% Please set the respective paths in the input deck.

% Dependencies:

%%%%%%%%%% INPUT DECK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set paths and import data
addpath(genpath('toolbox'))
addpath(genpath('outputData'))

p.to_output                         = './outputData';
p.to_controlPlots                   = [p.to_output,'/0_ControlPlots'];
p.to_recordings                     = [p.to_output,'/1_Recordings'];
p.to_singleTones                    = [p.to_output,'/2_DirectivitySingleTones'];

%% set conversion preferences
%show and save plots
d.verbose   = true;

%compression
general.compression = 1;

%amount of channels (microphones)
ch = 58;

% choose Instrument (in numbers)
prompt = "Choose instrument 1 to 26 from InstrumentsOvervie.txt: ";
instrument = input(prompt); %VARIABLE, choose from InstrumentOverview.txt

% get MetaData for the chosen instrument
s.meta_data = getMetadata(instrument); 


%%%%%%%%%%%% END OF INPUT DECK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for input data
p.to_recordings = [p.to_recordings,'/',s.meta_data.GLOBAL_EmitterShortName];
s.dir = dir(fullfile(p.to_recordings ));

% remove '.' and '..' 
s.dir = s.dir(~ismember({s.dir(:).name},{'.','..'}));

if size(s.dir,1) == 0
    disp(strcat(['No input data found, execution stopped']))
    return 
end

%% Get the data from the SOFA-file
 idx = 1; 
 s.dynamic = dir(fullfile(p.to_recordings,s.dir(idx).name));
 % remove '.' and '..' 
 s.dynamic = s.dynamic(~ismember({s.dynamic(:).name},{'.','..'}));

 % check for input data
 p.to_recordingsData = fullfile(p.to_recordings);
 if ~size(dir(fullfile(p.to_recordingsData,'*.sofa')),1)
    disp(strcat('No Data found for: ',s.meta_data.GLOBAL_EmitterShortName))
 end

 % get filenames of all tones of the given instrument
 disp(strcat('Tensor SOFA export started for: ',s.dir(idx).name))
 s.data = dir(fullfile(p.to_recordingsData,'*.sofa'));

 p.filename = s.data(1).name(21:end-19);

   
 %% generate the tensor data/ detect harmonic
 %loop notes
 for idx_ton = 1 : size(s.data,1)
     % load SOFA data 
     obj = SOFAload(fullfile(s.data(idx_ton).folder, s.data(idx_ton).name));
      % get frequency and tensor data from SOFA file 
     [Ps, f] = createTensorData(obj,s.meta_data, d);

      % write Sofa file
      obj = writeSOFASingleTones(p , s.meta_data,Ps , f, obj, general);

      %create folder
      p.to_SOFA = fullfile(p.to_singleTones,s.meta_data.GLOBAL_EmitterShortName);
      if ~exist(p.to_SOFA, 'dir')
          mkdir(p.to_SOFA) 
      end
        
      % save SOFA-file with TensorData
      str = strrep(s.data(idx_ton).name, '_recording', '_singleTones');
      p.to_SOFAName = fullfile(p.to_SOFA, str);
      disp(['Saving:  ' p.to_SOFAName]);
      SOFAsave(p.to_SOFAName, obj, general.compression);


      % save plot
      if d.verbose
          p.to_print = fullfile(p.to_controlPlots,s.meta_data.GLOBAL_EmitterShortName); 
          if ~exist(p.to_print, 'dir')
              mkdir(p.to_print)
          end

          filename = [strrep(s.meta_data.GLOBAL_EmitterShortName,' ', '_'),'_',num2str(obj.MIDINote),'.png'];
          print(gcf, '-dpng','-loose', '-r300', fullfile(p.to_print,filename));     
      end
  end % end of notes loop
display("Tensor export finished.")

close all;
