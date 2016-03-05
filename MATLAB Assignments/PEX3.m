
%
%MATLAB PEX 3
%
%Bradley Trowbridge
%
%Programming Languages 
%Dean Bushey
%

%load file
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

%process file data
[pits, pitmap] = findPits(map);
[peaks, peakmap] = findPeaks(map);

[xoffset, yoffset] = findLowNhbr(map);



% peak/pit plot
figure
imagesc(map);
colormap(gray);

hold on
plotBinary(peakmap, 'gx');
plotBinary(pitmap, 'ro');
hold off


% plot raindrop
figure
imagesc(map);
colormap(gray);
hold on
[x,y] = ginput(1);

pathVector = [];
step = 0;
x = round(x);
y = round(y);
while (xoffset(x,y) ~= 0 || yoffset(x,y) ~= 0) && step <=6000
    x = x + xoffset(x,y);
    y = y + yoffset(x,y);
    %plot(x,y, 'c*');
    pathVector = vertcat(pathVector,[x y]);
    step = step + 1;
end
plot(pathVector(:,1),pathVector(:,2),'LineWidth', 2);
hold off
