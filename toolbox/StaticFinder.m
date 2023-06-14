function [Static] = StaticFinder(pitch, rec, ch, s, Stat, sep, data)

disp('finding stationary signal part of individual notes...')

Static = struct('rec',[]); %,'ons',[]);

for j = 1:pitch.amount
Static(j) = window_time_MULTI(rec, ch, s, Stat, pitch, j, sep, data);
end

disp(['finding stationary signal parts completed', newline])



end