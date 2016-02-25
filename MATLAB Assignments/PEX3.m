
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
rows = dim(1);
columns = dim(2);
sizeCell = [rows , columns];
map = fscanf(file, '%e', sizeCell);
map = map';


fclose(file);

[px, py] = gradient(map,1,1);




