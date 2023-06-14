function [mag] = plot_2D_magnitudes(r, notes, k, pitch, data)

% find index of chosen microphones
len2D = length(r.plot);
idx = zeros(1,len2D);

for i = 1:len2D
    [~, idx(:,i)]= min(abs(r.array - r.plot(i)'));
end



% preallocate
%notes_mag = zeros(length(unique(notes(k).meas(idx(1)).pitch.formants_meas_Hz_mag,'stable')),len2D);
notes_mag = zeros(length(notes(k).meas(idx(1)).pitch.formants_meas_Hz_mag),len2D);


% delete double entries, in case less formants were detected
for i = 1:len2D
    [notes_mag(:,i), ia , ~] = unique(notes(k).meas(idx(i)).pitch.formants_meas_Hz_mag,'stable');
end

% magnitudes for selected channels (rows), formants (col) 
notes_mag = notes_mag';


formants_amount = 15; %length(ia);

% preallocate
notes_validity = zeros(len2D, formants_amount);

% get 2nd far-field criteria validity
for i = 1:len2D
notes_validity(i,(1:formants_amount)) =  notes(k).r_crit_valid((idx(i)),(1:formants_amount));
end


% does NOT fulfill 2nd far-field criteria
notes_nearfield = notes_mag .* notes_validity; 
notes_nearfield(notes_nearfield == 0) = NaN;

% does fullfil 2nd far-field criteria
notes_farfield = notes_validity;
notes_farfield(notes_validity == 1) = NaN;
notes_farfield(notes_validity == 0) = 1;

notes_farfield_pad = notes_farfield;

for i = 1:len2D
    for j = 1:formants_amount-1
       if  notes_farfield(i,j) == 1
           notes_farfield_pad(i,j+1) = 1;
       end    
    end
end  
  
notes_farfield_mag = notes_mag .* notes_farfield_pad;


% PLOT ------------------------------------------------


% colors
newcolors = {'#0072BD','#D95319','#EDB120'	,'#7E2F8E'	,'#77AC30'	,'#4DBEEE'	,'#A2142F','#0072BD'};
newcolors = newcolors(1:len2D);


% legend info
legend_info = split(string(r.array(idx)));


% x tick label vector
xtickvec = string(0:formants_amount-1);

% Plot 1
mag.plotONE = figure('visible','off');
set(mag.plotONE,'visible',data.showplot.mag); 
for i = 1:len2D
           p1(i) = plot(notes_nearfield(i,:),'-'); hold on
           colororder(newcolors);
end
                
for i = 1:len2D
           p2 = plot(notes_farfield_mag(i,:),'--'); hold on
           colororder(newcolors);
end   

hold off;
           
            

title(['Magnitude Levels of a ', char(pitch.instr_name), ' playing the note ', char(notes(k).NoteName) ,' = ', num2str(notes(k).Hz.formants_meas_Hz(1),'%4.2f'), 'Hz',' - absolute']);
lgd = legend(p1,legend_info,'Location','northeastoutside');
title(lgd,(['distance [m] + ',num2str(r.begin), 'm']));
xlim([1 formants_amount]);
ylim([0 pitch.upperLim]);
xticks((1:1:formants_amount));
xticklabels(xtickvec);
xlabel(['Fundamental Frequency with first ',num2str(formants_amount-1) ,' overtones']);
ylabel('SPL [dB]');


%-------------------------------------------------------------------------------

% Plot NORM

notes_nearfieldNORM = notes_nearfield - notes_mag(len2D,:);
notes_farfield_magNORM = notes_farfield_mag - notes_mag(len2D,:);

mag.plotNORM = figure('visible','off');
set(mag.plotNORM,'visible',data.showplot.mag); 
for i = 1:len2D
           p1_norm(i) = plot(notes_nearfieldNORM(i,:),'-'); hold on
           colororder(newcolors);
end
                
for i = 1:len2D
           p2_norm = plot(notes_farfield_magNORM(i,:),'--'); hold on
           colororder(newcolors);
end   

hold off;
           
            

title(['   Magnitude Levels of a ', char(pitch.instr_name), ' playing the note ', char(notes(k).NoteName) ,' = ', num2str(notes(k).Hz.formants_meas_Hz(1),'%4.2f'), 'Hz',' - relative to ', num2str(r.array(max(idx))+r.begin,'%4.2f'),'m' ]);
lgd = legend(p1_norm,legend_info,'Location','northeastoutside');
title(lgd,(['distance [m] + ',num2str(r.begin), 'm']));
xlim([1 formants_amount]);
% ylim([-3 (max(notes_mag(1,:)-notes_mag(len2D,:))+3)]);
ylim([-10 80])
%ylim([pitch.lowerLim (max(notes_nearfieldNORM(:))+3)]);
xticks((1:1:formants_amount));
xticklabels(xtickvec);
xlabel(['Fundamental Frequency with first ',num2str(formants_amount-1) ,' overtones']);
ylabel('[dBr]');


end
