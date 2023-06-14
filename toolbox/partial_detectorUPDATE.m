function [meas, Hz, NoteName, Plot, PlotTwo, idx] = partial_detectorUPDATE(Static, ch, s, threshold, pitch, j, instr, data, r, cent, prev_root, mode, window)

meas(1:ch) = struct('pitch',[]);

x = Static(j).rec(:, data.ref_mic);
nx = size(x,1);
na = 2; %??? Reference to smth ???


%choose type of window: Hanning or Blackman Harris

if strcmp(window,'Hanning') == 1 
w = hanning(floor(nx/na));
elseif strcmp(window,'Blackman_Harris') == 1 
w = blackmanharris(floor(nx/na));
end
w_len = length(w);

if strcmp(mode,'Psd') == 1 
   [pxxPsd,f] = pwelch(x,w,w_len*data.overlap,[],s.fs,[],[], 'psd');
elseif strcmp(mode,'Power') == 1 
   [pxxPower,f] = pwelch(x,w,w_len*data.overlap,[],s.fs,[],[], 'power');
end



% DFT amplitude spectrum
spec = fft(x);
% normalize to an amplitude spectrum
spec = spec/nx;
% convert to single-sided spectrum
spec = spec(1:end/2+1);
spec(2:end-1) = 2*spec(2:end-1);
spec_len = length(spec);

% create a frequency axis for the plot in Hz
f_fft = linspace(0, s.fs/2, spec_len).';

x_len = spec_len;



% -------------------------------------------------------------------------
% ROOT FINDER -------------------------------------------------------------

[~, minidx] = min(abs(f_fft-pitch.range(1)));
[~, maxidx] = min(abs(f_fft-pitch.range(2)));

% minimum distance of the peaks, lowest pitch of the instrument or 63 Hz
MinPeakDist_r = minidx -3 ; %pitch.lowest

%  if pitch.instr == 7 && j > 31
 %     threshold.r = -40;
  %end
  
[~,locs_r] = findpeaks(20*log10(abs(spec)),'MinPeakHeight',threshold.r,'MinPeakDistance',MinPeakDist_r);

% only within instrument range
range_r = locs_r > minidx-1 & locs_r  < maxidx +2 ; 
locs_range_r = locs_r(range_r); 
locs_range_r_len = length(locs_range_r);

locs_range_hz = f_fft(locs_range_r);

if j > 1
    
    if prev_root(j-1) > 0 
        % two semitones below previous note
        locs_range_hz_idx_desc =  locs_range_hz < prev_root(j-1) *2^(-35/120);
        % two semitones above previous note
        locs_range_hz_idx_asc =  locs_range_hz < prev_root(j-1) * 2^(35/120);   
    end
    
    locs_range_idx_tmp = locs_range_hz_idx_asc +  locs_range_hz_idx_desc ; 
    locs_range_idx = nonzeros(locs_range_idx_tmp);
    locs_range_idx = (1:length(locs_range_idx));
    
    locs_range_r = locs_range_r(locs_range_idx );
    locs_range_r_len = length(locs_range_r);
end




%locs_range_r_len = length(unique(locs_range_hz_idx_asc .* locs_range_r));

% preallocate
p(1:locs_range_r_len) = struct('values',[],'values_db',[],'Hz',[],'idx_below',[],'idx',[],'idx_above',[]);

p_Hz_possible = zeros(pitch.formants_nr,1);
p_idx_possible = zeros(pitch.formants_nr,1);

% -------------------------------------------------------------------------
% PARTIAL FINDER -------------------------------------------------------------
% ------------------------------------------------------------------------    

% compute possibilites for all detected roots    
for l = 1:locs_range_r_len

    % find index within pitch matrix 
    f0_tmp_idx = locs_range_r(l);
  %[~, f0_tmp_idx] = min(abs(f_fft - f0_tmp_old));
    
    f0_tmp = f_fft(f0_tmp_idx);
    
    
    
    % calculate theoretical partials and their index
    for i = 1:pitch.formants_nr 
        p_Hz_possible(i,1) = f0_tmp *i;
        p_idx_possible(i,1) = f0_tmp * i ;
        % find index within pitch matrix 
        [~,  p_idx_possible(i,1)] = min(abs(f - p_Hz_possible(i,1)));
    end
    
   
    %  conversion to bin size of pwelch
    conv = s.fs/(length(f)-1)/2;
    
    % adjust to width of x cents
    p_idx_possible_below = floor(p_Hz_possible*2^(-(1/12)*(cent/100))/conv);
    p_idx_possible_above = ceil(p_Hz_possible*2^((1/12)*(cent/100))/conv);
    
    % delete values that are too high:
    for i = 1:pitch.formants_nr
        if p_idx_possible_above(i) > length(f)       
            p_idx_possible_above(i) = 1;
            p_idx_possible_below(i) = 1;
        end
    end    
    
    
    
    
    % get values via different mode of calculation
    if cent == 0 
        if strcmp(mode,'Psd') == 1 
            for i = 1:pitch.formants_nr 
                p(l).values(i,1) = pxxPsd(p_idx_possible(i,1)); 
            end
        elseif strcmp(mode,'Power') == 1 
            for i = 1:pitch.formants_nr 
                p(l).values(i,1) = pxxPower(p_idx_possible(i,1)); 
            end
        end
    
    elseif cent > 0 
    
        if strcmp(mode,'Psd') == 1 
            for i = 1:pitch.formants_nr 
                p(l).values(i,1) = sum(pxxPsd(p_idx_possible_below(i,1):p_idx_possible_above(i,1))); 
            end
        elseif strcmp(mode,'Power') == 1 
            for i = 1:pitch.formants_nr 
                p(l).values(i,1) = sum(pxxPower(p_idx_possible_below(i,1):p_idx_possible_above(i,1))); 
            end
        end
    
    end

    p(l).values_db = db(sqrt(2*p(l).values)) +94;
    p(l).Hz = p_Hz_possible;
    p(l).idx = p_idx_possible;
    p(l).idx_below = p_idx_possible_below;
    p(l).idx_above = p_idx_possible_above;
end


% -- Check for most likely root -------------------

% preallocate
p_sum_idx = zeros(locs_range_r_len,1);


% eliminate possibility to mistake octaves for root

valid_check_one = round(locs_range_r ./ locs_range_r(1)) ;

if locs_range_r_len == 1
    f0_idx = 1;

elseif valid_check_one(2) == 2 %&& valid_check_one(3)
   f0_idx = 1  ;
  
   
else

    % find most likely root by strongest integral amplitudes
    for n = 1:locs_range_r_len
        p_sum_idx(n) = sum(p(n).values_db); 
    end


    % index of detected root
    [~,f0_idx] = max(p_sum_idx);

end 

f0 = f_fft(locs_range_r(f0_idx)) ;
[~, f0_name_idx] = min(abs(pitch.pitches(:,1)-f0));
f0_Name = pitch.noteNames(f0_name_idx);

%--------------------------------------------------------------------------
%---------- get values for all channels -----------------------------------
%--------------------------------------------------------------------------

magnitudes = zeros(pitch.formants_nr,1);

for k = 1:ch
    if  strcmp(mode,'Psd') == 1    
        [pxxPsd_ALL,~] = pwelch(Static(j).rec(:,k),w,w_len*data.overlap,[],s.fs,[],[], 'psd');
        
    elseif strcmp(mode,'Power') == 1 
        [pxxPower_ALL,~] = pwelch(Static(j).rec(:,k),w,w_len*data.overlap,[],s.fs,[],[], 'power');
        
    end
    
     % get values via different mode of calculation
     if cent ==0 
         if strcmp(mode,'Psd') == 1 
            for i = 1:pitch.formants_nr 
                magnitudes(i) = pxxPsd_ALL(p(f0_idx).idx(i)); 
            end
        elseif strcmp(mode,'Power') == 1 
            for i = 1:pitch.formants_nr 
                magnitudes(i) = pxxPower_ALL(p(f0_idx).idx(i)); 
            end
        end
         
     elseif cent > 0
        if strcmp(mode,'Psd') == 1 
            for i = 1:pitch.formants_nr 
                [magnitudes(i), mag_idx(i)]  = max(pxxPsd_ALL(p(f0_idx).idx_below(i,1):p(f0_idx).idx_above(i,1))); 
            end
        elseif strcmp(mode,'Power') == 1 
            for i = 1:pitch.formants_nr 
                [magnitudes(i), mag_idx(i)] = max(pxxPower_ALL(p(f0_idx).idx_below(i,1):p(f0_idx).idx_above(i,1))); 
            end
        end
    end

meas(k).pitch.soundpressure = sqrt(2 * magnitudes') ;
meas(k).pitch.formants_meas_Hz_mag = db(sqrt(2 * magnitudes'))+ 94;
end


Hz.formants_meas_Hz = p(f0_idx).Hz;
NoteName = f0_Name;
idx = f0_name_idx;


% -------------------------------------------------------------------------
% PLOT --------------------------------------------------------------------

% ------------------------------------------------------

instr_name = load_instrument_name(pitch);

%---------------------------------------------------------------
    Plot = figure('visible','off');
    set(Plot,'visible',data.showplot.pitch); 
    semilogx(f_fft, 20*log10(abs(spec))+94,'Color','b'); hold on; 
    if cent == 0
       semilogx(f(p(f0_idx).idx),meas(data.ref_mic).pitch.formants_meas_Hz_mag,'*','Color','r'); hold on;    
    elseif cent > 0
       semilogx(f(p(f0_idx).idx_below + (mag_idx'-1)),meas(data.ref_mic).pitch.formants_meas_Hz_mag,'*','Color','r'); hold on;
    end

    if strcmp(mode,'Psd') == 1 
        semilogx(f,db(sqrt(2*pxxPsd))+94,'Color','r'); hold off
        ylabel('PSD (dB/Hz)')
    elseif strcmp(mode,'Power') == 1 
        semilogx(f,db(sqrt(2*pxxPower))+94,'Color','r'); hold off
        ylabel('SPL [dB]')
    end

    xlabel('Frequency (Hz)')
    xlim([20 20000]);
    ylim([0 max(20*log10(abs(spec))+94)+6]);
    grid on;
    title([char(instr_name), ' note ', char(f0_Name) ,' = ', num2str(f0,'%4.2f'), 'Hz with first ',num2str(pitch.formants_nr-1), ' harmonic partials', ' - Distance ',num2str(r.measuring_points(data.ref_mic)),'m']);
    lgd = legend('FFT','Data Values',char(mode),'Location','northeast');



% if chosen channels for pitch detection plots is same
if data.pitchplot_ch == data.ref_mic
    data.ref_mic = data.pitchplot_ch ;
    
    PlotTwo = [];

% if chosen channels for pitch detection plots is different    
else 
    

    
    data.ref_mic = data.pitchplot_ch ;
    
    x = Static(j).rec(:, data.ref_mic);
   % nx = size(x,1);
   % na = 2;

    if strcmp(window,'Hanning') == 1 
        w = hanning(floor(nx/na));
    elseif strcmp(window,'Blackman_Harris') == 1 
        w = blackmanharris(floor(nx/na));
    end

    if strcmp(mode,'Psd') == 1 
       [pxxPsd,f] = pwelch(x,w,w_len*data.overlap,[],s.fs,[],[], 'psd');
    elseif strcmp(mode,'Power') == 1 
       [pxxPower,f] = pwelch(x,w,w_len*data.overlap,[],s.fs,[],[], 'power');
    end
    % DFT amplitude spectrum
    spec = fft(x);
    % normalize to an amplitude spectrum
    spec = spec/nx;
    % convert to single-sided spectrum
    spec = spec(1:end/2+1);
    spec(2:end-1) = 2*spec(2:end-1);
    spec_len = length(spec);

    % create a frequency axis for the plot in Hz
    f_fft = linspace(0, s.fs/2, spec_len).';
    
    PlotTwo = figure('visible','off');
set(PlotTwo,'visible',data.showplot.pitch); 
semilogx(f_fft, 20*log10(abs(spec))+94,'Color','b'); hold on; 
if cent == 0
   semilogx(f(p(f0_idx).idx),meas(data.ref_mic).pitch.formants_meas_Hz_mag,'*','Color','r'); hold on;    
elseif cent > 0
   semilogx(f(p(f0_idx).idx_below + (mag_idx'-1)),meas(data.ref_mic).pitch.formants_meas_Hz_mag,'*','Color','r'); hold on;
end

if strcmp(mode,'Psd') == 1 
    semilogx(f,db(sqrt(2*pxxPsd))+94,'Color','r'); hold off
    ylabel('PSD (dB/Hz)')
elseif strcmp(mode,'Power') == 1 
    semilogx(f,db(sqrt(2*pxxPower))+94,'Color','r'); hold off
    ylabel('SPL [dB]')
end

xlabel('Frequency (Hz)')
xlim([20 20000]);
ylim([0 max(20*log10(abs(spec))+94)+6]);
grid on;
title([char(instr_name), ' note ', char(f0_Name) ,' = ', num2str(f0,'%4.2f'), 'Hz with first ',num2str(pitch.formants_nr-1), ' harmonic partials', ' - Distance ',num2str(r.measuring_points(data.ref_mic)),'m']);
lgd = legend('FFT','Data Values',char(mode),'Location','northeast');



end




end