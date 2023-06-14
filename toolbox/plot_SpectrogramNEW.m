function [Spectro] = plot_SpectrogramNEW(Spectro, notes, s,idx, Static, pitch, minimumlevel,tfr,i,data,r)


instr_name = load_instrument_name(pitch);

% length of static signal
stat_length_ms = length(Static(1).rec(:,1)) / s.fs * 1000 ; %[ms]



% hard parameters   
fmax = max(notes(i).Hz.formants_meas_Hz)+ min(notes(i).Hz.formants_meas_Hz);
    
calibfile = 'inputData/calibration/calib_file_162316.txt';

 
sig = calibratorNEW(Static(i).rec(:,idx), calibfile, 1);
dynrange = 20*log10(max(sig)/(2*10^(-5))) - minimumlevel;



figure('visible','off');
Spectro_plot(:,:,i) = sgram(sig, s.fs,'db','posfreq', 'dynrange',dynrange,'fmax',fmax, 'tfr',tfr);%, 'wlen', wlen);
Spectro_plot = flipud(Spectro_plot);

y_tickdist = (size(Spectro_plot,1)-1) / round(fmax/min(notes(i).Hz.formants_meas_Hz));

y_ticktxt= unique(notes(i).Hz.formants_meas_Hz,'stable');
y_ticktxt = [y_ticktxt; fmax];
y_ticktxt = flipud(num2str(y_ticktxt,'%4.0f'));

y_tickvec = (0:(size(Spectro_plot,1)/size(y_ticktxt,1)):size(Spectro_plot,1));

    % save plot -----------------------------------------------------------

    
        
        Spectro(i).plot =  figure('visible','off');
        set(Spectro(i).plot,'visible',data.showplot.spectro); 
        imagesc(Spectro_plot(:,:,i));
        %c = colorbar;
        %c.Label.String = 'SPL [dB]';
        set(Spectro(i).plot,'visible',data.showplot.spectro); 
        title(['Spectrogram of a ',char(instr_name),' playing the note ',char(notes(i).NoteName),' = ', num2str(min(notes(i).Hz.formants_meas_Hz),'%4.2f') ,'Hz (CH ',num2str(idx), ' = ',num2str(r.measuring_points(idx)),'m Distance)' ]);
       xlabel(['total signal length: ', num2str(stat_length_ms), ' ms']);
       set(gca,'xtick',[])
        set(gca,'xticklabel',[]) 
       yticks(single(y_tickvec)+y_tickdist-1);
        yticklabels(y_ticktxt);
        ylabel('Frequency [Hz]');
        
        
        if strcmp(data.saveplot.spectro,'true') == 1 

            path = [data.path '/' char(instr_name) '/' char(notes(i).NoteName) ];

            mkdir(path)
            figuresdir = path;

            filename = fullfile(figuresdir, ['Spectrogram - Channel ' num2str(idx)]);

      
            if exist([filename,'.png'],'file') > 0
                filename = fullfile(figuresdir, ['Spectrogram - Channel ' num2str(idx) '-01' ]);
            end
       
          exportgraphics(Spectro(i).plot,[filename,'.png'],'Resolution',300);        
        end

end