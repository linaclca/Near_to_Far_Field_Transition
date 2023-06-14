function [mag] = Magnitude_2D_Plotter(r, notes, pitch, data)


mag = struct('plotONE',[],'plotNORM',[]);

for k = 1:pitch.amount
mag(k) = plot_2D_magnitudes(r, notes, k, pitch, data);
end



if strcmp(data.saveplot.mag,'true') == 1 
    
    disp('saving 2D Magnitude Level Diagrams...')
    
    for k = 1:pitch.amount
    
    path = [data.path '/' char(pitch.instr_name) '/' char(notes(k).NoteName) ];
    
    mkdir(path)
    figuresdir = path;
    
    
    filename = fullfile(figuresdir, ['MagnitudeLevels']);
    
    if exist([filename,'.png'],'file') > 0
        filename = fullfile(figuresdir, ['MagnitudeLevels', '-01' ]);
    end
       
          % saveas(mag(k).plot,  filename, 'png');
          
          exportgraphics(mag(k).plotONE,[filename,'.png'],'Resolution',300);
          exportgraphics(mag(k).plotNORM,[filename,'-normed','.png'],'Resolution',300);
    end
    
    disp(['saving 2D Magnitude Level Diagrams completed.',newline])
end



end