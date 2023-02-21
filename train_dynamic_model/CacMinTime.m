function [E,t]=CacMinTime()
%计算最小运行时间,结果作为制动限速曲线的参考
%返回值：能耗和时间
global TRAINWGH STARTPOINT ENDPOINT EMAX  TMSTEPLEN Tmin Tmax;
dt=TMSTEPLEN;
dv=0.6; %允许速度误差
M=TRAINWGH;
%添加第一个点
sCurve=[STARTPOINT]; 
vCurve=[0];
ECurve=[0];
S=STARTPOINT;
v=0.01;
t=0;
E=0;
Force=[0];
Jerk=0;
while(S<ENDPOINT&&v>0)
    vLimit = sqrt(2 * (ENDPOINT - S) * 0.8);
    vLimit = min(SpeedLimitBrake(S+v*dt) - 0.3,vLimit);%采样误差，要加v*dt;
    if v<vLimit-dv
        %在限速曲线误差之下
        Fa=TrateForce(v);
        acc=(Fa-AntiForce(v,S))/M;
        v=v+acc*dt;
        E=E+Fa*(vCurve(length(vCurve))+v)/2*dt;
        Force=[Force,Fa];
        Jerk=Jerk+abs(acc);
    elseif v>vLimit-dv&&v<vLimit-0.3
        %在限速曲线误差范围内,尽量保持匀速
        Fanti=AntiForce(v,S);
        if(TrateForce(v)<Fanti)
            %上坡，阻力大于牵引力
            Fa=TrateForce(v);
            acc=(Fa-Fanti)/M;
            E=E+Fa*(vCurve(length(vCurve))+v)/2*dt;
            Force=[Force,Fa];
            Jerk=Jerk+abs(acc);
        elseif(Fanti>0) 
            %上坡，可以保持匀速
            acc=0;%如果牵引力能够将列车保持在巡航状态
            E=E+abs(Fanti)*(vCurve(length(vCurve))+v)/2*dt;
            Force=[Force,abs(Fanti)];
        elseif(abs(Fanti)<BrakeForce(v))
            %下坡，可以保持匀速
            acc=0;
            Force=[Force,0];
        elseif(abs(Fanti)>BrakeForce(v))
            %下坡，不能够制动保持匀速
            acc=(-1*BrakeForce(v)-Fanti)/M;
            Force=[Force,0];
            Jerk=Jerk+abs(acc);
        end
        v=v+acc*dt;
    elseif(v>=vLimit-0.2)
        %接触到制动曲线，进行制动
        acc=(-1*BrakeForce(v)-AntiForce(v,S))/M;
        v=v+acc*dt;
        %E=E+BrakeForce(v)*(vCurve(length(vCurve))+v)/2*dt;
        Force=[Force,0];
        Jerk=Jerk+abs(acc);
    end
    vCurve=[vCurve,v];
    S=S+(vCurve(length(vCurve)-1)+v)/2*dt;
    sCurve=[sCurve,S];
    ECurve=[ECurve,E];
    t=t+dt;
end 
EMAX=E;
Tmin=t;
Tmax=1.5*Tmin;
h=figure('Name','考虑制动最小运行时间');%打开新窗口
plotSpeedLimit();
plotRoadGrad();
hold on;
vCurve = vCurve * 3.6 ; %转换成km/h
plot(sCurve,vCurve,'Marker','o');
xlabel('行驶距离(m)');
ylabel('行驶速度(km/h)');
end