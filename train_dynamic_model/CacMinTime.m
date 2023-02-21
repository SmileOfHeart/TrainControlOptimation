function [E,t]=CacMinTime()
%������С����ʱ��,�����Ϊ�ƶ��������ߵĲο�
%����ֵ���ܺĺ�ʱ��
global TRAINWGH STARTPOINT ENDPOINT EMAX  TMSTEPLEN Tmin Tmax;
dt=TMSTEPLEN;
dv=0.6; %�����ٶ����
M=TRAINWGH;
%��ӵ�һ����
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
    vLimit = min(SpeedLimitBrake(S+v*dt) - 0.3,vLimit);%������Ҫ��v*dt;
    if v<vLimit-dv
        %�������������֮��
        Fa=TrateForce(v);
        acc=(Fa-AntiForce(v,S))/M;
        v=v+acc*dt;
        E=E+Fa*(vCurve(length(vCurve))+v)/2*dt;
        Force=[Force,Fa];
        Jerk=Jerk+abs(acc);
    elseif v>vLimit-dv&&v<vLimit-0.3
        %������������Χ��,������������
        Fanti=AntiForce(v,S);
        if(TrateForce(v)<Fanti)
            %���£���������ǣ����
            Fa=TrateForce(v);
            acc=(Fa-Fanti)/M;
            E=E+Fa*(vCurve(length(vCurve))+v)/2*dt;
            Force=[Force,Fa];
            Jerk=Jerk+abs(acc);
        elseif(Fanti>0) 
            %���£����Ա�������
            acc=0;%���ǣ�����ܹ����г�������Ѳ��״̬
            E=E+abs(Fanti)*(vCurve(length(vCurve))+v)/2*dt;
            Force=[Force,abs(Fanti)];
        elseif(abs(Fanti)<BrakeForce(v))
            %���£����Ա�������
            acc=0;
            Force=[Force,0];
        elseif(abs(Fanti)>BrakeForce(v))
            %���£����ܹ��ƶ���������
            acc=(-1*BrakeForce(v)-Fanti)/M;
            Force=[Force,0];
            Jerk=Jerk+abs(acc);
        end
        v=v+acc*dt;
    elseif(v>=vLimit-0.2)
        %�Ӵ����ƶ����ߣ������ƶ�
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
h=figure('Name','�����ƶ���С����ʱ��');%���´���
plotSpeedLimit();
plotRoadGrad();
hold on;
vCurve = vCurve * 3.6 ; %ת����km/h
plot(sCurve,vCurve,'Marker','o');
xlabel('��ʻ����(m)');
ylabel('��ʻ�ٶ�(km/h)');
end