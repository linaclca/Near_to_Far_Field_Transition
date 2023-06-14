close all; clear; clc
% This script creates plots for the analysis of the far field. The data is
% read first read from the SOFA-files created with
% b_SOFA_SingleTones_export_main.m. The frequencies and data are then
% sorted, the 12 first fundamental frequencies and their overtones devided 
% in 1/3-octaves are found and all the harmonics are plottet in boxplots. 
% In the last part the boxes are approached with a fitting curve and the 
% intersection of the fitting curve with a 3 dB threshhold is found an 
% saved for the 12 first fundamental frequencies and their partials.

addpath(genpath('toolbox'))
addpath(genpath('outputData'))

do.plot = true;

% Set paths
p.to_output                         = './outputData';
p.to_controlPlots                   = [p.to_output,'/0_ControlPlots'];
p.to_recordings                     = [p.to_output,'/1_Recordings'];
p.to_singleTones                    = [p.to_output,'/2_DirectivitySingleTones'];
p.to_ResultPlots                    = [p.to_output,'/3_ResultPlots'];


% choose Instrument (in numbers)
prompt = "Choose instrument 1 to 26 from InstrumentsOvervie.txt: ";
instrument = input(prompt); %VARIABLE, choose from InstrumentOverview.txt
%instrument = 25; %VARIABLE, choose from InstrumentOverview.txt    Sax = 16
% get MetaData for Room, Emitter and Instrument
s.meta_data = getMetadata(instrument); %choose Instrumen 1 to 26

if instrument == 1 || instrument == 3 || instrument == 5
    Name = 'Bass';
elseif instrument == 7 || instrument == 8 || instrument == 9
    Name = 'Clarinet';
elseif instrument == 10 || instrument == 11 || instrument == 12
    Name = 'Flute';
elseif instrument == 16 || instrument == 17 || instrument == 18
    Name = 'Saxophone';
elseif instrument == 19 || instrument == 21 || instrument == 22
    Name = 'Trombone';
elseif instrument == 24 || instrument == 25 || instrument == 26
    Name = 'Violin';
end

p.to_Folder = [p.to_ResultPlots '/' Name '/' s.meta_data.GLOBAL_EmitterShortName];

if ~exist(p.to_Folder, 'dir')
    mkdir(p.to_Folder)
end

if ~exist(fullfile(p.to_Folder,'1_Absolut'), 'dir')
    mkdir(fullfile(p.to_Folder,'1_Absolut'))
    mkdir(fullfile(p.to_Folder,'2_Norm')) 
    mkdir(fullfile(p.to_Folder,'3_NormAbs')) 
end


%% ---------------------- Renaming data for temporary analysis ------------------------
ch = 58; % amount of microphones

instr.h = s.meta_data.InstrLength; % biggest source dimension of the chosen instrument

% check for input data
p.to_recordings = [p.to_singleTones,'/',s.meta_data.GLOBAL_EmitterShortName];
s.dir = dir(p.to_recordings);
% remove '.' and '..' 
s.data = s.dir(~ismember({s.dir(:).name},{'.','..','.DS_Store'}));

if size(s.dir,1) == 0
    disp(strcat('No input data found, execution stoped'))
    return 
end

freqToSort          = [];
normedTensorToSort  = [];
clearvars normedTensor

ind = 1; % counter
%% loop Notes
for idx_ton = 1 : size(s.data,1)

    %% start analysis
    % load SOFA data 
    obj = SOFAload(fullfile(s.data(idx_ton).folder, s.data(idx_ton).name));

    [f0, ~, ~] = AKmidiConversion(obj.MIDINote,'midiNoteNumber');

    % only consider fundamental frequencies above 75 Hz
    if f0 < 75
        continue
    end

    tmp = 20*log10(squeeze(obj.Data.Real));

    % calibration of measuring microphones
    calibfile = 'inputData/calibration/calib_file_162316.txt';
    tmp = calibrator(tmp, calibfile, ch);

    % discard partials whose amplitude is more than 30 dB to the maxima
    lastIndx = find(tmp(end,:)<(max(tmp(end,:)- 30)),1,"first");
    
    tmp(:,lastIndx:end) = [];
    freq = obj.N(1:lastIndx-1);

    % norm data to the last microphone
    for k = 1:ch
        normedTensor(k,:) = tmp(k,:) - tmp(58,:);
    end

    data.freq{ind}          = freq;
    data.freqCut{ind}       = lastIndx;
    data.tensor{ind}        = tmp';
    data.normedTensor{ind}  = normedTensor';
    data.pitch{ind}         = obj.MIDINote;
    [~,~,data.Note{ind}]    = AKmidiConversion(obj.MIDINote,'midiNoteNumber');

    % sort the frequencies and the SPL data respectively
    freqToSort                  = [freqToSort; freq];
    [freqToSort2,I]             = sort(freqToSort);
    normedTensorToSort          = [normedTensorToSort; normedTensor'];
    normedTensorToSort2         = normedTensorToSort(I,:);

    clearvars normedTensor

    if ind==size(s.data,1)
        break
    end
    ind = ind +1;
end


%%

cellSize = cellfun('size',data.normedTensor,1);

tmp   = nan(12,max(cellSize),58);
freqs = nan(12,max(cellSize));

for i = 1 : 12
    for j = 1 : cellSize(i)
        tmp(i,j,:)    = data.normedTensor{1,i}(j,:);
        freqs(i,j)    = data.freq{1,i}(j);
    end
end

range = (1:size(tmp,1));

lw = 1.2;

norm = tmp;

r.begin = s.meta_data.r_Begin; % distance from instrument to line array

% measuring points 
r.array = [(0:1:51),(53:2:63)];
r.measuring_points = r.begin + r.array;


% load measuring points and allocate data
r.measLen = length(r.measuring_points);             % must be size of variable 'ch'

% interpolation 
r.interp = (min(r.measuring_points):0.05:max(r.measuring_points));  

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

normed_data = norm;
oct_nr = size(norm,1);
formant_nr = size(norm,2);

% compensate wider microphone spacing at the end of the array
normed_data(:,:,64) = normed_data(:,:,58);
normed_data(:,:,63) = NaN([oct_nr, formant_nr,1]);
normed_data(:,:,62) = normed_data(:,:,57);
normed_data(:,:,61) = NaN([oct_nr, formant_nr,1]);
normed_data(:,:,60) = normed_data(:,:,56);
normed_data(:,:,59) = NaN([oct_nr, formant_nr,1]);
normed_data(:,:,58) = normed_data(:,:,55);
normed_data(:,:,57) = NaN([oct_nr, formant_nr,1]);
normed_data(:,:,56) = normed_data(:,:,54);
normed_data(:,:,55) = NaN([oct_nr, formant_nr,1]);
normed_data(:,:,54) = normed_data(:,:,53); 
normed_data(:,:,53) = NaN([oct_nr, formant_nr,1]);

fr = reshape(freqs,[],1);
nd = reshape(normed_data,[],64);

[fr,I] = sort(fr);
ind = ~isnan(fr);
fr = fr(ind);
nd = nd(I,:);
nd = nd(1:size(fr,1),:);

%%  

%amount of loops to plot the first 12 fundamentals and the overtones in
%1/3-octaves
if instrument == 1
    countOver = [1:1:31];
elseif instrument == 3
    countOver = [1:1:30];
elseif instrument == 5
    countOver = [1:1:26];
elseif instrument == 7
    countOver = [1:1:10];
elseif instrument == 8
    countOver = [1:1:10];
elseif instrument == 9
    countOver = [1:1:34];
elseif instrument == 10
    countOver = [1:1:8];
elseif instrument == 11
    countOver = [1:1:21];
elseif instrument == 12
    countOver = [1:1:12];
elseif instrument == 16
    countOver = [1:1:29];
elseif instrument == 17
    countOver = [1:1:21];
elseif instrument == 18
    countOver = [1:1:29];
elseif instrument == 19
    countOver = [1:1:105];
elseif instrument == 21
    countOver = [1:1:53];
elseif instrument == 22
    countOver = [1:1:99];
elseif instrument == 24
    countOver = [1:1:28];
elseif instrument == 25
    countOver = [1:1:29];
elseif instrument == 26
    countOver = [1:1:33];
else  
    print('could not find instrument')
end

%plot on or off
do.plot = 0; % '1' is TRUE, with any other number the data won't be plotted
Norm = 'Distance'; % choose between 'Distance' (1/r) and 
% 'Mikrofon' (interpolation between all microphones at the first fundamental)

%%% Compare data to 1/r-curve
for overton = countOver
    % setting the counters
    if overton == 1 % the first 12 fundamentals
        Overton = -1;
        count = 1:12;
        counter = [1:12;zeros(1,12)];
    else            % for the overtones
        Overton = overton;
        count = 12;
        third = [4 8 12];
        third = repmat(third,size(countOver,2));
        counter = [16:4:size(third,2)*4;4:4:(size(third,2)-3)*4]; %third(1,:)
        k = overton - 1;
    end

    for funda = count
        
        if overton <= 1
            k = funda;
        end

         toPlot = []; % declare matrix for the data of the boxplots 

         % gather the data for the boxplots plot
        if overton == 1
            toPlot(1:funda,:) = nd(1:funda,:);
        elseif overton == max(countOver) 
            toPlot(1:funda,:) = nd(1:funda,:);
            toPlot(1:counter(1,overton-2),:) = nd(1:counter(1,overton-2),:);
            toPlot(end+1,:) = nd(end,:);
        else
            toPlot(1:funda,:) = nd(1:funda,:);
            toPlot(1:counter(1,overton-1),:) = nd(1:counter(1,overton-1),:);
        end
        
        
        if funda == 1
            toPlot = [toPlot;toPlot];
        end

        % plot the box plots
        if do.plot == 1
            close all
            AKf(40,15)
            percent = [10 90]; % 90 percent of the data in the box, 10 in the whiskers
            limit   = 'none';
        
            iosr.statistics.boxPlot(1:64,toPlot,  'percentile', percent,...
                                                'method', 'R-8',...
                                                'showOutliers', false, ...
                                                'showMean', false,...
                                                'limit', limit,...
                                                'groupWidth', 0.6,...
                                                'xSpacing', 'equal',...
                                                'xSeparator', false,...
                                                'showOutliers', false, ...
                                                'scaleWidth', true, ...
                                                'sampleSize', false, ...
                                                'notch', false, ...
                                                'scaleWidth', false,...
                                                'medianColor', [.2 .2 .2],...
                                                'boxcolor',{[.95 .95 .95]}); hold on
        
        
            grid on
            set(gca,'fontsize',14)
            ylabel('SPL in dB]','FontSize',16)
            xlabel('Distance in m','FontSize',16)
            set(gca,'XTickLabel',{' '},'FontSize',14);
            xticks(1:5:64);
            xticklabels((0:0.5:6.3));
            ylim([-5 50])
        
           if overton == max(countOver)
                title({Name,['\rm', data.Note{1},' (',num2str(round(data.freq{1}(1))) ,' Hz) to ',data.Note{funda},...
                   ' (',num2str(round(data.freq{funda}(1))) ,' Hz) and their first ', num2str(floor((Overton/3)+1)),...
                   ' harmonic overtones (up to ',num2str(round(fr(end))),' Hz), N=',num2str(counter(1,k))]}) %num2str(round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1)))))
           else
                 title({Name,['\rm', data.Note{1},' (',num2str(round(data.freq{1}(1))) ,' Hz) to ',data.Note{funda},...
                     ' (',num2str(round(data.freq{funda}(1))) ,' Hz) and their first ', num2str(floor((Overton/3)+1)),...
                     ' harmonic overtones (up to ',num2str(round(fr(counter(1,k)))),' Hz), N=',num2str(counter(1,k))]}) %num2str(round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1)))))
           end
        
           % plot the 1/r-curve (or interpolation curve) together with the box plot
           if strcmp(Norm,'Distance')
               plot(r.measuring_points+.98,(r.DecSPL_MP-r.DecSPL_MP(58)),'color',AKcolors('r'),'LineWidth',lw)
           elseif strcmp(Norm,'Mikrofon')
               x = 1:64;
               xs = x(~isnan(toPlot(1,:)));
               ys = toPlot(1,~isnan(toPlot(1,:)));
               yi = interp1(xs, ys, 1:64, 'Linear');
        
               plot(x,yi,'color',AKcolors('g'),'LineWidth',lw)
           end
        
           AKtightenFigure
        
           % Save the plot
           filename = [Name,'_Abs_',num2str(funda),'note_',num2str(counter(2,k)+funda),'harmonics.png'];
           if do.plot == 1
              print(gcf, '-dpng','-loose', '-r600', fullfile(p.to_Folder,'1_Absolut',filename)); 
           end
        end
    end
end

%%

%plot on or off
do.plot = 0; % '1' is TRUE, with any other number the data won't be plotted
Norm = 'Distance'; % choose between 'Distance' (1/r) and 
% 'Mikrofon' (interpolation between all microphones at the first fundamental)

%%% Norm to 1/r curve (has to be modified still)
for overton = countOver
    % setting the counters
    if overton == 1 % the first 12 fundamentals
        Overton = -1;
        count = 1:12;
        counter = [1:12;zeros(1,12)];
    else            % for the overtones
        Overton = overton;
        count = 12;
        third = [4 8 12];
        third = repmat(third,size(countOver,2));
        counter = [16:4:size(third,2)*4;4:4:(size(third,2)-3)*4]; 
        k = overton - 1;
    end

    for funda = count
        
        if overton <= 1
            k = funda;
        end

         toPlot = []; % declare matrix for the data of the boxplots 

         % gather the data for the boxplots plot
        if overton == 1
            toPlot(1:funda,:) = nd(1:funda,:);
        elseif overton == max(countOver) 
            toPlot(1:funda,:) = nd(1:funda,:);
            toPlot(1:counter(1,overton-2),:) = nd(1:counter(1,overton-2),:);
            toPlot(end+1,:) = nd(end,:);
        else
            toPlot(1:funda,:) = nd(1:funda,:);
            toPlot(1:counter(1,overton-1),:) = nd(1:counter(1,overton-1),:);
        end


        if funda == 1
            toPlot = [toPlot;toPlot];
        end

        % norm the data to the before defined norm (1/r or microphone)
        if strcmp(Norm,'Distance')
            toNorm = (r.DecSPL_MP-r.DecSPL_MP(58));
            Color = 'r';
        elseif strcmp(Norm,'Mikrofon')
            toNorm = squeeze(tmp(1,1,:))'; 
            Color = 'g';
        elseif strcmp(Norm,'Median')
            Color = 'b';
            toNorm = median(squeeze(tmp(1,:,:))); 
        end
        
        % compensate wider microphone spacing at the end of the array
        toNorm(64) = toNorm(58);
        toNorm(63) = NaN;
        toNorm(62) = toNorm(57);
        toNorm(61) = NaN;
        toNorm(60) = toNorm(56);
        toNorm(59) = NaN;
        toNorm(58) = toNorm(55);
        toNorm(57) = NaN;
        toNorm(56) = toNorm(54);
        toNorm(55) = NaN;
        toNorm(54) = toNorm(53); 
        toNorm(53) = NaN;
        
        toPlot(:,1) = nan(size(toPlot,1),1);
        
        toPlot = toPlot - toNorm;
        
        % plot the box plots
        if do.plot == 1
            close all
            AKf(40,15)

            plot(zeros(1,64),'color',AKcolors(Color),'LineWidth',lw);hold on % 1/r-curve (or microphone linear regression)

            percent = [10 90]; % 90 percent of the data in the box, 10 in the whiskers
            limit   = 'none';
        
            iosr.statistics.boxPlot(1:64,toPlot,  'percentile', percent,...
                                                'method', 'R-8',...
                                                'showOutliers', false, ...
                                                'showMean', false,...
                                                'limit', limit,...
                                                'groupWidth', 0.6,...
                                                'xSpacing', 'equal',...
                                                'xSeparator', false,...
                                                'showOutliers', false, ...
                                                'scaleWidth', true, ...
                                                'sampleSize', false, ...
                                                'notch', false, ...
                                                'scaleWidth', false,...
                                                'medianColor', [.2 .2 .2],...
                                                'boxcolor',{[.95 .95 .95]}); hold on
        
        
            grid on
            set(gca,'fontsize',14)
            ylabel('SPL in dB]','FontSize',16)
            xlabel('Distance in m','FontSize',16)
            set(gca,'XTickLabel',{' '},'FontSize',14);
            xticks(1:5:64);
            xticklabels((0:0.5:6.3));
            ylim([-5 50])
        
           if overton == max(countOver)
                title({Name,['\rm', data.Note{1},' (',num2str(round(data.freq{1}(1))) ,' Hz) to ',data.Note{funda},...
                   ' (',num2str(round(data.freq{funda}(1))) ,' Hz) and their first ', num2str(floor((Overton/3)+1)),...
                   ' harmonic overtones (up to ',num2str(round(fr(end))),' Hz), N=',num2str(counter(1,k))]}) %num2str(round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1)))))
           else
                 title({Name,['\rm', data.Note{1},' (',num2str(round(data.freq{1}(1))) ,' Hz) to ',data.Note{funda},...
                     ' (',num2str(round(data.freq{funda}(1))) ,' Hz) and their first ', num2str(floor((Overton/3)+1)),...
                     ' harmonic overtones (up to ',num2str(round(fr(counter(1,k)))),' Hz), N=',num2str(counter(1,k))]}) %num2str(round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1)))))
           end
       
        
           AKtightenFigure
        
           % Save the plot
           filename = [Name,'_Abs_',num2str(funda),'note_',num2str(counter(2,k)+funda),'harmonics.png'];
           if do.plot == 1
              print(gcf, '-dpng','-loose', '-r600', fullfile(p.to_Folder,'1_Absolut',filename)); 
           end
        end
    end
end
%%

%plot on or off
do.plot = 1; % '1' is TRUE, with any other number the data won't be plotted
Norm = 'Distance'; % choose between 'Distance' (1/r) and 
% 'Mikrofon' (interpolation between all microphones at the first fundamental)

for overton = countOver
    % setting the counters
    if overton == 1 % the first 12 fundamentals
        Overton = -1;
        count = 1:12;
        counter = [1:12;zeros(1,12)];
    else            % for the overtones
        count = 12;
        Overton = overton;
        third = [4 8 12];
        third = repmat(third,size(countOver,2));
        counter = [16:4:size(third,2)*4;4:4:(size(third,2)-3)*4]; %third(1,:)
        k = overton - 1;
    end

    for funda = count
        
        if overton <= 1
            k = funda;
        end
        
        toPlot = []; % declare matrix for the data of the boxplots 

        % gather the data for the boxplots plot
        if overton == 1
            toPlot(1:funda,:) = nd(1:funda,:);
        elseif overton == max(countOver) 
            toPlot(1:funda,:) = nd(1:funda,:);
            toPlot(1:counter(1,overton-2),:) = nd(1:counter(1,overton-2),:);
            toPlot(end+1,:) = nd(end,:);
        else
            toPlot(1:funda,:) = nd(1:funda,:);
            toPlot(1:counter(1,overton-1),:) = nd(1:counter(1,overton-1),:);
        end
        
        
        if funda == 1
            toPlot = [toPlot;toPlot];
        end
        
        % norm the data to the before defined norm (1/r or microphone)
        if strcmp(Norm,'Distance')
            toNorm = (r.DecSPL_MP-r.DecSPL_MP(58));
            Color = 'r';
        elseif strcmp(Norm,'Mikrofon')
            toNorm = squeeze(tmp(1,1,:))';
            Color = 'g';
        end
        
        %% compensate wider microphone spacing at the end of the array
        toNorm(64) = toNorm(58);
        toNorm(63) = NaN;
        toNorm(62) = toNorm(57);
        toNorm(61) = NaN;
        toNorm(60) = toNorm(56);
        toNorm(59) = NaN;
        toNorm(58) = toNorm(55);
        toNorm(57) = NaN;
        toNorm(56) = toNorm(54);
        toNorm(55) = NaN;
        toNorm(54) = toNorm(53); 
        toNorm(53) = NaN;
        
        toPlot(:,1) = nan(size(toPlot,1),1);
        
        toPlot = toPlot - toNorm;
        
        toPlot = [toPlot ; toPlot*-1];


        abstoPlot = abs(toPlot(1:size(toPlot,1)/2,:));


        if do.plot == 1
            close all
            AKf(40,15)
        
            plot(zeros(1,58),'color',AKcolors(Color),'LineWidth',lw);hold on
            plot(ones(1,64)*3,'--','color',AKcolors('k'),'LineWidth',.8);
        
            percent = [10 90];
            limit   = 'none';
            h = iosr.statistics.boxPlot(1:64,toPlot,  'percentile', percent,...
                                                'method', 'R-8',...
                                                'showOutliers', false, ...
                                                'showMean', false,...
                                                'limit', limit,...
                                                'groupWidth', 0.6,...
                                                'xSpacing', 'equal',...
                                                'xSeparator', false,...
                                                'showOutliers', false, ...
                                                'scaleWidth', true, ...
                                                'sampleSize', false, ...
                                                'notch', false, ...
                                                'scaleWidth', false,...
                                                'medianColor', [.2 .2 .2],...
                                                'boxcolor',{[.95 .95 .95]}); hold on
        
            grid on
            ylim([-15 15])
            ylabel('SPL [dB]','FontSize',16)
            xlabel('Distance [m]','FontSize',16)
            set(gca,'XTickLabel',{' '},'FontSize',14);
            xticks(1:5:64);
            xticklabels((0:0.5:6.3));
            ylim([0 25])
        
            if overton == max(countOver)
                title({Name,['\rm', data.Note{1},' (',num2str(round(data.freq{1}(1))) ,' Hz) to ',data.Note{funda},...
                        ' (',num2str(round(data.freq{funda}(1))) ,' Hz) and their first ', num2str(floor((Overton/3)+1)),...
                        ' harmonic overtones (up to ',num2str(round(fr(end))),' Hz), N=',num2str(counter(1,k))]}) %num2str(round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1)))))
            else
                title({Name,['\rm', data.Note{1},' (',num2str(round(data.freq{1}(1))) ,' Hz) to ',data.Note{funda},...
                    ' (',num2str(round(data.freq{funda}(1))) ,' Hz) and their first ', num2str(floor((Overton/3)+1)),...
                    ' harmonic overtones (up to ',num2str(round(fr(counter(1,k)))),' Hz), N=',num2str(counter(1,k))]}) %num2str(round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1)))))
            end

        
            dataFit = toPlot;
            %compensate wider microphone spacing at the end of the array
            dataFit(:,53) = toPlot(:,54);
            dataFit(:,54) = toPlot(:,56);
            dataFit(:,55) = toPlot(:,58);
            dataFit(:,56) = toPlot(:,60);
            dataFit(:,57) = toPlot(:,62);
            dataFit(:,58) = toPlot(:,64);
            dataFit(:,59:end) = [];
          
          
            x = 2:57; %set x for the fitting
            y = squeeze(prctile(dataFit(:,2:end-1),percent(2))); % prepare the y data for the fitting

 
            %Fit: 'Costumized Power Fitting'.
            [xData, yData] = prepareCurveData( x, y );

            %Set up fittype and options.
            ft = fittype( 'a*(x-d)^b+c', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [-Inf -Inf -0.01 -50];
            opts.StartPoint = [0.743132468124916 0.392227019534168 0.655477890177557 0.171186687811562];
            opts.Upper = [Inf Inf 4 1.9];

            %Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );

                      
            % Find the intersection of the fitting curve with the 3 dB threshold
            if overton == 1
                save_freq(funda) = round(max(freqs(1:counter(1,k),round(((overton-1)/3)+1))));
                for x = 0.1:0.01:64
                    if round(fitresult(x),3) < 3.0
                        intersec(funda) = x;
                        break
                    end
                end
            else
                if overton == max(countOver)
                    save_freq(end+1) = round(fr(end));
                else
                    save_freq(overton+11) = round(fr(counter(1,k)));
                end
                for x = 0.1:0.01:64
                    if round(fitresult(x),2) == 3.0
                        intersec(overton+11) = x; 
                    end
                end
            end

            % Plot the fitting curve
            x = 0.1:0.1:64;
            a = plot(x,fitresult(x), 'b');
        
            % Plot the 3 dB Threshold
            if overton == 1
                xline(intersec(funda),'--', 'Color', [.5 .5 .5])
                % Fill the area in the near field red and in the far field green
                a1 = [0 intersec(funda) intersec(funda) 0];
                a2 = [65 intersec(funda) intersec(funda) 65];
            else
                xline(intersec(overton+11),'--', 'Color', [.5 .5 .5])
                % Fill the area in the near field red and in the far field green
                a1 = [0 intersec(overton+11) intersec(overton+11) 0];
                a2 = [65 intersec(overton+11) intersec(overton+11) 65];
            end

            
            l = [0 0 25 25];
            b = fill(a1,l,'r','FaceAlpha',0.1);
            c = fill(a2,l,AKcolors('g'),'FaceAlpha',0.1);
        
            legend([a b c],{'Fitting', 'near field', 'far field'},'FontSize',14)
        
            AKtightenFigure
        
            filename = [Name,'_Norm_',num2str(funda),'note_',num2str(counter(2,k)+funda),'harmonics_with_Fitting_test.png']; %
            if do.plot == 1
                print(gcf, '-dpng','-loose', '-r600', fullfile(p.to_Folder,'3_NormAbs/',filename)); 
            end
        end
     end
end
% 
 
% Save the intersection points in a .mat file
mkdir(fullfile(p.to_output,'4_FarFieldData'));

Filename = ['FarFieldData',Name,'_',num2str(instrument),'.mat'];
save([p.to_output,'/4_FarFieldData/',Filename],"save_freq","intersec", "freq","nd")
