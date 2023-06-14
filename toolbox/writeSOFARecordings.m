function[]=writeSOFARecordings(p, s, meta, general, obj)
    % This function is called by the script 'SOFA_RAW_export_main.m' and does
    % the actual SOFA file writing.
    
    if  isempty(strfind(s.name,'_v'))
        str1 = s.name;
    else
        str1 = [s.name(1:end-10),'.wav'];
    end
    pitch = detectTone(str1);
    
    %% Get grid points
    % grid for wav data (DepositOnce)
    sg_wav = load('R_Phi_Theta');
    sg_wav = [sg_wav.phi' sg_wav.theta'] / pi * 180;
    sg_wav = round(sg_wav, 2);
    
    %% Get raw complex freqData form .wav file
    [x, fs] = audioread(fullfile(p.to_record));
    
    % make x even for unified both side IFFT 
    if mod(size(x,1),2) % is even
        x(end-1,:) = [];
    end
    
    % DFT amplitude spectrum
    spec = fft(x); % via CPU
    % spec = gather(fft(gpuArray(x))); % via GPU
    
    % convert to single-sided spectrumF
    if ~mod(size(x,1),2) % is even
        spec = spec(1:end/2+1,:);
        spec(2:end-1,:) = 2*spec(2:end-1,:);
    else % is odd: all bins other than k=0 have to be multiplied with 2.
        spec = spec(1:ceil(end/2),:);
        spec(2:end,:) = 2*spec(2:end,:);
    end

    % stored as 4-byte (32-bit) floating-point values
    spec = single(spec);
    
    % create a frequency axis for the plot in Hz
    freqVector = linspace(0, fs/2, length(spec)).';
    
    %% Fill with attributes
    % Source        =   represents the acoustic source under consideration(default).
    % Emitters      =   represent a more detailed structure of the Source. In a 
    %                   simple settings, a single Emitter is considered that is 
    %                   collocated with the source(default).
    % Listener      =   represents the array of microphones. In a simple setting, 
    %                   the position of the Listener is collocated with the position
    %                   of the Source (default).
    % Receivers     =   represent the microphones capturing the sound from the 
    %                   acoustic source.
    % Measurement   =   captures a modification of the directivity condition: 
    %                   Another musical note played during the measurement? 
    %                   The MIDINote will change.
    % Data          =   stores the captured signals. The data is saved as complex 
    %                   numbers in Data.Real and Data.Imag at the N spectral   
    %                   frequencies for R receivers and M measurements (notes).
    
    obj.GLOBAL_AuthorContact            = general.authorcontact;
    obj.GLOBAL_Organization             = general.organization;
    obj.GLOBAL_License                  = general.license;
    obj.GLOBAL_ApplicationName          = general.applicationname;
    obj.GLOBAL_ApplicationVersion       = general.applicationversion;
    obj.GLOBAL_Comment                  = general.comment;
    obj.GLOBAL_History                  = general.history;
    obj.GLOBAL_Reference                = general.references;
    obj.GLOBAL_Origin                   = general.origin;
    obj.GLOBAL_DatabaseName             = general.databasename;
    obj.GLOBAL_Musician                 = char("Unknown");
    obj.GLOBAL_SourceManufacturer       = char("Unknown");
    %%%%% Add Comment for Timpani
    obj.GLOBAL_SourceType               = strrep(s.name(1:end-(length(pitch)+11)), '_', ' '); %e.g. 'Trumpet modern';
    %%%%%
    obj.GLOBAL_Title                    = [general.title obj.GLOBAL_SourceType];
    obj.GLOBAL_DatabaseName             = meta.ax_file;
    
    obj.SourceTuningFrequency           = 440;
    obj.SourceView_Reference            = char("Unknown"); 
    obj.SourceUp_Reference              = obj.SourceView_Reference;
    
    % set receiver Position in Array (R)
    obj.ReceiverPosition_Type = 'cartesian';
    obj.ReceiverPosition_Units = 'metre, metre, metre';
    obj.ReceiverPosition = [0.1,0,0];
    
    % set measurments aka MIDINote (M)
    % doesn't work always as the list of tones from NOAM data does NOT coincide
    % with the tones of the actual wav data
    %obj.MIDINote = radiation.midiNotes(strcmpi(radiation.noteNames, tone)); % A4 = 440 Hz
    [~,obj.MIDINote,~] = AKmidiConversion(pitch,'noteString');
    if isempty(obj.MIDINote)
        error(['Midi note for tone: ',pitch,' not detected correctly from: '])
    end
    

    %Create txt-files for steady part
    %save temporaty.txt x -ASCII

    % Set steady part info in API
    %obj.API.A = 2;
    %obj.API.Dimensions.SteadyPart  = 'IA';   
    % 
    %obj.SteadyPart = [0 60]; 
    % % get steady part info
    %steadyPart = importdata(strcat('temporaty.txt'));
    %obj.SteayPart = [0 60];
    
    %if size(steadyPart,1) == 4
    %    obj.SteadyPart                      = steadyPart(2:3,2)';
    %    obj.SteadyPart_Reference            = 'Range of the stationary held tone in the original recording';  
    %else
    %    obj.SteadyPart                      = [0 0];
    %    obj.SteadyPart_Reference            = 'No stationary part contained in the original recording';  
    %end
    obj.SteadyPart_Units                    = 'samples';
    
    % set N Spectral Frequencies
    obj.N = single(freqVector);
    
    % set E, number of emitters shall be 1
    obj.API.E = 1;
    
    % init obj.Data
    obj.Data.Real = zeros(size(obj.MIDINote,1),size(obj.ReceiverPosition,1),size(obj.N,1));
    obj.Data.Imag = zeros(size(obj.MIDINote,1),size(obj.ReceiverPosition,1),size(obj.N,1));
    
    % Measurements aka tones
    % this loop is actually obsolete because it is always run only for one note
    for m = 1:size(obj.MIDINote,1)
        % Midi note string
        [~, ~, noteString] = AKmidiConversion(obj.MIDINote(m), 'midiNoteNumber');
    
        % get musical dynamic info
        dynamic = char(p.to_record);
        dynamic(1:end-2) = [];

        if  isempty(strfind(s.name,'_v'))
            dynamicStr = ['; dynamic = ', dynamic];
        else
            dynamicStr = ['; ', char(meta{1, 6})];
        end
        obj.GLOBAL_Description = [  'note = ',noteString, dynamicStr];
    
        % Data, complex TFs for r recievers
        for r = 1:58
            obj.Data.Real(m, r, :) = real(spec(:, r));
            obj.Data.Imag(m, r, :) = imag(spec(:, r));
        end
    end
    
    %% Update dimensions
    obj = SOFAupdateDimensions(obj);
    
    %% save the SOFA file
    % fit s.name
    s.name = strrep(s.name,'_et','');
    str2 = meta.GLOBAL_EmitterShortName;


    %if  isempty(strfind(s.name,'_v'))
    %    str1 = s.name(1:end-(length(pitch)+8));
    %    str2 = s.name(1:end-(length(pitch)+5));
    %else
    %    str1 = s.name(1:end-(length(pitch)+11));
    %    str2 = strrep(s.name(1:end-(length(pitch)+5)),'_d2','');
    %end


    if ~exist([p.to_recordings,'/',str2], 'dir')
        mkdir([p.to_recordings,'/',str2])
    end
    
    SOFAfn = fullfile([p.to_recordings,'/',str2,'/',s.name(1:end-4),'_recording.sofa']);
    disp(['Saving:  ' SOFAfn]);
    SOFAsave(SOFAfn, obj, general.compression);
    


    %% check if we do the convertion correctly
    % Loading the full object
%     disp(['Loading full object: ' SOFAfn]);
%     ObjFull=SOFAload(SOFAfn);
%     
%     % SOFAplotGeometry(ObjFull)
%     spec = squeeze(complex(ObjFull.Data.Real(1,1,:), ObjFull.Data.Imag(1,1,:)));
%     
%     % convert to both-sided spectrum and IFFT
%     spec(2:end-1,:) = spec(2:end-1,:)/2;
%     spec = [spec; conj(spec(end-1:-1:2,:))];
%     
%     x_check = ifft(spec, 'symmetric');
%     
%     plot(x(:,1)-x_check(:,1));
%     close all

end