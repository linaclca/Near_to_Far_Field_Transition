function [rec, pitch, sep] = separatorALT(rec, sep, s, ch, pitch, data)


disp('separating individual notes...')

len = length(rec.file);

rec_db = db(rec.file(:,sep.ref_mic))+94 ; 
  
[~,sep.locs_time] = findpeaks(rec_db,'MinPeakHeight',s.meta_data.SepThreshold,'MinPeakDistance',s.meta_data.SepMinPeakDist_time * s.fs);

pitch.amount = length(sep.locs_time);

sep.length_fs = sep.length*s.fs;

sep.puffer = s.meta_data.SepPuffer * s.fs;
sep.locs = sep.locs_time + sep.puffer;

sep.locs_end = sep.locs+ sep.length_fs -1;

% preallocate
rec.file_sep = zeros(pitch.amount,sep.length_fs,ch);


if length(strfind(sep.writefiles,'on')) == 1
   % DELETE?
    % for i = 1:pitch.amount 
    %    for k = 1:ch
     %       rec.file_sep(i,:,k) = (rec.file((sep.locs(i):sep.locs(i)+sep.length*s.fs-1),k)); 
      %  end
    %end
    
    for i = 1:pitch.amount-1
        for k = 1:ch
            rec.file_sep(i,:,k) = (rec.file((sep.locs(i):sep.locs_end(i)),k)); 
        end
    end
    
    % ensure correct indices for last detected note
    if sep.locs_end(pitch.amount)  < len
        for k = 1:ch
            rec.file_sep(pitch.amount,:,k) = rec.file((sep.locs(pitch.amount):sep.locs_end(pitch.amount)),k); 
        end
        
    else 
        ls = len - sep.locs(pitch.amount);
        sep.locs_ls = sep.locs(pitch.amount)+ls;
        
        for k = 1:ch
            rec.file_sep(pitch.amount,(1:ls+1),k) = rec.file((sep.locs(pitch.amount):end),k); 
        end
    end
    
elseif length(strfind(sep.writefiles,'off')) == 1
end

% Plot

% load instrument name
%[instr_name] = s.meta_data.GLOBAL_EmitterShortName;

%max_length_30s = floor(len/s.fs/30);

%all_notes_plot = figure;


%plot(db(rec.file(:,sep.ref_mic))+94); hold on,
%set(all_notes_plot,'visible',data.showplot.sep); 
%for i = 1:pitch.amount

%xline(sep.locs(i),'--');
%end
%hold off
%title(['Recording of a', char(instr_name) ,'playing single notes through its register']);
%ylim([54 max(db(rec.file(:,sep.ref_mic))+94)+10]);
%xticks((1:s.fs*30:len));
%xticklabels(0:0.5:max_length_30s);
%xlabel('Time [min]');
%ylabel('SPL [dB]');

%disp(['separation completed', newline])

% save plot
%if strcmp(data.saveplot.sep,'true') == 1 
    
%    path = [data.path '/' char(pitch.instr_name) ];

%        mkdir(path)
%        figuresdir = path;

%        filename = fullfile(figuresdir,'Recording of all notes');

%    exportgraphics(all_notes_plot,[filename,'.png'],'Resolution',300);
%end

end