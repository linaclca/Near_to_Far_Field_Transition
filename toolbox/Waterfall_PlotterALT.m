function [] = Waterfall_PlotterALT(data, notes, ch, r, pitch, degree)


% don't save plots
if strcmp(data.saveplot.water,'false') == 1 
    
    disp(['NOT saved: Waterfall Diagrams',newline])
end


% save plots
if strcmp(data.saveplot.water,'true') == 1 
    
    disp('saving Waterfall diagrams...')
end
    
for k = 1:pitch.amount
    %plot_WaterfallALT(data, notes, ch, r, pitch, k, rec, Static, instr);
    plot_WaterfallALT(data, notes, ch, r, pitch, k, degree);
end

if strcmp(data.saveplot.water,'true') == 1 
    
    disp(['saving Waterfall Diagrams completed.',newline])
end

end