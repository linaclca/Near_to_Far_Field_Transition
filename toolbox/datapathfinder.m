function [data] = datapathfinder(rec)

% selects path to save results



%if exist(char(rec.tracenameN),'dir') == 7
% disp('result folder already exists. folder name will be incremented')
% rec.tracenameN = [rec.tracenameN,'_01']; 
%end

data = struct;


if strcmp(rec.switch.datapath,'manual') == 1 
    data.path = uiputfile('*.*','File Selection',char(rec.tracename));
    data.path = ['outputData/',char(data.path)];
else if strcmp(rec.switch.datapath,'automatic') == 1 
    data.path = ['outputData/',char(rec.tracename)];
end
    
    
    
if isequal(data.path,0)
   disp('User selected CANCEL. Please choose path to save results');
   data.path = uiputfile('*.*','File Selection',char(rec.tracename));
   
   if isequal(data.path,0)
       disp('Aborted - please startover and re-run code');
   else 
       disp(['result will be saved in folder ', fullfile(data.path), newline]);
   end
   
else
   disp(['result will be saved in folder ', fullfile(data.path), newline]);
end

end