function value= findAt(keyList,valueList,key)
%UNTITLED ����key�б�value�б���ʾһ����ɢ���ĺ�����������ҳ�ĳ���Ա�����Ӧ��ֵ
%������һ��key��������key�б��ҳ������ֵvalue
%key�б���С��������
% ����ֵ��λ��m/s
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
