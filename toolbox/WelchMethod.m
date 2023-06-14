function[Ps, freqCommon] = WelchMethod(obj, d, s, played_note, tuning)

t=linspace(0,length(obs)/s.fs,length(obs));
% Read stationary part

        ons_all = AKonsetDetect(rec_file);
        on_max = ceil(max(ons_all));

        ons = floor(Stat.start * s.fs + on_max);

       length_stat = ons+floor(Stat.length*s.fs-1);

        % preallocate
        Static.rec = zeros(Stat.length*s.fs,ch);

    
        Static.rec = note(ons:length,:);

        % DFT amplitude spectrum
        spec = fft(Static.rec); % via CPU
    
        % normalize to an amplitude spectrum
        spec = spec./length(Static.rec);

        % convert to single-sided spectrum
        if ~mod(size(Static.rec,1),2) % if even
            spec = spec(1:end/2+1,:);
            spec(2:end-1,:) = 2*spec(2:end-1,:);
        else % if odd: all bins other than k=0 have to be multiplied with 2.
            spec = spec(1:ceil(end/2),:);
            spec(2:end,:) = 2*spec(2:end,:);
        end

        % create a frequency axis for the plot in Hz
        freqVector = linspace(0, s.fs/2, size(spec,1)).';

        %% calc fundamental f_0 in Hz
        f_0 = AKmidiConversion(played_note, 'midiNoteNumber', tuning);
        harmonics_max = floor(20e3/f_0);
       
        % set bandwith in cent
        cent = 100;

        % init 
        freqCommon = zeros(5,1);

        for ind_harmonic = 1:5

            if ind_harmonic == 1
                harmonic    = f_0;
            elseif ind_harmonic == 2
                harmonic    = freqCommon(ind_harmonic-1)*2;
            else
                harmonic    = freqCommon(ind_harmonic-1)*2 - freqCommon(ind_harmonic-2);
            end

            tmp = spec;
           
            % select bandwidth 
            tmp(1:find(freqVector<=harmonic*2^(-cent/1200),1,'last')-1,:) = 0; 
            tmp(find(freqVector>=harmonic*2^(cent/1200),1,'first')+1:end,:) = 0;
        
            % find most common frquency
            [~,I] = max(abs(tmp));
            freqCommon(ind_harmonic) = mode(freqVector(I));
        end

        % linear regression over the first 5 partial tones
        n = 1:1:5;
        p = polyfit(n,freqCommon,1); 
    
        % polynomial evaluation up to harmonics_max (fs/2) 
        n = 1:1:harmonics_max;
        freqControl = polyval(p,n);

        % init 
        ind_harmonic = 1;
        deviationCent = zeros(harmonics_max,1);
        freqCommon = zeros(harmonics_max,1);

        % set bandwith in cent
        cent = 10;

        while  deviationCent(ind_harmonic) < cent

            if ind_harmonic == 1
                harmonic = freqControl(ind_harmonic);
            elseif ind_harmonic == 2
                harmonic    = freqCommon(ind_harmonic-1)*2;
            else
                harmonic = freqCommon(ind_harmonic-1)*2 - freqCommon(ind_harmonic-2);
            end
            tmp = spec;
            % select bandwidth 
            tmp(1:find(freqVector<=harmonic*2^(-cent/1200),1,'last')-1,:) = 0; 
            tmp(find(freqVector>=harmonic*2^(cent/1200),1,'first')+1:end,:) = 0;
        
            % find most common frquency
            [~,I] = max(abs(tmp));
            freqCommon(ind_harmonic) = mode(freqVector(I));
    
            % calc deviation in cent
            deviationCent(ind_harmonic+1) = abs(1200*log2(freqCommon(ind_harmonic)/freqControl(ind_harmonic)));

            ind_harmonic = ind_harmonic +1;

            if ind_harmonic > harmonics_max
                allHarmonics = true;
                break
            else
                allHarmonics = false;
            end
        end


        if ~allHarmonics
            harmonics_extrapol  = ind_harmonic-1;
        else
            harmonics_extrapol = ind_harmonic;
        end

        freqCommon(ind_harmonic-1:end) = freqControl(ind_harmonic-1:end);

        nx = size(Static.rec,1);
        na = 8;
        w = hanning(floor(nx/na));
        % w = blackmanharris(floor(nx/na));
        nfft = max(256,2^nextpow2(length(w)));
        [pxxPsd,f] = pwelch(Static.rec,w,[],nfft,s.fs,[],[], 'psd');

        % Calculate the spectrum parameters
        fbin = f(2)-f(1);
        cent = 3;

        % Init Ps
        Ps = zeros(harmonics_max, size(Static.rec,2));

        for ind_harmonic = 1:harmonics_max-1
            % select bandwidth 
            itmp = (find(f<=freqCommon(ind_harmonic)*2^(-cent/1200),1,'last'):find(f>=freqCommon(ind_harmonic)*2^(cent/1200),1,'first'))';
            Ps(ind_harmonic,:) = sqrt(sum(2*(pxxPsd(itmp,:)).*fbin));
        end

        if d.verbose
            close all
            AKf(30,20)
            subplot(2,1,1)
            h1 = semilogx(freqVector,db(abs(spec(:,4)))); hold on
            h2 = semilogx(f,10*log10(pxxPsd(:,4)), 'Color', AKcolors('r'),'LineWidth', 1.5); hold on
            %xline(freqCommon(:)*2^(-cent/1200), '--', 'Color', [.5 .5 .5]);
            %xline(freqCommon(:)*2^(cent/1200), '--', 'Color', [.5 .5 .5]);
            plot(freqCommon(:),20*log10(Ps(:,4)), 'k*')

            xlabel('f in Hz')
            ylabel('in dB')
            xlim([20 20000]);
            ylim([20*log10(max(Ps(:)))-85 20*log10(max(Ps(:)))+5]);
            grid on;
            %title([obj.GLOBAL_SourceType,' ',obj.GLOBAL_Description(end-1:end),' MIDI Nr. ',...
               % num2str(obj.MIDINote),' (', num2str(round(AKmidiConversion(obj.MIDINote,'midiNoteNumber'))),' Hz)'])
            legend( [h1 h2], {'fft', 'psd'})

            subplot(2,1,2)
            plot(freqCommon'); hold on
            plot(freqCommon','.')
            plot([harmonics_extrapol:harmonics_max], freqControl(harmonics_extrapol:end),'r-')

            xlabel('n harmonics')
            ylabel('f in Hz')
            grid on;
            AKtightenFigure 
        end
end
