function plotSpeedLimit()
    %画线路限速
    BrakeLimit=load('BrakeLimit.mat');
    startPoint=BrakeLimit.sLimitCurve;
    speedLimit=BrakeLimit.vLimitCurve;
    n=length(startPoint);
    x=zeros(1,2*n-2);
    y=zeros(1,2*n-2);
    x(1)=startPoint(1);
    y(1)=speedLimit(1);
    for i=1:length(startPoint)-2
        x(2*i)=startPoint(i+1);
        y(2*i)=speedLimit(i);
        x(2*i+1)=startPoint(i+1);
        y(2*i+1)=speedLimit(i+1);
    end   
    x(2*n-2)=startPoint(n);
    y(2*n-2)=speedLimit(n-1);
    
    y = y * 3.6; % 转换成km/h
    plot(x,y)
    hold on;   
end