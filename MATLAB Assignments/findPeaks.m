function [peakCoord,peakmap] = findPeaks(m)
%findPeaks 
%   finds coordinates of peaks discovered from function imregionalmax which
%   returns an array of ones and zeros whether the point is a regional
%   maxima or not
peakCoord = [];
peakmap = imregionalmax(m,8);
for i = 2:size(peakmap,1)-1
    for j = 2:size(peakmap,2)-1
        if peakmap(i, j) == 1;
            peakCoord = vertcat(peakCoord, [j i]);
        end
    end
end
peakCoord = sortrows(peakCoord,1);
        
end
