function [] = plot_WaterfallALT(data, notes, ch, r, pitch, k, degree)
%-------------------------------------------------------------------------

% load instrument name
%[instr_name] = load_instrument_name(pitch);
[instr_name] = pitch.instr_name;

axislim  = pitch.upperLim;
% --- get data points =--------------------------------------------------

% adjust size (unlikely case)
if ch < pitch.formants_nr
    r.measuring_points = NaN(1,pitch.formants_nr);
    r.measuring_points(1:ch) =  r.measuring_points;

    Y = notes(k).Hz.formants_meas_Hz;  % frequency  
    

%  likely case more channels than observed formants
elseif ch >= pitch.formants_nr

    Y = NaN(ch,1);
    %X(1:pitch.formants_nr) = notes(k).Hz.formants_meas_Hz;  % frequency  
    Y(1:length(unique(notes(k).Hz.formants_meas_Hz,'stable'))) = unique(notes(k).Hz.formants_meas_Hz,'stable');  % frequency 
end


% --- mesh allocation ---------------------------------------------------
X = r.measuring_points;
Z = NaN(length(X),length(Y));

for i = 1:ch
Z((1:pitch.formants_nr),i) = notes(k).meas(i).pitch.formants_meas_Hz_mag;                            
end

% --- smooth data ------------------------------------------------------

% preallocate
Z_smooth = NaN(length(X),length(Y));

for i = 1:ch
Z_smooth(i,:) = smoothdata(Z(i,:),'sgolay',degree);
end

% --- get far field criteria line ---------------------------------------

X_crit = NaN(1,ch);
X_crit(1:pitch.formants_nr) = r.crit;%(notes(k).idx,:);

% preallocate 
Z_crit = NaN(ch,1);

% interpolate Z_crit
for i = 1:pitch.formants_nr
 [~, idx]= min(abs(X_crit(i)-X));
 Z_crit(i) =  Z_smooth(i,idx);
end

lowerlim = 0;

%axislim = max(Z_smooth(:));
%if axislim <= lowerlim
 %   axislim = 55;
%end

Z_smooth(16,1) = 0;
% --- PLOT -----------------------------------------------------------

% Waterfall Plot
f = figure('Name',[char(instr_name), ' - Waterfall Diagram ',' - ', char(notes(k).NoteName)]);
set(f,'visible',data.showplot.water); 
WaterfallDiagram = waterfall(X,Y,Z_smooth,Z_smooth); hold on;

WaterfallDiagram.LineWidth = 2;
alpha(WaterfallDiagram,.5);
c = colorbar('Location','westoutside');
c.Label.String = 'SPL [dB]';
%
r_critplot = line(X_crit,Y,Z_crit); hold off,

title(['Waterfall Radiation Diagram of a ', char(instr_name), ' playing the note ', char(notes(k).NoteName) ,' = ', num2str(notes(k).Hz.formants_meas_Hz(1),'%4.2f'), 'Hz']);

r_critplot.LineStyle = '--';
r_critplot.LineWidth = 2;
r_critplot.Color = 'r';
view(115,45)
if max(Y) < 20000
    ylim([0 max(Y)]);
else 
    ylim([0 20000]);
end
caxis([lowerlim axislim]);
%yticks([-(fliplr(measuring_points))]);
%yticklabels({'2','1.6','1.2','0.8','0.4','0'});
xticks((0:1:6));
%xticklabels({'0','1', '2','3','4','5','6'})
ylabel('frequency [Hz]');
xlabel(['distance + ', num2str(r.begin) ,' [m]']);
xlim([0, max(r.measuring_points)]);
zlabel('PSD (dB/Hz)')
zlim([lowerlim axislim]);



% save plot -----------------------------------------------------------

if strcmp(data.saveplot.water,'true') == 1 

    path = [data.path '/' char(instr_name) '/' char(notes(k).NoteName) '/' ];
    
    mkdir(path)
    figuresdir = path;
    
    filename = fullfile(figuresdir, ['Waterfall']);
    
     if exist([filename,'.png'],'file') > 0
        filename = fullfile(figuresdir, ['Waterfall', '-01' ]);
    end
    
       
    %saveas(WaterfallDiagram, filename, 'png');
    exportgraphics(f,[filename,'.png'],'Resolution',300);
end


end