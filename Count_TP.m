function = Count_TP(count, label)
%To get unique devices with time in seconds and power in watts initialized to 0
for i = 1:length(count)
    count(i) = count{i};
end
count = unique(count);
mapObj = containers.Map(count, zeros([1, length(count)]));
mapObj2 = containers.Map(count, zeros([1, length(count)]));

%To calculate time and power based on labels
for i = 1:length(label)
   if ~strcmp(label{i}, 'None')
       mapObj(label{i}) = mapObj(label{i}) + 1;
       mapObj2(label{i}) = mapObj2(label{i}) + X(i, 1) + X(i, 2);
   end
end
save('mapObj.mat','mapObj', 'mapObj2');
clear('mapObj', 'mapObj2');