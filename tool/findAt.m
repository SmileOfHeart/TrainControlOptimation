function value= findAt(keyList,valueList,key)
%UNTITLED 给出key列表，value列表，表示一个离散化的函数，想从中找出某个自变量对应的值
%并给出一个key，查找在key列表，找出最近的值value
%key列表按从小到大排列
% 返回值单位：m/s
    low=1;
    high=length(keyList);
    while high-low>1
         i=floor((low+high)/2+0.5);
         if key>keyList(i)
             low=i;
         else
             high=i;
         end
    end
    i=max(floor((low+high)/2-0.5),1);
    value=valueList(i);
end
