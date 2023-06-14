function [Static] = window_time_MULTI(rec, ch, s, Stat, pitch, j, sep, data, on)
% Windowing in TIME Domain ------------------------------------------------
% for finding the most stationary part of the signal, after attack

rec_file = rec.file_sep(j,:,:);
rec_file = squeeze(rec_file);
% -------------------------------------------------------------------------
% On-Set Detection for each channel ---------------------------------------

ons_all = AKonsetDetect(rec_file);
on_max = ceil(max(ons_all));

ons = floor(s.meta_data.Stat_Start * s.fs + on_max);

length = ons+floor(Stat.length*s.fs-1);

% preallocate
Static.rec = zeros(Stat.length*s.fs,ch);


Static.rec = rec_file(ons:length,:);



%-------------------------------------------------------------------------
% Plots

%      time_vec_short = (1:s.fs*Stat.length);
%
%        Static.plot = figure('visible',data.showplot.stat);
%        plot(time_vec_short,Static.rec(:,data.ref_mic));
%        title([num2str(s.meta_data.GLOBAL_EmitterShortName),' - Stationary Signal - ', 'Channel ', num2str(data.ref_mic)]); %
%        xlabel('time [ms]');
%        ylabel('Amplitude');
%        xlim([0 Stat.length*s.fs]);
%        xticks(0:0.1*s.fs:Stat.length*s.fs);
%        xticklabels(0:100:Stat.length*1000);
   
end