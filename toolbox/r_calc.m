function [r, notes] = r_calc(r,notes,instr,ch,pitch,c0)

% theoretical calculation of sound pressure decrease over distance
% p ~ 1/r

%--------------------------------------------------------------------------
% load measuring points and allocate data
r.measLen = length(r.measuring_points);             % must be size of variable 'ch'

% interpolation 
r.interp = (min(r.measuring_points):0.005:max(r.measuring_points));  

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


% 2nd far-field criteria border for the chosen instrument for each frequency 
r.crit = r.factor * instr.h^2 /c0 .* pitch.pitches ;

% check if pitch is withing 2nd far field criteria for each mic
% i measuring mics



for j= 1%:pitch.amount
% preallocate
notes(j).r_crit_valid = zeros(ch,pitch.formants_nr);    
    
    for i= 1:ch

        % k formants
        for k = 1:pitch.formants_nr

            % check if it fulfills 2nd far-field criteria
           % if r.crit(notes(j).meas(i).pitch.idx,k) < r.measuring_points(i)
           % if r.crit(notes(j).idx,k) <  r.measuring_points(i)
            if r.crit <  r.measuring_points(i)
              %  r.crit_validity(i,k) = 1;
              notes(j).r_crit_valid(i,k) = 0;

            % otherwise within near-field
            else
             %   r.crit_validity(i,k) = 0;
             notes(j).r_crit_valid(i,k) = 1;
            end
        end
    end
end


% compare the theoretical factor with the actual factor
% not absolute values but difference is interesting

r.real_val = zeros(ch,pitch.formants_nr);
r.real_theo_compared = zeros(pitch.amount,ch,pitch.formants_nr);
% if far field then r.crit_validity == 1;

% actual decrease in dB
for k = 1%:pitch.amount
    for i = 1:(ch-1)
    tmp = - (notes(k).meas(i).pitch.formants_meas_Hz_mag - notes(k).meas(i+1).pitch.formants_meas_Hz_mag);
    r.real_val(i+1,:) = tmp;
    tmp_compared = (tmp - r.DecSPL_MP(i+1));

    % compare with theoretical decrease in dB
    r.real_theo_compared(k,i+1,:) = (tmp_compared(:,1))'; 
    end
end


end