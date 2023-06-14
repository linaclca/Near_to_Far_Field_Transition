
function [rec, ch] = h5loader(rec)

% load h5 multichannel recording files 

[rec_tracename, rec.path] = uigetfile(['*.h5']); 

if isequal(rec_tracename,0)
   disp('User selected CANCEL. Please choose Measurement File (h5-Format)');
   [rec.tracename, rec.path] = uigetfile('/Volumes/MEASURE/*.h5');
  
   if isequal(rec_tracename,0)
       disp('Aborted - Please start over again by re-running the Code');
   else 
       disp(['User selected measurement file ', fullfile(rec_tracename)]);
   end
   
else
   disp(['User selected measurement file ', fullfile(rec_tracename)]);
end



rec.filepath = [rec.path,rec_tracename];
rec.tracename = erase(rec_tracename,".h5");

% load recording file
rec_file = h5read(rec.filepath,'/time_data');
rec.file = rec_file';

% number of recording channels
ch = size(rec.file,2);

% adjust individual recordings ------------------------------------------
% for Bass - Arco 0 deg fixed
if length(strfind(rec.tracename,'Bass_Arco_0_fix')) == 1
    rec.file = rec.file((1:15329000),:);
end



% for Bass - Arco 90 deg fixed
if length(strfind(rec.tracename,'2021-05-26_17-06-12_Bass_Arco_90_fix')) == 1
    rec.file = rec.file((1:15114200),:);
end

% for Clarinet 0 deg fixed
if length(strfind(rec.tracename,'2021-05-26_14-32-33_Clarinet_0_fix')) == 1
    rec.file = rec.file((1:13910200),:);
end


% for Clarinet 90 deg fixed
if length(strfind(rec.tracename,'2021-05-26_14-40-23_Clarinet_90_fix')) == 1
    rec.file = rec.file((1:14213600),:);
end

% for Clarinet 0 deg
if length(strfind(rec.tracename,'2021-05-26_14-48-20_Clarinet_0')) == 1
    rec.file = rec.file((3529620:17265000),:);
end

% for Flute 0 deg fixed
if length(strfind(rec.tracename,'Flute_0_fix')) == 1
    rec.file = rec.file((1:14836000),:);
end

% for Flute 90 deg fixed
if length(strfind(rec.tracename,'Flute_90_fix')) == 1
    rec.file = rec.file((557000:15374000),:);
end
    
% for Guitar 0 deg fixed
if length(strfind(rec.tracename,'Guitar_0_fix')) == 1
    rec.file = rec.file((1:15200000),:);
end

% for Guitar 90 deg fixed
if length(strfind(rec.tracename,'Guitar_90_fix')) == 1
    rec.file = rec.file((1:15480000),:);
end
    
    
% for sax 90 deg fixed
if length(strfind(rec.tracename,'2021-05-26_13-57-52_Sax_90_fix')) == 1
rec.file = rec.file((5100000:end),:);
end
% for trombone 0 deg fix part 2
if length(strfind(rec.tracename,'2021-05-26_16-08-22_Trombone_0_fix_part2')) == 1
rec.file = rec.file((1:7800000),:);
end

% for trombone 0 deg part 2
if length(strfind(rec.tracename,'2021-05-26_15-52-13_Trombone_0_part2')) == 1
rec.file = rec.file((1:7900000),:);
end

% for trombone 90 deg 
if length(strfind(rec.tracename,'2021-05-26_15-56-23_Trombone_90_fix')) == 1
rec.file = rec.file((1:(end-1593473)),:);
%disp('rec.file too long. Split at x = 12681700, save as part1. Then repeat for part2!');
%split_trb90deg_xvalue = 12681700;
end

% for violin 0 deg fix
if length(strfind(rec.tracename,'2021-05-26_12-15-48_Violin_0_fix')) == 1
rec.file = rec.file((1:15728900),:);
end

% for violin 90 deg fix
if length(strfind(rec.tracename,'Violin_90_fix')) == 1
rec.file = rec.file((1:18000000),:);
end

% for violin 0 deg unfix
if length(strfind(rec.tracename,'Violin_0_unfix')) == 1
%rec.file = rec.file((1:17500000),:);
rec.file = rec.file((234000:17500000),:);
end

end 