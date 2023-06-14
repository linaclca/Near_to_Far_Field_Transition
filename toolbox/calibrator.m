function [obj] = calibrator(obj, calibfile, ch)


fileID = fopen(calibfile);
C = textscan(fileID,'%f %f');
calib =C{1};

% calibrated to 94 dB
calib = 94 - calib;


for i = 1:ch
    obj(i,:) = obj(i,:) + calib(i);
end 

end
