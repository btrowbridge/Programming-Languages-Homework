
%
%MATLAB PEX 3
%
%Bradley Trowbridge
%
%Programming Languages with Dean Bushey
%

filename = 'swiss-alps.txt';
file = fopen(filename,'rt');

if file < 0
    error('Problem opening file %s\n', filename);
end

title = fgetl(file);
dim = fscanf(file,'%i', 2);
sizeCell = [dim(1) dim(2)];
map = fscanf(file, '%e', sizeCell);


fclose(file);
fig = imagesc(map);
colormap(fig,'gray');

function[peaks] = findPeaks(m);
for 
end


