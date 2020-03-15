function vLimit= RoadSpeedLimit(pos)
%UNTITLED ��ԭʼ��������Ϣ
% ����ֵ��λ��m/s
    global SPDLIMARRAY;
    vLimit=0;
    startPoint=SPDLIMARRAY(1,:);
    speedLimit=SPDLIMARRAY(2,:)/3.6;
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
    i=floor((low+high)/2-0.5);
    vLimit=speedLimit(i);
end
