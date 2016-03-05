function [xoffset, yoffset] = findLowNhbr(map)
%Find Steepest path
%   uses the gradient in order to find the lowest path
%   if a pit is found, the offset is automatically zero
xoffset = zeros(size(map,2),size(map,1));
yoffset = zeros(size(map,2), size(map,1));
for i = 2:size(map,1)-1
    for j = 2:size(map,2)-1
        [M,J] = min(map(i-1:i+1,j-1:j+1)); % J is the index of which row
        [~,I] = min(M);                    % I is the index to which column 
        switch I
            case 1
                xoffset(j,i) = -1;
            case 2
                xoffset(j,i) = 0;
            case 3
                xoffset(j,i) = 1;
        end
        switch J(I)
            case 1
                yoffset(j,i) = -1;
            case 2
                yoffset(j,i) = 0;
            case 3
                yoffset(j,i) = 1;
        end
            
    end
end
end

