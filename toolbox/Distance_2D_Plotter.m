function [dist] = Distance_2D_Plotter(r, notes, pitch, ch, data, degree,x_scale)


dist = struct('plotONE',[],'plotNORM',[]);

for k = 1:pitch.amount
dist(k) = plot_2D_distances(r, notes, k, pitch, ch, data, degree,x_scale);

end



if strcmp(data.saveplot.dist,'true') == 1 
    
    disp('saving 2D Distance Magnitude Level Diagrams...')
    
    for k = 1:pitch.amount
    
    path = [data.path '/' char(pitch.instr_name) '/' char(notes(k).NoteName) ];
    
    mkdir(path)
    figuresdir = path;
       
    
    filename = fullfile(figuresdir, ['DistanceMagnitudeLevels - ', char(x_scale)]);
    
    if exist([filename,'.png'],'file') > 0
        filename = fullfile(figuresdir, ['DistanceMagnitudeLevels - ', char(x_scale) '-01' ]);
    end
    
    
           %saveas(dist(k).plot, filename, 'png');
           exportgraphics(dist(k).plotONE,[filename,'.png'],'Resolution',300);
           exportgraphics(dist(k).plotNORM,[filename,'-normed','.png'],'Resolution',300);
   
    end
    
    disp(['saving 2D Distance Magnitude Level Diagrams completed.',newline])
end



end