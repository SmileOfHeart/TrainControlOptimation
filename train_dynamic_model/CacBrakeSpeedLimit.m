function CacBrakeSpeedLimit()
    %计算考虑制动的限速曲线
    global TRAINWGH SPDLIMARRAY TMSTEPLEN splLeft;
    dt=TMSTEPLEN;
    M=TRAINWGH;
    startPoint=SPDLIMARRAY(1,:);
    speedLimit=SPDLIMARRAY(2,:) /3.6;
    %添加第一个点
    sLimitCurve=[startPoint(1)]; 
    vLimitCurve=[speedLimit(1)];
    options=odeset('events',@odeEventBrake);
    PointStack=Stack();%堆栈
    LimitStack=Stack();
    n=length(startPoint);
    %% 前n-1个点进行处理
    for i=1:n-1
        if speedLimit(i)>speedLimit(i+1)
            %可能是连续限速降低
            PointStack= PointStack.Push(startPoint(i));
            LimitStack=LimitStack.Push(speedLimit(i));
        elseif ~PointStack.IsEmpty()
            %遇到speedLimit(i+1)限速上升，看是否需要计算刹车
            RightP=startPoint(i);%限速终点，右点
            splRight=speedLimit(i);%右限速
            %% 出栈清空
            sPartCurve=[];
            vPartCurve=[];
            while(~PointStack.IsEmpty())
                [PointStack,LeftP]=PointStack.Pop();
                [LimitStack,splLeft]=LimitStack.Pop(); %左限速
                %反推刹车过程
                 [S,v]=ode45(@odeBrakeDiffEqu,[RightP,LeftP],splRight,options);
                 len=length(S);
                if(S(len)<=LeftP)
                    sPartCurve=[sPartCurve,S'];
                    vPartCurve=[vPartCurve,v'];
                    splRight=v(len);
                else
                    sPartCurve=[sPartCurve,S',LeftP];
                    vPartCurve=[vPartCurve,v',splLeft];            
                    splRight=splLeft;
                end
                RightP=LeftP;
            end
            sLimitCurve=[sLimitCurve,fliplr(sPartCurve),startPoint(i+1)];
            vLimitCurve=[vLimitCurve,fliplr(vPartCurve),speedLimit(i)];          
        else
            %直接添加数据点
            sLimitCurve=[sLimitCurve,startPoint(i),startPoint(i+1)];
            vLimitCurve=[vLimitCurve,speedLimit(i),speedLimit(i)];
        end
    end    
    
    %% 最后一个点进行处理
    RightP=startPoint(n);%限速终点，右点
    splRight=speedLimit(n);%右限速
    sPartCurve=[];
    vPartCurve=[];
    while(~PointStack.IsEmpty())
        [PointStack,LeftP]=PointStack.Pop();
        [LimitStack,splLeft]=LimitStack.Pop(); %左限速
        %反推刹车过程
         [S,v]=ode45(@odeBrakeDiffEqu,[RightP,LeftP],splRight,options);
         len=length(S);
       if(S(len)<=LeftP)
                    sPartCurve=[sPartCurve,S'];
                    vPartCurve=[vPartCurve,v'];
                    splRight=v(len);
       else
                    sPartCurve=[sPartCurve,S',LeftP];
                    vPartCurve=[vPartCurve,v',splLeft];             
                    splRight=splLeft;
        end
        RightP=LeftP;
    end
    sLimitCurve=[sLimitCurve,fliplr(sPartCurve)];
    vLimitCurve=[vLimitCurve,fliplr(vPartCurve)];     
    save('BrakeLimit.mat','sLimitCurve','vLimitCurve');
    h=figure('Name','考虑制动限速曲线');%打开新窗口
    plotSpeedLimit();
    plotRoadGrad();
    hold on;
    plot(sLimitCurve,vLimitCurve,'Marker','o');
end

function dydt=odeBrakeDiffEqu(t,y)
       global TRAINWGH
       dydt=1/(y+0.1)*(-1*BrakeForce(y)-AntiForce(y,t))/TRAINWGH ;
end

function [value,isterminal,direction]=odeEventBrake(t,y)
     global splLeft %起始点
     value=y-splLeft;
     isterminal=1;
     direction=0;
end
     