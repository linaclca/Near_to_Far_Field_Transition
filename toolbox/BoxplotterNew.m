function [normed_data] = BoxplotterNew(obj,meta,data,boxplotstyle,WhiskerSize, r,ch,p)% notes, pitch, channel, WhiskerSize, r, data, ch )

formant_nr = size(obj,3)-1;

%preallocate & initialize normed_data
%normed_data = zeros(formant_nr,64);

%obj = 20*log10(obj);

for k = 1:ch
    normed_data(:,k,:) = (obj(:,k,1:formant_nr) - obj(:,58,1:formant_nr)) + 1;
end

normed_data = 20*log10(normed_data);

% Linear regression with max & min
for i = 1:58
    max_lin(i) = max(normed_data(:,i));
    min_lin(i) = min(normed_data(:,i));
end

% compensate wider microphone spacing at the end of the array
normed_data(:,64,:) = normed_data(:,58,:);
normed_data(:,63,:) = NaN([formant_nr,1]);
normed_data(:,62,:) = normed_data(:,57,:);
normed_data(:,61,:) = NaN([formant_nr,1]);
normed_data(:,60,:) = normed_data(:,56,:);
normed_data(:,59,:) = NaN([formant_nr,1]);
normed_data(:,58,:) = normed_data(:,55,:);
normed_data(:,57,:) = NaN([formant_nr,1]);
normed_data(:,56,:) = normed_data(:,54,:);
normed_data(:,55,:) = NaN([formant_nr,1]);
normed_data(:,54,:) = normed_data(:,53,:); 
normed_data(:,53,:) = NaN([formant_nr,1]);



% load measuring points and allocate data
r.measLen = length(r.measuring_points);             % must be size of variable 'ch'

% interpolation 
r.interp = (min(r.measuring_points):0.05:max(r.measuring_points));  

% decrease (1/r) as factor and in SPL 
r.DecFactor = min(r.interp)./r.interp;  % factor
r.DecSPL = db(r.DecFactor);             % SPL

% find indices of measuring distances in the interpolation
for i = 1:r.measLen
[r.val(i), r.idx(i)] = min(abs(r.measuring_points(i)-r.interp));
end

% decrease at measuring points as factor and in SPL [dB] 
r.DecFactor_MP = r.DecFactor(r.idx);      % factor
r.DecSPL_MP = r.DecSPL(r.idx);            % SPL



% plot
xticksvector =  (0:0.5:6.3);
instr_name = meta.GLOBAL_EmitterShortName;

Boxplot_plot =  figure('visible','off');
hold on
    set(Boxplot_plot,'visible',data.showplot.boxplot);
    plot(r.measuring_points,(r.DecSPL_MP-r.DecSPL_MP(58)),Color='g')
    plot(r.measuring_points,max_lin,Color='r')
    plot(r.measuring_points,min_lin,Color='r')
    %plot(r.measuring_points,(r.DecFactor_MP-r.DecFactor_MP(58)),Color='r')
    %ylim([-0.01 0.1])
    boxplot(normed_data,'PlotStyle',boxplotstyle,'Whisker',WhiskerSize);
    title(['Box Plot Distribution of a ',char(instr_name),' over the entire Register', ' - with ',num2str(formant_nr),' Partials' ]);
    xlabel([newline,'Distance [m] + ',num2str(r.begin),'m'],'FontSize',12)
    ylabel('Distribution [dBr]','FontSize',12)
    set(gca,'XTickLabel',{' '});
    xticks(1:5:64);
    xticklabels(xticksvector);
    
    %xtickangle(90);
hold off

% if strcmp(data.saveplot.boxplot,'true') == 1 
%     
%         path = p.path_boxplot;
% 
%         mkdir(path)
%         figuresdir = path;        
% 
%         filename = fullfile(figuresdir, [p.filename]);  
%         
% 
%         exportgraphics(Boxplot_plot,[filename,'.png'],'Resolution',300);
% 
% end
% 
% disp(['saving Boxplots completed.',newline])
% 
% end

