function [obj] = writeSOFASingleTones(p, meta, Ps, f, obj, general)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.GLOBAL_Comment = 'Contains the sound pressure of the fundamental note and harmonics/overtones in Pa.';
    obj.GLOBAL_History = 'The energy of fundamental note and harmonics were extracted from the steady state of the original recording.';

    % Wrtite new frequency vector N
    obj.N = f;
    
    % Wrtite new Data vector
    obj.Data.Real = zeros(1,size(Ps,2),size(Ps,1));
    obj.Data.Imag = zeros(1,size(Ps,2),size(Ps,1));
    obj.Data.Real(1,:,:) = Ps';
    
    % delete SteadyPart info from object/API
    if isfield(obj, 'SteadyPart')
        obj                   = rmfield(obj,'SteadyPart');
        obj                   = rmfield(obj,'SteadyPart_Reference');
        obj                   = rmfield(obj,'SteadyPart_Units'); 
        obj.API               = rmfield(obj.API,'A');
        obj.API.Dimensions    = rmfield(obj.API.Dimensions,'SteadyPart'); 
    end
    
    % Update dimensions
    obj = SOFAupdateDimensions(obj);

    %s.name = strrep(s.name,'_recording','');
    str2 = meta.GLOBAL_EmitterShortName;

    if ~exist([p.to_singleTones,'/',str2], 'dir')
        mkdir([p.to_singleTones,'/',str2])
    end
    
    SOFAfn = fullfile([p.to_singleTones,'/',str2,'/',p.filename,'_',num2str(obj.MIDINote),'_singleTones.sofa']);
    disp(['Saving:  ' SOFAfn]);
    SOFAsave(SOFAfn, obj, general.compression);
    
end