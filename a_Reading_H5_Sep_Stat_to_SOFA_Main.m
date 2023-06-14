% Matlab Script for Analysis of near- and far-field multi channel
% measurements  of musical instruments

% Bachelor Thesis in electrical engineering at TU Berlin
% by Lina Campanella, Matrikelnr 404711.
% for the Thesis with the title:
% "The transition from near field to far field of musical instruments"      
% submitted on June 24th 2023 
%------------------------------------------------------------------------------------------

% requires the AKtools toolbox of the Audio Communication Group of TU
% Berlin
%https://www.ak.tu-berlin.de/menue/publications/open_research_tools/aktools/

% requires the ltfat toolbox, available at http://ltfat.org/
%------------------------------------------------------------------------------------------


close all; clear; clc

tic
 
warning('off', 'MATLAB:MKDIR:DirectoryExists');

addpath(genpath('toolbox'))
ltfatstart  

clc 

%% h5 files ---------------------------------- 1a. load H5 recording 
s.fs = 51200; %[sample rate]
rec.h5path = '.\inputData\H5_rec_files\';
[rec, ch] = h5loader(rec);

% choose Instrument (in numbers)
prompt = "Choose instrument 1 to 26 from InstrumentsOvervie.txt: ";
instrument = input(prompt); %VARIABLE, choose from InstrumentOverview.txt

% get MetaData for the instrument
s.meta_data = getMetadata(instrument);

% set location for saved data
rec.switch.datapath = 'automatic'; %'manual' OR 'automatic'

data = datapathfinder(rec);

s.meta_data.ax_file = rec.tracename; % show chosen instrument file in workspace

% set pitch data
pitch.amount = s.meta_data.NotesPlayed;
pitch.all = ["E1","F1", "F#1", "G1", "G#1", "A1", "A#1", "B1", "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4", "C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5", "C6", "C#6", "D6", "D#6", "E6", "F6", "F#6", "G6", "G#6", "A6", "A#6", "B6", "C7", "C#7", "D7", "D#7", "E7", "F7", "F#7", "G7", "G#7", "A7"]; %Note names


%%
% Path to Input and Output folder
p.to_input                          = ['./inputData'];
p.to_output                         = ['./outputData'];
p.to_recordings                     = [p.to_output,'/1_Recordings'];

% save specific plots - true / false
data.saveplot.sep     = 'true';   % true / false     % Plot of entire recording
data.saveplot.stat    = 'true';   % true / false     % stationary signal 
data.saveplot.pitch   = 'true';   % true / false     % magnitudes and pitch detection

%% show seperated notes plot ----------------------------------------------
data.show_ch          = 'single'; % 'single' / 'all'

% reference mic for plots
data.ref_mic = 10; %VARIABLE

%% ------------------------------------------ 4. Separate Individually Played Notes 
% chose microphone channel for detection of separate notes
sep.ref_mic =  data.ref_mic;

% time length of resulting signal
sep.length = 6; %[s]

%  turn on for writing files, turn off for adjusting parameters
sep.writefiles = 'on'; % on

% separate individually played notes
[rec, pitch, sep] = separatorALT2_0(rec, sep, s, ch, pitch, data);

%% ------------------------------------------ 5. Windowing in TIME Domain

% length of stationary signal:
Stat.length = 0.60; %[sec] 

% time of observation after attack
Stat.time_obsv = 2; %[sec]

% find most stationary part of the signal, returns Static.rec, static part of each recording
Static = StaticFinder(pitch, rec, ch, s, Stat, sep, data);

%create wav-files
mkdir(['inputData/wav_files/',s.meta_data.GLOBAL_EmitterShortName])

%decide in which direction (up or down) the notes were played
if s.meta_data.direction == 0
    for j = 1:pitch.amount
        pitch.start= s.meta_data.pitch_lowest_name;
        noteName = pitch.all(pitch.start+j);
        % create WAV files for all pitches
        wavfilestr = append('inputData/wav_files/',s.meta_data.GLOBAL_EmitterShortName,'/',s.meta_data.ax_file,'_',noteName,'.wav');
        audiowrite(wavfilestr,Static(j).rec,s.fs,'BitsPerSample',32);
    end
elseif s.meta_data.direction == 1
    for j = 1:pitch.amount
        pitch.start= s.meta_data.pitch_lowest_name+pitch.amount+1;
        noteName = pitch.all(pitch.start-j);
        % create WAV files for all pitches
        wavfilestr = append('inputData/wav_files/',s.meta_data.GLOBAL_EmitterShortName,'/',s.meta_data.ax_file,'_',noteName,'.wav');
        audiowrite(wavfilestr,Static(j).rec,s.fs,'BitsPerSample',32);
    end
end

% Save data in SOFA-files
SOFA_Recording_export_funktion(p,s,pitch);

% Delete Wav-files
rmdir inputData/wav_files/ s

 





