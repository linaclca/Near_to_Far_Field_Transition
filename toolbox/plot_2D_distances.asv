function [dist] = plot_2D_distances(r, notes, k, pitch, ch, data, degree, x_scale)



% align to line array microphones distances
[X,~] = meshgrid(r.array, ch);

% x axis label points
xtick_points = (0:0.5:6);

% preallocate
dist_mag = NaN(ch,pitch.formants_nr);

% get magnitudes for all detected formants
% for i = 1:ch
%         [tmp, ia , ~] = unique(notes(k).meas(i).pitch.formants_meas_Hz_mag','stable');
%         dist_mag(i,(1:length(ia))) = tmp;
% end

for i = 1:ch
    [tmp] = notes(k).meas(i).pitch.formants_meas_Hz_mag;
    dist_mag(i,(1:15))) = tmp;
end

for j = 1:pitch.formants_nr
dist_mag(:,j) = smooth(dist_mag(:,j),'sgolay',degree);
end


% Legend info -----------------------------------------------------------

legend_info_f = (['f0  = '; 'f1  = '; 'f2  = '; 'f3  = '; 'f4  = '; 'f5  = '; 'f6  = '; 'f7  = ';'f8  = '; 'f9  = '; 'f10 = '; 'f11 = '; 'f12 = '; 'f13 = ' ;'f14 = ' ;'f15 = ';'f16 = ';'f17 = '; 'f18 = '; 'f19 = ';'f20 = ' ]) ;

legend_info = cell2mat(struct2cell(notes(k).Hz));
legend_info = num2str(legend_info,'%4.0f');


legend_info_f = legend_info_f(1:length(legend_info),:);
legend_info_Hz = strings(length(legend_info),1);
legend_info_Hz(:,1) = 'Hz';
legend_info_all = join([legend_info_f,legend_info, legend_info_Hz],2);


pitch.lowerLim = -10;


% PLOT one --------------------------------------------------------------------

dist.plotONE = figure('visible','off');
set(dist.plotONE,'visible',data.showplot.dist); 
for i = 1:length(ia)
    % x axis scaling    
    if  strcmp(x_scale,'log') == 1     
        P(i) = semilogx(X,dist_mag(:,i)); hold on;
    elseif strcmp(x_scale,'lin') == 1 
         P(i) = plot(X,dist_mag(:,i)); hold on;
    end
end

title(['Magnitude Levels of a ', char(pitch.instr_name), ' playing the note ', char(notes(k).NoteName) ,' = ', num2str(notes(k).Hz.formants_meas_Hz(1),'%4.2f'), 'Hz']);
lgd = legend(P,legend_info_all,'Location','northeastoutside');
xlim([0 6.3]);
ylim([0 pitch.upperLim]);
xticks(xtick_points);
xlabel(['distance [m] + ',num2str(r.begin), 'm']);
ylabel('SPL [dB]');
hold off;


% PLOT TWO (normed) --------------------------------------------------------------------

dist_magNORM = dist_mag - dist_mag(ch,:);

dist.plotNORM = figure('visible','off');
set(dist.plotNORM,'visible',data.showplot.dist); 
for i = 1:length(ia)
    % x axis scaling    
    if  strcmp(x_scale,'log') == 1     
        P(i) = semilogx(X,dist_magNORM(:,i)); hold on;
    elseif strcmp(x_scale,'lin') == 1 
         P(i) = plot(X,dist_magNORM(:,i)); hold on;
    end
end

title(['   Magnitude Levels of a ', char(pitch.instr_name), ' playing the note ', char(notes(k).NoteName) ,' = ', num2str(notes(k).Hz.formants_meas_Hz(1),'%4.2f'), 'Hz',' - relative to ', num2str(r.array(ch)+r.begin,'%4.2f'),'m']);
lgd = legend(P,legend_info_all,'Location','northeastoutside');
xlim([0 6.3]);
ylim([pitch.lowerLim (max(dist_magNORM(1,:))+3)]);
xticks(xtick_points);
xlabel(['distance [m] + ',num2str(r.begin), 'm']);
ylabel('[dBr]');


hold off;

end