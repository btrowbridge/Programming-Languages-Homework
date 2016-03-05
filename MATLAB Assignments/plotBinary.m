function [] = plotBinary( binaryMap, spec )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
for i = 2:size(binaryMap,1)-1
    for j = 2:size(binaryMap,2)-1
        if binaryMap(i, j) == 1;
            plot(j,i,spec);
        end
    end
end

end

