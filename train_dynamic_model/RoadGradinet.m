function grad= RoadGradinet(pos)
%UNTITLED2 道路坡度信息
%返回值：角度
global GRAARRAY
    grad=0;
    startPoint=GRAARRAY(1,:);
    gradList=GRAARRAY(2,:);
    grad=findAt( startPoint,gradList,pos);
end

