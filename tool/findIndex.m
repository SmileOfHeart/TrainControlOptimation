function index= findIndex(valueList,value)
%�ҳ�ĳ��ֵ������һ������,�����½�
%valueListֵ����С��������
low=1;
up=length(valueList);
index=1;
if isempty(valueList)==1
    disp('findIndex:  valueList��СΪ0')
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

