function [] =  SpectroPlotter(notes, s, idx, Static, pitch, spectro_par, data, r);

wlen = spectro_par.wlen ;
minimumlevel = spectro_par.minimumlevel ;
tfr = spectro_par.tfr ;

    if strcmp(data.saveplot.spectro,'true') == 1 
            disp('saving Spectrograms...')
    end
 
    Spectro = struct('plot',[]);

    for i = 1:pitch.amount
        for j = idx %1:ch
            plot_SpectrogramNEW(Spectro, notes, s, j, Static, pitch, minimumlevel, tfr, i, data,r);
        end
    end

    if strcmp(data.saveplot.spectro,'true') == 1 
            disp(['saving Spectrograms completed.',newline])
    end
 
end