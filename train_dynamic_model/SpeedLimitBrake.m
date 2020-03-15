function vLimit= SpeedLimitBrake(pos)
%UNTITLED 根据最小时间速度曲线求得限速信息
% 返回值单位：m/s
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
    %线性插值法
    if startPoint(high)~=startPoint(low)
        vLimit=(speedLimit(high)-speedLimit(low))*(pos-startPoint(low))/(startPoint(high)-startPoint(low))+speedLimit(low);
    else
        vLimit=speedLimit(low);
    end
end

