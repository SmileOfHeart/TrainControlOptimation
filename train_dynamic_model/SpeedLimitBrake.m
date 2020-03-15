function vLimit= SpeedLimitBrake(pos)
%UNTITLED ������Сʱ���ٶ��������������Ϣ
% ����ֵ��λ��m/s
    BrakeLimit=load('BrakeLimit.mat');
    startPoint=BrakeLimit.sLimitCurve;
    speedLimit=BrakeLimit.vLimitCurve;
    low=1;
    high=length(startPoint);
    while high-low>1
         i=floor((low+high)/2+0.5);
         if pos>startPoint(i)
             low=i;
         else
             high=i;
         end
    end
    %���Բ�ֵ��
    if startPoint(high)~=startPoint(low)
        vLimit=(speedLimit(high)-speedLimit(low))*(pos-startPoint(low))/(startPoint(high)-startPoint(low))+speedLimit(low);
    else
        vLimit=speedLimit(low);
    end
end

