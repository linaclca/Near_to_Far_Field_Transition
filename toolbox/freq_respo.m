function freq_respo(freq, dB, p, Name, instrument)

% Devide in 1/3-octaves
j = 1; % counter
for i = 1:4:size(freq,1)
    frequency(j) = freq(i);
    level(1:64,j) = dB(i,:);
    if (frequency(j) == 0) level(1:64,j) = NaN;
    end
    j = j+1;
end

% Plot the frequency responses of the mics at 0.1, 0.2, 0.4, 0.8, 1.6, 3.2
% and 6.4
close all

a = semilogx(frequency(:), level(1,:),'Color','#0072BD');

hold on
b = semilogx(frequency(:), level(2,:),'Color','#D95319');
c = semilogx(frequency(:), level(4,:),'Color','#EDB120');
d = semilogx(frequency(:),level(8,:),'Color','#7E2F8E');
e = semilogx(frequency(:),level(16,:),'Color','#77AC30');
f = semilogx(frequency(:),level(32,:),'Color','#4DBEEE');
g = semilogx(frequency(:),level(64,:),'Color','#A2142F');
grid on

legend([a b c d e f g],{'0.1m' '0.2m' '0.4m' '0.8m' '1.6m' '3.2m' '6.4m'})
ylim([-5 50])
xlim([min(freq)-20 max(freq)+200])
xlabel('Frequency [Hz]')
ylabel('Magnitude [dBr]')
%xticks(10^3)
title({Name,['Frequency response at different microphones']})
filename = [Name,'_',num2str(instrument),'_Freq_Respo.png'];
print(gcf, '-dpng','-loose', '-r600', fullfile(p.to_ResultPlots,'/',Name,'/',filename)); 
hold off


