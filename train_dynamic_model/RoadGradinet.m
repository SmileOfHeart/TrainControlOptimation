function grad= RoadGradinet(pos)
%UNTITLED2 ��·�¶���Ϣ
%����ֵ���Ƕ�
global GRAARRAY
    grad=0;
    startPoint=GRAARRAY(1,:);
    gradList=GRAARRAY(2,:);
    grad=findAt( startPoint,gradList,pos);
end

