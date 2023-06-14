clc; clear all; close all
% With this main function the actual analysis is performed. The data that 
% was calculated with and retrieved from c_Analysis_Transition_main.m is
% read from the .mat-file. With this data the equivalent source dimension
% is computed and plotted. Furthermore the distance is plotted over the
% frequency to visualize the far field. And the frequency response of the
% microphones at the distance 0.1, 0.2, 0.4, 0.8, 1.6, 3.2 and 6.4.

addpath(genpath('toolbox'))
addpath(genpath('outputData'))

% Set paths
p.to_output                         = './outputData';
p.to_ResultPlots                    = [p.to_output,'/3_ResultPlots'];
p.to_FarField                       = [p.to_output,'/4_FarFieldData'];

% choose Instrument (in numbers)
prompt = "Choose instrument 1 to 26 from InstrumentsOvervie.txt: ";
instrument = input(prompt); %VARIABLE, choose from InstrumentOverview.txt

% set data per instrument
if instrument == 1 || instrument == 5
    Name = 'Bass';
    Direction =  ' 0 deg';
    Size = '1.16';
    r_begin = 0.035;
elseif instrument == 3
    Name = 'Bass';
    Direction = ' 90 deg';
    Size = '1.16';
    r_begin = 0.18;
elseif instrument == 7 || instrument == 9
    Name = 'Clarinet';
    Direction = ' 0 deg';
    Size = '0.6';
    r_begin = 0.1;
elseif instrument == 8 
    Name = 'Clarine';
    Direction = ' 90 deg';
    Size = '0.6';
    r_begin = 0.06;
elseif instrument == 10 || instrument == 12
    Name = 'Flute';
    Direction = ' 0 deg';
    Size = '0.67';
    r_begin = 0.13;
elseif instrument == 11 
    Name = 'Flute';
    Direction = ' 90 deg';
    Size = '0.67';
    r_begin = 0.13;
elseif instrument == 16 || instrument == 18
    Name = 'Saxophone';
    Direction = ' 0 deg';
    Size = '0.8';
    r_begin = 0.105;
elseif instrument == 17
    Name = 'Saxophone';
    Direction = ' 90 deg';
    Size = '0.8';
    r_begin = 0.06;
elseif instrument == 19 || instrument == 22
    Name = 'Trombone';
    Direction = ' 0 deg';
    Size = '0.22';
    r_begin = 0.02;
elseif instrument == 21
    Name = 'Trombone';
    Direction = ' 90 deg';
    Size = '1.20';
    r_begin = 0.02;
elseif instrument == 24 || instrument == 26
    Name = 'Violin';
    Direction = ' 0 deg';
    Size = '0.35';
    r_begin = 0.13;
elseif instrument == 25
     Name = 'Violin';
     Direction = ' 90 deg';
    Size = '0.35';
    r_begin = 0.15;
end

%load instrument
string1 = [p.to_FarField,'/FarFieldData',Name,'_',num2str(instrument),'.mat'];
data = load(convertCharsToStrings(string1));

%Set values
do_print = 1;
c0 = 343;               % Speed of airborne sound m/s
h = [0.01:0.01:3.5];    % Membrane diameter 1cm bis 3.5m   
freq = data.save_freq;  % Frequencies measured      
r = (data.intersec/10); % Measuring distance in [m]

% take out the frequencies where no intersection was found
for n = 1:size(freq,2)
    if r(n) == 0
       r(n) = nan;
    end
    if isnan(freq(n))
        r(n) = nan;
    end
    if isnan(r(n))
        freq(n) = nan;
    end
end


r = r(~isnan(r));
r = r + r_begin; % Add the distance from the instrument to the first microphone
freq = freq(~isnan(freq));


%%%%% Equivalent Membrane size
%find intersection with theoretical membrane size
Schnitt = zeros(1,size(freq,2));
 for i = 1:size(freq,2)
    f_theo = (r(i)*c0)./(h.^2);
    Schnitt(i) = h(find(f_theo<freq(i),1,"first"));
 end


AvInter = median(Schnitt); % Mean of Intersections to find the equivalent membrane size\
h_theo = AvInter;

% Plot 2 1-dim 
for i = 1
    close all
    AKf(10,15)
    
    a = area(h,f_theo(i,:),'FaceColor',AKcolors('g')); hold on
    set(gca,'Yscale','log') 
    a.FaceAlpha = 0.1;
    
    a1 = fill([h h(end)],[f_theo(i,:) f_theo(i,1)],'r'); hold on
    a1.FaceAlpha = 0.1;

   
    if i>1
        plot(h,f_theo(1,:),'Color','k','LineStyle','--')
        text(1.3,f_theo(1,end), '0.25 m')
    end
    if i>2
        plot(h,f_theo(2,:),'Color','k','LineStyle','--')
        text(1.3,f_theo(2,end), '0.5 m')
    end
     if i>3
        plot(h,f_theo(3,:),'Color','k','LineStyle','--')
        text(1.3,f_theo(3,end), '1 m')
     end
     if i>4
        plot(h,f_theo(4,:),'Color','k',LineStyle','--')
        text(1.3,f_theo(4,end), '3 m')
     end

     
    grid on
    set(gcf,'Color',[1 1 1])
    b = plot(Schnitt,freq,'o');
    ylabel('ƒ in Hz','FontSize',16)
    xlabel('h in m', 'FontSize',16)

    
    title({'Equivalent piston membrane size'},[Name,Direction,', up to ', num2str(max(freq)), ' Hz'])
    set(gca,'YTick',[10 100 1000 10000 20000 100000])
    set(gca,'YTickLabel',{'10','100','1k','10k','20k','100k'},'FontSize',14)
    c = xline(max(Schnitt),'--', 'Color', [.5 .5 .5]);
    d = xline(min(Schnitt),'--', 'Color', [.5 .5 .5]);
    axis([0 3.5 60 5000])

    legend([b a1 a],{'equivalent size','near field','far field'},'FontSize',14)

    AKtightenFigure
    
    filename = ['MembraneComparison_',Name,'_',num2str(instrument),'_aprox.png'];
    if do_print
        print(gcf, '-dpng','-loose', '-r600', fullfile(p.to_ResultPlots,'/',Name,'/',filename));
    end
end


%%%% Far field for instruments
% Fitting data to first polynomial 
P = polyfit(freq,r,1);

y = polyval(P,freq);

h = Size;

% Plot 2 1-dim 
close all
AKf(20,15)
    
freqtmp = freq(1:end);
freqtmp(end+1) = freqtmp(end);
ytmp = y;
ytmp(end+1) = 6.5;

a = area(freq,y,'FaceColor',AKcolors('r')); hold on
set(gca,'Xscale','log')
a.FaceAlpha = 0.2;
  
    
a1 = fill([freqtmp(1,1) freqtmp(1:end,:)],[ytmp(end) ytmp(1:end,:)],AKcolors('g')); hold on
a1.FaceAlpha = 0.2;
 
  
semilogx(freq,r,'b o',freq, y,'k')

grid on
set(gcf,'Color',[1 1 1])
xlabel('ƒ in Hz]')
ylabel('distance in m')

legend({'','',['h = ', num2str(h),' m']})
    
title(Name,{'Obere Gültigkeitsgrenze nach dem Fernfeld-Kriterium 2'})
set(gca,'XTick',[10 100 1000 10000 20000 100000])
set(gca,'XTickLabel',{'10','100','1k','10k','20k','100k'})
ylim([0 6.5])
xlim([freq(1) freq(end)])
  
AKtightenFigure
     
filename = ['Start_FarField_',Name,'_',num2str(instrument),'_aprox.png'];

if do_print
    print(gcf,'-dpng','-loose','-r600',fullfile(p.to_ResultPlots,'/',Name,'/',filename));
end


%Frequency response
freq_respo = freq_respo(data.freq, data.nd, p, Name, instrument);

