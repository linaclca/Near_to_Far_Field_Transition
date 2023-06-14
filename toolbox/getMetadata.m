 function [m] = getMetadata(Instrument)
%GETMETADATA Summary of this function goes here
%   Detailed explanation goes here
% 
% p=path
%
%
%       TODo:   m.EmitterView -> current status: emitter pointing to listener
%               m.ReceiverPosition -> ele from 90° (top) to -90° (bottom)
%                   ~~> Eigenmike em32 (ok), AMBIO VR Mic



    % Instrument metadata -----------------------------------------------
    switch Instrument
        case 1 % for Bass Arco 0 deg fixed 
            m.GLOBAL_EmitterShortName               = 'Bass Arco 0 fix';
            m.GLOBAL_EmitterDescription             = 'Bass Arco 0 degrees fixed';
            m.pitch_lowest                          = 41 ; % in Hz
            m.pitch_lowest_name                     = 1 ; % E1
            m.pitch_highest                         = 392; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 1.16; % in m
            m.SepPuffer                             = -2.4; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.035; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -40;     
            m.Stat_Start                            = 0.4; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 1; % high to low
            
        case 2 % for Bass Pizzicato 0 deg fixed 
            m.GLOBAL_EmitterShortName               = 'Bass Piz 0 fix';
            m.GLOBAL_EmitterDescription             = 'Bass Pizzicato 0 degrees fixed';
            m.pitch_lowest                          = 41 ; % in Hz
            m.pitch_lowest_name                     = 1 ; % E1
            m.pitch_highest                         = 392; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 1.16; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.035; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -40;     
            m.Stat_Start                            = 0.4; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 1; % high to low
            
        case 3 % for Bass Arco 90 deg fixed 
            m.GLOBAL_EmitterShortName               = 'Bass Arc 90 fix';
            m.GLOBAL_EmitterDescription             = 'Bass Arco 90 degrees fixed';
            m.pitch_lowest                          = 41 ; % in Hz
            m.pitch_lowest_name                     = 1 ; % E1
            m.pitch_highest                         = 392; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 1.16; % in m
            m.SepPuffer                             = -3.4; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.18; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -45;     
            m.Stat_Start                            = 0.4; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 1; % high to low
            
        case 4 % for Bass Pizzicato 90 deg fixed 
            m.GLOBAL_EmitterShortName               = 'Bass Piz 90 fix';
            m.GLOBAL_EmitterDescription             = 'Bass Pizzicato 90 degrees fixed';
            m.pitch_lowest                          = 41 ; % in Hz
            m.pitch_lowest_name                     = 1 ; % E1
            m.pitch_highest                         = 392; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 1.16; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.18; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -45;     
            m.Stat_Start                            = 0.4; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 1; % high to low
            
        case 5 % for Bass Arco 0 deg unfixed 
            m.GLOBAL_EmitterShortName               = 'Bass Arc 0 unfix';
            m.GLOBAL_EmitterDescription             = 'Bass Arco 0 degrees unfixed';
            m.pitch_lowest                          = 41 ; % in Hz
            m.pitch_lowest_name                     = 1 ; % E1
            m.pitch_highest                         = 392; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 1.16; % in m
            m.SepPuffer                             = -3.2; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.07; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -45;     
            m.Stat_Start                            = 0.4; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 0; % high to low
            
        case 6 % for Bass Pizzicato 0 deg unfixed 
            m.GLOBAL_EmitterShortName               = 'Bass Piz 0 unfix';
            m.GLOBAL_EmitterDescription             = 'Bass Pizzicato 0 degrees unfixed';
            m.pitch_lowest                          = 41 ; % in Hz
            m.pitch_lowest_name                     = 1 ; % E1
            m.pitch_highest                         = 392; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 1.16; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.07; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -45;     
            m.Stat_Start                            = 0.4; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 1; % high to low
            
        case 7 % for Clarinet 0 deg fixed
            m.GLOBAL_EmitterShortName               = 'Clarinet 0 fix';
            m.GLOBAL_EmitterDescription             = 'Clarinet 0 degrees fixed';
            m.pitch_lowest                          = 146 ; % in Hz
            m.pitch_lowest_name                     = 23 ; % D3
            m.pitch_highest                         = 988; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.6; % in m
            m.SepPuffer                             = -1.7; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.10; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -15;     
            m.Stat_Start                            = 0.06; %[sec]
            m.NotesPlayed                           = 34; 
            m.direction                             = 0; % low to high
            
        case 8 % for Clarinet 90 deg fixed
            m.GLOBAL_EmitterShortName               = 'Clarinet 90 fix';
            m.GLOBAL_EmitterDescription             = 'Clarinet 90 degrees fixed';
            m.pitch_lowest                          = 146 ; % in Hz
            m.pitch_lowest_name                     = 23 ; % D3
            m.pitch_highest                         = 988; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.6; % in m
            m.SepPuffer                             = -3; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.10; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -25;     
            m.Stat_Start                            = 0.06; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 0; % low to high
            
        case 9 % for Clarinet 0 deg unfixed
            m.GLOBAL_EmitterShortName               = 'Clarinet 0 unfix';
            m.GLOBAL_EmitterDescription             = 'Clarinet 0 degrees unfixed';
            m.pitch_lowest                          = 146 ; % in Hz
            m.pitch_lowest_name                     = 23 ; % D3
            m.pitch_highest                         = 988; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.6; % in m
            m.SepPuffer                             = -2.7; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.09; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -15;     
            m.Stat_Start                            = 0.06; %[sec]
            m.NotesPlayed                           = 34;
            m.direction                             = 0; % low to high
            
        case 10 % for flute 0 deg fixed
            m.GLOBAL_EmitterShortName               = 'Flute 0 fix';
            m.GLOBAL_EmitterDescription             = 'Clarinet 0 degrees fixed';
            m.pitch_lowest                          = 247 ; % in Hz
            m.pitch_lowest_name                     = 32 ; % B3
            m.pitch_highest                         = 3136; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.67; % in m
            m.SepPuffer                             = -3.2; 
            m.SepThreshold                          = 78; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.13; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -30;     
            m.Stat_Start                            = 0.18; %[sec]
            m.NotesPlayed                           = 23;
            m.direction                             = 3; % high to low
            
        case 11 % for flute 90 deg fixed
            m.GLOBAL_EmitterShortName               = 'Flute 90 fix';
            m.GLOBAL_EmitterDescription             = 'Clarinet 90 degrees fixed';
            m.pitch_lowest                          = 247 ; % in Hz
            m.pitch_lowest_name                     = 32 ; % B3
            m.pitch_highest                         = 3136; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.67; % in m
            m.SepPuffer                             = -3.5; 
            m.SepThreshold                          = 71.5; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.13; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -45;     
            m.Stat_Start                            = 0.18; %[sec]
            m.NotesPlayed                           = 23;
            m.direction                             = 3; % high to low
            
        case 12 % for flute 0 deg unfixed
            m.GLOBAL_EmitterShortName               = 'Flute 0 unfix';
            m.GLOBAL_EmitterDescription             = 'Clarinet 0 degrees unfixed';
            m.pitch_lowest                          = 247 ; % in Hz
            m.pitch_lowest_name                     = 32 ; % B3
            m.pitch_highest                         = 3136; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.67; % in m
            m.SepPuffer                             = -3.2; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.07; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -30;     
            m.Stat_Start                            = 0.18; %[sec]
            m.NotesPlayed                           = 23;
            m.direction                             = 3; % high to low
            
        case 13 %for Guitar 0 deg fixed 
            m.GLOBAL_EmitterShortName               = 'Guitar 0 fix';
            m.GLOBAL_EmitterDescription             = 'Guitar 0 degrees fixed';
            m.pitch_lowest                          = 82 ; % in Hz
            m.pitch_lowest_name                     = 13 ; % E2
            m.pitch_highest                         = 988; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.5; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.11; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -50;     
            m.Stat_Start                            = 0.15; %[sec]
            m.NotesPlayed                           = 43;
            m.direction                             = 3; % high to low
            
        case 14 %for Guitar 90 deg fixed 
            m.GLOBAL_EmitterShortName               = 'Guitar 90 fix';
            m.GLOBAL_EmitterDescription             = 'Guitar 90 degrees fixed';
            m.pitch_lowest                          = 82 ; % in Hz
            m.pitch_lowest_name                     = 13 ; % E2
            m.pitch_highest                         = 988; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.5; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.05; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -50;     
            m.Stat_Start                            = 0.15; %[sec]
            m.NotesPlayed                           = 43;
            m.direction                             = 3; % high to low
            
        case 15 %for Guitar 0 deg unfixed 
            m.GLOBAL_EmitterShortName               = 'Guitar 0 unfix';
            m.GLOBAL_EmitterDescription             = 'Guitar 0 degrees unfixed';
            m.pitch_lowest                          = 82 ; % in Hz
            m.pitch_lowest_name                     = 13 ; % E2
            m.pitch_highest                         = 988; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.5; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 70; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.09; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -55;     
            m.Stat_Start                            = 0.15; %[sec]
            m.NotesPlayed                           = 43;
            m.direction                             = 3; % high to low
            
        case 16 %for sax 0 deg fixed
            m.GLOBAL_EmitterShortName               = 'Sax 0 fixed';
            m.GLOBAL_EmitterDescription             = 'Sax 0 degreed fixed';
            m.pitch_lowest                          = 104 ; % in Hz
            m.pitch_lowest_name                     = 17 ; % G#2
            m.pitch_highest                         = 880; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.8; % in m
            m.SepPuffer                             = -3.3; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.105; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -20;     
            m.Stat_Start                            = 0.15; %[sec]
            m.NotesPlayed                           = 37;
            m.direction                             = 1; % high to low
            
        case 17 %for sax 90 deg fixed
            m.GLOBAL_EmitterShortName               = 'Sax 90 fixed';
            m.GLOBAL_EmitterDescription             = 'Sax 90 degreed fixed';
            m.pitch_lowest                          = 104 ; % in Hz
            m.pitch_lowest_name                     = 17 ; % G#2
            m.pitch_highest                         = 880; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.8; % in m
            m.SepPuffer                             = -2; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.05; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -25;     
            m.Stat_Start                            = 0.15; %[sec]
            m.NotesPlayed                           = 37;
            m.direction                             = 1; % high to low
            
        case 18 %for sax 0 deg unfixed
            m.GLOBAL_EmitterShortName               = 'Sax 0 unfixed';
            m.GLOBAL_EmitterDescription             = 'Sax 0 degreed unfixed';
            m.pitch_lowest                          = 104 ; % in Hz
            m.pitch_lowest_name                     = 17 ; % G#2
            m.pitch_highest                         = 880; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.8; % in m
            m.SepPuffer                             = -3.3; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.10; % + 0.15m bridge distance from instrument corpus
            m.Threshold_r                           = -20;     
            m.Stat_Start                            = 0.15; %[sec]
            m.NotesPlayed                           = 37;
            m.direction                             = 1; % high to low
            
        case 19 % for trombone 0 deg fix part 1
            m.GLOBAL_EmitterShortName               = 'Trombone 0 fixed';
            m.GLOBAL_EmitterDescription             = 'Trombone 0 degreed fixed';
            m.pitch_lowest                          = 44 ; % in Hz
            m.pitch_lowest_name                     = 2 ; % F1
            m.pitch_highest                         = 698; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.22; % in m
            m.SepPuffer                             = -3.7; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.02; 
            m.Threshold_r                           = -35;     
            m.Stat_Start                            = 0.07; %[sec]  
            m.NotesPlayed                           = 30;
            m.direction                             = 0; % low to high
            
         case 20 % for trombone 0 deg fix part 2
            m.GLOBAL_EmitterShortName               = 'Trombone 0 fixed';
            m.GLOBAL_EmitterDescription             = 'Trombone 0 degreed fixed';
            m.pitch_lowest                          = 44 ; % in Hz
            m.pitch_lowest_name                     = 2 ; % F1
            m.pitch_highest                         = 698; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.22; % in m
            m.SepPuffer                             = -3.7; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.02; 
            m.Threshold_r                           = -35;     
            m.Stat_Start                            = 0.07; %[sec]  
            m.NotesPlayed                           = 30;
            m.direction                             = 0; % low to high
            
        case 21 % for trombone 90 deg fix 
            m.GLOBAL_EmitterShortName               = 'Trombone 90 fixed';
            m.GLOBAL_EmitterDescription             = 'Trombone 90 degreed fixed part 1';
            m.pitch_lowest                          = 44 ; % in Hz
            m.pitch_lowest_name                     = 2 ; % F1
            m.pitch_highest                         = 698; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.22; % in m
            m.SepPuffer                             = -3.5; 
            m.SepThreshold                          = 95; 
            m.SepMinPeakDist_time                   = 5.5; 
            m.r_Begin                               = 0.02; 
            m.Threshold_r                           = -43;     
            m.Stat_Start                            = 0.07; %[sec]  
            m.NotesPlayed                           = 48;
            m.direction                             = 0; % low to high
            
            
        case 22 % for trombone 0 deg unfix part 1
            m.GLOBAL_EmitterShortName               = 'Trombone 0 unfixed';
            m.GLOBAL_EmitterDescription             = 'Trombone 0 degreed unfixed part 1';
            m.pitch_lowest                          = 44 ; % in Hz
            m.pitch_lowest_name                     = 2 ; % F1
            m.pitch_highest                         = 698; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.22; % in m
            m.SepPuffer                             = -3.2; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.08; 
            m.Threshold_r                           = -35;     
            m.Stat_Start                            = 0.07; %[sec]
            m.NotesPlayed                           = 30;
            m.direction                             = 0; % low to high
            
        case 23 % for trombone 0 deg unfix part 2
            m.GLOBAL_EmitterShortName               = 'Trombone 0 unfixed';
            m.GLOBAL_EmitterDescription             = 'Trombone 0 degreed unfixed part 2';
            m.pitch_lowest                          = 44 ; % in Hz
            m.pitch_lowest_name                     = 32 ; % F1
            m.pitch_highest                         = 698; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.22; % in m
            m.SepPuffer                             = -5; 
            m.SepThreshold                          = 80; 
            m.SepMinPeakDist_time                   = 6.5; 
            m.r_Begin                               = 0.08; 
            m.Threshold_r                           = -15;     
            m.Stat_Start                            = 0.07; %[sec]
            m.NotesPlayed                           = 18;
            m.direction                             = 0; % low to high
            
        case 24 % for Violin 0 deg fixed
            m.GLOBAL_EmitterShortName               = 'Violin 0 fixed';
            m.GLOBAL_EmitterDescription             = 'Violin 0 degreed fixed';
            m.pitch_lowest                          = 180 ; % in Hz
            m.pitch_lowest_name                     = 28 ; % G3
            m.pitch_highest                         = 2400; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.35; % in m
            m.SepPuffer                             = -3.2; 
            m.SepThreshold                          = 60; 
            m.SepMinPeakDist_time                   = 5.8; 
            m.r_Begin                               = 0.13; 
            m.Threshold_r                           = -45;     
            m.Stat_Start                            = 0.27; %[sec]
            m.NotesPlayed                           = 50;
            m.direction                             = 0; % low to high
            
        case 25 % for Violin 90 deg fixed
            m.GLOBAL_EmitterShortName               = 'Violin 90 fixed';
            m.GLOBAL_EmitterDescription             = 'Violin 90 degreed fixed';
            m.pitch_lowest                          = 180 ; % in Hz
            m.pitch_lowest_name                     = 28 ; % G3
            m.pitch_highest                         = 2400; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.35; % in m
            m.SepPuffer                             = -3.4; 
            m.SepThreshold                          = 60; 
            m.SepMinPeakDist_time                   = 6; 
            m.r_Begin                               = 0.15; 
            m.Threshold_r                           = -50;     
            m.Stat_Start                            = 0.27; %[sec]
            m.NotesPlayed                           = 50;
            m.direction                             = 0; % low to high
            
        case 26 % for Violin 0 deg unfixed
            m.GLOBAL_EmitterShortName               = 'Violin 0 unfixed';
            m.GLOBAL_EmitterDescription             = 'Violin 0 degreed unfixed';
            m.pitch_lowest                          = 180 ; % in Hz
            m.pitch_lowest_name                     = 28 ; % G3
            m.pitch_highest                         = 2400; % in Hz
            m.InstrTuning                           = 440; % in Hz
            m.InstrLength                           = 0.35; % in m
            m.SepPuffer                             = -3.2; 
            m.SepThreshold                          = 60; 
            m.SepMinPeakDist_time                   = 5.8; 
            m.r_Begin                               = 0.11; 
            m.Threshold_r                           = -50;     
            m.Stat_Start                            = 0.27; %[sec]
            m.NotesPlayed                           = 42;
            m.direction                             = 0; % low to high
            
    end
end

            
            
            
            
            
            
            
            
            
