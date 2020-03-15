function plotRoadGrad()
%UNTITLED 画线路坡度
%   此处显示详细说明
    global GRAARRAY SPDLIMARRAY;
    rate=300;
    startPoint=GRAARRAY(1,:);
    gradList=GRAARRAY(2,:)/1000;
    n=length(startPoint);
    x=zeros(1,2*n-2);
    y=zeros(1,2*n-2);
    x(1)=startPoint(1);
    y(1)=gradList(1)*rate;
    for i=1:length(startPoint)-1
        x(2*i)=startPoint(i+1);
        y(2*i)=gradList(i)*rate;
        x(2*i+1)=startPoint(i+1);
        y(2*i+1)=gradList(i+1)*rate;
    end
    x(2*n)=SPDLIMARRAY(1,length(SPDLIMARRAY(1,:)));
    y(2*n)=gradList(n)*rate;
    plot(x,y)
end

