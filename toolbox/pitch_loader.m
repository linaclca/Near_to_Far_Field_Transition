function [pitch] = pitch_loader(instr,pitch)

pitch.instr_name = load_instrument_name(pitch);



% load instrument data ----------------------------------------------------
if pitch.instr == 1

pitch_lowest = 82 ;
pitch_highest = 988;

elseif pitch.instr == 2
pitch_lowest = 146 ;
pitch_highest = 988;

elseif pitch.instr == 3
pitch_lowest = 41 ;
pitch_highest = 392;

elseif pitch.instr == 4
pitch_lowest = 41 ;
pitch_highest = 392;

elseif pitch.instr == 5
pitch_lowest = 104 ;
pitch_highest = 880;

elseif pitch.instr == 6
pitch_lowest = 44 ;
pitch_highest = 698;

elseif pitch.instr == 7
pitch_lowest = 247 ;
pitch_highest = 3136;

elseif pitch.instr == 8
pitch_lowest = 180;
pitch_highest = 2400;

elseif pitch.instr == 9
pitch_lowest = 196 ;
pitch_highest = 988;




end


%{

%-------------------------------------------------------------------------
% load pitch data from database 41 instruments ---------------------------

pitch.noteNames = x.radiation.noteNames;

% pad in case instrument plays even higher
pad = [{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''};{''}];
pitch.noteNames = [pitch.noteNames; pad];

%pitches = x.radiation.frequencies;

% adjust theoretical frequency table to size of pitch.formants_nr
pitches = zeros(length(x.radiation.frequencies),pitch.formants_nr);

pitches(:,(1:10)) = x.radiation.frequencies ;

% preallocate
multipler = zeros(1,pitch.formants_nr);


for n = 1:pitch.formants_nr
multipler(1,n) = 1.0155*n; 
end

for i = 10:pitch.formants_nr
pitches(:,i) = pitches(:,1) * multipler(i);
end

%}

%Pitch table
A4 = pitch.tuning;
A4_idx = 58;
max_idx = 108;

pitch.formants_nr = 15; %VARIABLE

f = zeros(max_idx,pitch.formants_nr);

for n = 1:pitch.formants_nr
f(A4_idx,n) = A4 * n;
end

for i = 1:A4_idx-1
    f(A4_idx-i,:) = f(A4_idx-i+1,:) * 2^(-1/12); %Welche Formel?
end

for j = A4_idx+1:max_idx
    f(j,:) = f(j-1,:) * 2^(1/12);
end    

pitches = f;
pitch.noteNames = {'C0';'C#0';'D0';'D#0';'E0';'F0';'F#0';'G0';'G#0';'A0';'A#0';'B0';'C1';'C#1';'D1';'D#1';'E1';'F1';'F#1';'G1';'G#1';'A1';'A#1';'B1';'C2';'C#2';'D2';'D#2';'E2';'F2';'F#2';'G2';'G#2';'A2';'A#2';'B2';'C3';'C#3';'D3';'D#3';'E3';'F3';'F#3';'G3';'G#3';'A3';'A#3';'B3';'C4';'C#4';'D4';'D#4';'E4';'F4';'F#4';'G4';'G#4';'A4';'A#4';'B4';'C5';'C#5';'D5';'D#5';'E5';'F5';'F#5';'G5';'G#5';'A5';'A#5';'B5';'C6';'C#6';'D6';'D#6';'E6';'F6';'F#6';'G6';'G#6';'A6';'A#6';'B6';'C7';'C#7';'D7';'D#7';'E7';'F7';'F#7';'G7';'G#7';'A7';'A#7';'B7';'C8';'C#8';'D8';'D#8';'E8';'F8';'F#8';'G8';'G#8';'A8';'A#8';'B8'};


pitch.range = [pitch_lowest * 2^(-1/12), pitch_highest * 2^(1/12)]; 

pitch.lowest = pitch_lowest;
pitch.highest = pitch_highest;





%pitch.instr = instr.nr;

% adjust tuning 
%[~, idx]= min(abs(pitch.tuning - pitches(:,1)));
%pitchesNEW = pitches ./ pitches(idx,1) * pitch.tuning; 

pitch.pitches = pitches;%NEW;

disp(['Measurement of a ', char(pitch.instr_name),' (largest dimension = ',num2str(instr.h(pitch.instr)), 'm)', ' tuned to ', num2str(pitch.tuning), ' Hz', newline]);

end
