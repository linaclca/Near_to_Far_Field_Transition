function [normed_data, normed_data_all_notes] = Boxplotter(boxplotstyle, notes, pitch, channel, WhiskerSize, r, data, ch )

if strcmp(data.saveplot.boxplot,'true') == 1 
            disp('saving Boxplots...')
end
            
            
for i = 1:pitch.amount
    for k = 1:ch
        notes(i).meas(k).pitch.formants_meas_Hz_mag_norm = notes(i).meas(k).pitch.formants_meas_Hz_mag - notes(i).meas(channel).pitch.formants_meas_Hz_mag  ;
    end
end

%preallocate
normed_data = zeros(pitch.amount,pitch.formants_nr,64); 

for j = 1:pitch.amount

    % store data
    for k = 1:52
        normed_data(j,:,k) = notes(j).meas(k).pitch.formants_meas_Hz_mag_norm;
    end

    % compensate wider microphone spacing at the end of the array
        normed_data(j,:,53) = NaN([15,1]);
        normed_data(j,:,54) = notes(j).meas(53).pitch.formants_meas_Hz_mag_norm;   
        normed_data(j,:,55) = NaN([15,1]);
        normed_data(j,:,56) = notes(j).meas(54).pitch.formants_meas_Hz_mag_norm;  
        normed_data(j,:,57) = NaN([15,1]);
        normed_data(j,:,58) = notes(j).meas(55).pitch.formants_meas_Hz_mag_norm;  
        normed_data(j,:,59) = NaN([15,1]);
        normed_data(j,:,60) = notes(j).meas(56).pitch.formants_meas_Hz_mag_norm;  
        normed_data(j,:,61) = NaN([15,1]);
        normed_data(j,:,62) = notes(j).meas(57).pitch.formants_meas_Hz_mag_norm;  
        normed_data(j,:,63) = NaN([15,1]);
        normed_data(j,:,64) = notes(j).meas(58).pitch.formants_meas_Hz_mag_norm;  

end

normed_data_all_notes = squeeze(sum(normed_data(1:end,:,:))/pitch.amount); % mean


% plot
xticksvector =  (0:0.5:6.3);
instr_name = load_instrument_name(pitch);

 
% -------------------------------------------------------------------------
% all notes

if strcmp(data.saveplot.boxplot_all,'true') == 1 

BoxplotALL_plot =  figure('visible','off');

    set(BoxplotALL_plot,'visible',data.showplot.boxplot);

    boxplot(normed_data_all_notes,'PlotStyle',boxplotstyle,'Whisker',WhiskerSize);
    title(['Box Plot Distribution of a ',char(instr_name),' over the entire Register', ' - first ',num2str(pitch.formants_nr),' Partials' ]);
    xlabel([newline,'Distance [m] + ',num2str(r.begin),'m'],'FontSize',12)
    ylabel('Distribution [dBr]','FontSize',12)
    set(gca,'XTickLabel',{' '});
    xticks(1:5:64);
    xticklabels(xticksvector);
    %xtickangle(90);
    
% save
if strcmp(data.saveplot.boxplot,'true') == 1 

    pathALL = [data.path '/' char(instr_name) ];
   
    mkdir(pathALL)
    figuresdir = pathALL;        

    filename = fullfile(figuresdir, 'Boxplot Diagram - Entire Register');    

    %saveas(BoxplotALL_plot, filename, 'png');
    exportgraphics(BoxplotALL_plot,[filename,'.png'],'Resolution',300);
end

end

% -------------------------------------------------------------------------
% for each individual note

if strcmp(data.saveplot.boxplot_individual,'true') == 1 

 for l = 1:pitch.amount
        Boxplot(l).plot =  figure('visible','off');

        set(Boxplot(l).plot,'visible',data.showplot.boxplot);

        boxplot(squeeze(normed_data(l,:,:)),'PlotStyle',boxplotstyle,'Whisker',WhiskerSize);
        title(['Box Plot Distribution of a ',char(instr_name),' playing the note ',char(notes(l).NoteName),' = ', num2str(min(notes(l).Hz.formants_meas_Hz),'%4.2f') ,'Hz', ' - first ',num2str(pitch.formants_nr),' Partials' ]);
        xlabel([newline,'Distance [m] + ',num2str(r.begin),'m'],'FontSize',12);
        ylabel('Distribution [dBr]','FontSize',12)
        set(gca,'XTickLabel',{' '});
        xticks(1:5:64);
        xticklabels(xticksvector);
        %xtickangle(90);
 end

if strcmp(data.saveplot.boxplot,'true') == 1 
   
    for l = 1:pitch.amount
    
        path = [data.path '/' char(instr_name) '/' char(notes(l).NoteName) ];

        mkdir(path)
        figuresdir = path;        

        filename = fullfile(figuresdir, ['Boxplot Diagram']);    

       %  if exist([filename,'.png'],'file') > 0
        %    filename = fullfile(figuresdir, ['Boxplot Diagram','-01' ]);
        %end
        
        

       

        exportgraphics(Boxplot(l).plot,[filename,'.png'],'Resolution',300);

    end

end 


end
disp(['saving Boxplots completed.',newline])




           



end