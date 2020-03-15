function index= findIndex(valueList,value)
%找出某个值落在那一个区间,返回下界
%valueList值按从小到大排列
low=1;
up=length(valueList);
index=1;
if isempty(valueList)==1
    disp('findIndex:  valueList大小为0')
    return;
end

if value<valueList(low)
    index=0;
    return;
end
if value>valueList(up)
    index=up;
    return;
end
while up-low>1
     index=floor((low+up)/2+0.5);
     if value>valueList(index)
         low=index;
     else
         up=index;
     end
end
index=low;
end

