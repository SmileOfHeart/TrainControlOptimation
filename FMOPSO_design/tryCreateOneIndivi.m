function switchPoint=tryCreateOneIndivi(N)
%尝试产生一个基本可行解   （牵引-巡航-惰行-巡航） -（牵引-巡航-惰行-巡航）-...  -制动
%输入参数：N：可行解包含的工况转换点数量,必须是4*n，n代表基本组合（牵引-巡航-惰行-巡航）重复次数
%参数
global COADIS STARTPOINT  ENDPOINT MinCoastVeo stateTable; %stateTable - 工况转换点对应的工况表
MinCoastDis=COADIS;%最短惰行距离
switchPoint=zeros(1,N);
MaxStep=1;
MinCoastVeo=3;
%添加第一个点
StartPointVeo=0.01;
StartPointLoc=STARTPOINT;%工况开始点
for i=1:N-1
    state=stateTable(i); %当前的工况
    if state==2
        %求解牵引工况终点
        options=odeset('events',@odeEventAcc);
        [S,y]=ode45(@odeAccDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
        len=length(S);
        EndPointLoc=S(len);%S的最后一个点，表示该工况能持续的最远点
        switchPoint(i)=rand()*(EndPointLoc-StartPointLoc)*0.3+StartPointLoc+(EndPointLoc-StartPointLoc)*0.5;%随机惰行转牵引切换点取自上1/2;
        %初始化下一段运行的开始参数
        StartPointLoc=switchPoint(i);
        if len==1
            %出现前后两个点重合，表明之前惰行距离过长，无法进行下一次惰行
            break;
        end                    
        StartPointVeo=findAt(S,y,StartPointLoc);
        if(StartPointVeo<MinCoastVeo)
            break; %惰行速度太小，结束
        end
    elseif state==1
        %巡航工况终点
        options=odeset('events',@odeEventSpeedHold,'MaxStep',MaxStep);
        [S,y]=ode45(@odeSpeedHoldDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
        len=length(S);
        EndPointLoc=S(len);%S的最后一个点，表示该工况能持续的最远点
        switchPoint(i)=rand()*(EndPointLoc-StartPointLoc)*0.3+StartPointLoc;%随机巡航转惰行或切换点取自上0.3;
        StartPointLoc=switchPoint(i);
    elseif state==0
        %惰行工况终点
        options=odeset('events',@odeEventCoastA);
        [S,y]=ode45(@odeCoastDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
        len=length(S);
        EndPointLoc=S(len);%S的最后一个点，表示该工况能持续的最远点
        if(EndPointLoc-StartPointLoc<MinCoastDis)
            break;       %可选惰行长度过短，结束生成
        end
        switchPoint(i)=rand()*(EndPointLoc-StartPointLoc)*2/3+StartPointLoc+MinCoastDis;%随机惰行转牵引切换点取自上2/3;
        StartPointLoc=switchPoint(i);
        StartPointVeo=findAt(S,y,StartPointLoc);
    end
end

%惰行与制动工况切换点
options=odeset('events',@odeEventCoastA,'MaxStep',MaxStep);
[S,y]=ode45(@odeCoastDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
len=length(S);
switchPoint(N)=S(len);%S的最后一个点，表示该工况能持续的最远点
       
end

function [value,isterminal,direction]=odeEventCoastA(S,y)
     global MinCoastVeo;
     value(1)=y-MinCoastVeo;%速度为MinCoastVeo，则停止计算
     value(2)=y-SpeedLimitBrake(S);%超过制动限速，则停止计算
     isterminal(1)=1;
     isterminal(2)=1;
     direction(1)=-1;
     direction(2)=1;
end

function [value,isterminal,direction]=odeEventAcc(S,y)
     value=y-SpeedLimitBrake(S);%超过制动限速，则停止计算
     isterminal=1;
     direction=1;
end

function [value,isterminal,direction]=odeEventSpeedHold(S,y)
     value=y-SpeedLimitBrake(S);%超过制动限速，则停止计算
     isterminal(1)=1;
     direction(1)=1;
end


function dydS=odeSpeedHoldDiffEqu(S,y)
     %巡航工况
     %y=速度
     %global TRAINWGH;
     dydS=0;
     anti=AntiForce(y,S);
     tractionF=TrateForce(y);
     brakeF=BrakeForce(y);
     if anti>0 &&tractionF<anti
        dydS=tractionF-anti;%牵引力不足以克服上坡阻力   
     elseif  brakeF<abs(anti)
        dydS= abs(anti)-brakeF;  %制动力不足以克服下坡下滑力 
     end

end


function dydS=odeAccDiffEqu(S,y)
     %牵引工况
     %y=速度
     global TRAINWGH;
     dydS=1/y*(TrateForce(y)-AntiForce(y,S))/TRAINWGH;
end  


function dydS=odeCoastDiffEqu(S,y)
     %惰行工况
     %y=速度
     global TRAINWGH;
     dydS=1/(y+0.01)*(-1*AntiForce(y,S))/TRAINWGH;
end

            
