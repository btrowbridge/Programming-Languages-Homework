function [pitCoord, pitmap] = findPits(m)
%findPits
%   finds coordinates of peaks discovered from function imregionalmax which
%   returns an array of ones and zeros whether the point is a regional
%   minima or not
pitCoord = [];
pitmap = imregionalmin(m,8);
for i = 2:size(pitmap,1)-1
    for j = 2:size(pitmap,2)-1
        if pitmap(i, j) == 1;
            pitCoord =  vertcat(pitCoord, [j i]);
        end
    end
end
pitCoord = sortrows(pitCoord,1);
        
end

