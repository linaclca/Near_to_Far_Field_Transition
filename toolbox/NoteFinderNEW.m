function [notes, pitch] = NoteFinderNEW(rec, pitch, ch, Static, s, threshold, data, sep, instr, r, cent, mode, window)



% preallocate struct
notes = struct('meas',[],'Hz',[],'NoteName',[],'plot',[], 'plotTwo',[],'idx',[],'r_crit_valid',[]);
prev_root = zeros(pitch.amount,1);

for j = 1:pitch.amount

[notes(j).meas, notes(j).Hz, notes(j).NoteName, notes(j).plot, notes(j).plotTwo, notes(j).idx] = partial_detectorUPDATE(Static, ch, s, threshold, pitch, j, instr, data, r, cent, prev_root, mode, window);

prev_root(j) = notes(j).Hz.formants_meas_Hz(1);

displayPitch(pitch, notes(j))

end

disp(['--------------------------------------',newline,pitch.instr_name,' played ',char(string(pitch.amount)),' separate notes in total.', newline]);


% ------------------------------------------- 6c. Static Signal & Pitch Detection Plots


% Plots -----------------------------

% don't save plots
if strcmp(data.saveplot.stat,'false') == 1 
   disp(['NOT saved: Stationary Signal Plots',newline])
end
if strcmp(data.saveplot.pitch,'false') == 1 
   disp(['NOT saved: Spectral Plots',newline]);
end




% save plots
if strcmp(data.saveplot.stat,'true') == 1 
   disp('saving Plots of Stationary Signals...')
end
if strcmp(data.saveplot.pitch,'true') == 1 
   disp(['saving Spectral Plots of Pitch Detection...', newline]);
end


for j = 1:pitch.amount
plot_StaticSignal(data, notes(j), ch, Static(j), pitch)
plot_PitchDetection(data, notes(j), ch, pitch)
end

if strcmp(data.saveplot.stat,'true') == 1 
   disp('saving Plots of Stationary Signals completed.')
end
if strcmp(data.saveplot.pitch,'true') == 1 
   disp(['saving Spectral Plots completed.', newline]);
end


% calibration of measuring microphones
calibfile = 'inputData/calibration/calib_file_162316.txt';
notes = calibrator(notes, calibfile, ch, pitch);


for i = 1:pitch.amount
   if isempty(notes(i).NoteName{:}) == 1
       notes(i) = [];
   end
  pitch.amount = size(notes,2);

end    



end