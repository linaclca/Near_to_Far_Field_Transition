function[tone]=detectTone(filename)
% This function scrapes the tone of a given filename in the conventions
% used in this project.


    if filename(end-6)=='_'
        tone = strcat( filename(end-5), filename(end-4) );
    elseif filename(end-7)=='_'
        tone = strcat(filename(end-6), '#', filename(end-4) );
    elseif filename(end)=='a'
        if filename(end-15)=='_'
            tone = strcat( filename(end-14), filename(end-13) );
        else
            tone = strcat(filename(end-15), '#', filename(end-13) );
        end
    else
        disp("Tone could not be detected from filename.") 
    end

end