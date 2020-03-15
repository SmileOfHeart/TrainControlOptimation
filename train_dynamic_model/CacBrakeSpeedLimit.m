function CacBrakeSpeedLimit()
    %���㿼���ƶ�����������
    global TRAINWGH SPDLIMARRAY TMSTEPLEN splLeft;
    dt=TMSTEPLEN;
    M=TRAINWGH;
    startPoint=SPDLIMARRAY(1,:);
    speedLimit=SPDLIMARRAY(2,:) /3.6;
    %��ӵ�һ����
    sLimitCurve=[startPoint(1)]; 
    vLimitCurve=[speedLimit(1)];
    options=odeset('events',@odeEventBrake);
    PointStack=Stack();%��ջ
    LimitStack=Stack();
    n=length(startPoint);
    %% ǰn-1������д���
    for i=1:n-1
        if speedLimit(i)>speedLimit(i+1)
            %�������������ٽ���
            PointStack= PointStack.Push(startPoint(i));
            LimitStack=LimitStack.Push(speedLimit(i));
        elseif ~PointStack.IsEmpty()
            %����speedLimit(i+1)�������������Ƿ���Ҫ����ɲ��
            RightP=startPoint(i);%�����յ㣬�ҵ�
            splRight=speedLimit(i);%������
            %% ��ջ���
            sPartCurve=[];
            vPartCurve=[];
            while(~PointStack.IsEmpty())
                [PointStack,LeftP]=PointStack.Pop();
                [LimitStack,splLeft]=LimitStack.Pop(); %������
                %����ɲ������
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
            %ֱ��������ݵ�
            sLimitCurve=[sLimitCurve,startPoint(i),startPoint(i+1)];
            vLimitCurve=[vLimitCurve,speedLimit(i),speedLimit(i)];
        end
    end    
    
    %% ���һ������д���
    RightP=startPoint(n);%�����յ㣬�ҵ�
    splRight=speedLimit(n);%������
    sPartCurve=[];
    vPartCurve=[];
    while(~PointStack.IsEmpty())
        [PointStack,LeftP]=PointStack.Pop();
        [LimitStack,splLeft]=LimitStack.Pop(); %������
        %����ɲ������
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
    h=figure('Name','�����ƶ���������');%���´���
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
     global splLeft %��ʼ��
     value=y-splLeft;
     isterminal=1;
     direction=0;
end
     