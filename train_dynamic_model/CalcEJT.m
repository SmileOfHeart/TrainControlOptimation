function [flag,Energy,Time,MissError,overSpeed,switchPoint,Jerk,CoastSpeedDecRate] = CalcEJT(switchPoint,optional)
%UNTITLED4 计算一组工况转换点的能耗和时间 冲击率  停车误差   累计超速 。 判断是否符合约束
%输入
%switchPoint：转换点的数量
%optional：选项    0:仅判断是否符合约束 1:输出曲线 
% 返回值
%Energy,Time,MissError,overSpeed Jerk CoastSpeedDecRate
%能耗  时间  冲击率  停车误差   累计超速 舒适度  惰行最低速度和最高速度的比率
%返回值：flag 测试结果： 0：代表符合约束；1：惰行距离过长； 2:终点速度不为0; 3:上下限不符合约束 4：惰行距离过小 5:提前停车
global STARTPOINT ENDPOINT TRAINWGH COADIS minVeo stateTable ReGenRate COMFACC TMSTEPLEN; %stateTable - 工况转换点对应的工况表
%ReGenRate是再生制动率
ReGenRate=0;
minVeo=3;                                    %中间段允许的最小速度
maxVeo=10;                                   %终点处允许的最大速度
n = length(switchPoint);                     %工况转换点数量
%中间结果
CurrLoc = STARTPOINT;                         %当前位置
CurrVeo =0;                               %当前速度
CurrTime=0;
overSpeed=0;                                 %累计超速
Energy=0;
acc=0.6;
power=0;                                     %功率
ReGenEnery=0;                                %再生制动回收的能耗
state=2;              %工况
%EnergyRecord=[CurrEnergy];
%初始化输出变量，防止报错
flag = 0;                                    %惰行控制点的判断，有效返回1，无效返回0
Time=0;
MissError=0;
Jerk=0;                                       %运行的舒适度
dadt=COMFACC;                             %加速度变化率
%统计变量7个
stateList=[2];                                %运行时工况
EnergyRecord=[Energy];        
ReGenERecord=[ReGenEnery]; 
PowerRecord=[power];
AccRecord=[acc];
veoRecord=[CurrVeo];
locRecord=[CurrLoc];
timeRecord=[CurrTime];
%% 边界调整
for index=1:n
    if switchPoint(index)<STARTPOINT||switchPoint(index)>=ENDPOINT
        %检查解的上下界    
        flag=3;
        return;
    end
end
for index=2:n
    %判断某一段工况是否太短
    if switchPoint(index)-switchPoint(index-1)<COADIS
        flag=4;
        return;
    end 
end



%% 仿真初值
%线性多步法的初值,5步法
dt=TMSTEPLEN;  %仿真步长
for i=1:4
    CurrVeo=CurrTime*dt;
    dS=0.5*acc*CurrTime^2;
    CurrLoc= CurrLoc+dS;
    power=TrateForce(CurrVeo)*CurrVeo;
    Energy=TrateForce(CurrVeo)*dS;   %能耗近似，忽略转折衔接那一块
    %统计变量7个
    stateList=[stateList,state];
    EnergyRecord=[EnergyRecord,Energy];
    PowerRecord=[PowerRecord,power];
    ReGenERecord=[ReGenERecord,ReGenEnery];   
    veoRecord=[veoRecord,CurrVeo];
    locRecord=[locRecord,CurrLoc];
    AccRecord=[AccRecord,acc];
    CurrTime=CurrTime+dt;
    timeRecord =[timeRecord,CurrTime];
end


%% 出发行驶
for index=1:n
    state=stateTable(index); %当前的工况    
    if(state==2)
          %牵引工况
          dt=TMSTEPLEN;  %仿真步长
          while(CurrLoc<switchPoint(index)) 
                targetAcc=(TrateForce(CurrVeo)-AntiForce(CurrVeo,CurrLoc))/TRAINWGH; 
                lastAcc=acc;
                if(abs(targetAcc-acc)>dadt*dt)
                    %转折处后采用低精度线性多步法求解
                    acc=sign(targetAcc-acc)*dadt*dt+acc;
                else
                    dt=10*TMSTEPLEN;  %仿真步长
                    acc=targetAcc; 
                end
                CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
                CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
                power=max(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH,0)*CurrVeo;
                Energy=Adams4(Energy,power,PowerRecord,dt);  %能耗近似，忽略转折衔接那一块
                Jerk=Jerk+abs(lastAcc-acc);
                overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0);
                %%统计变量7个
                stateList=[stateList,state];  
                EnergyRecord=[EnergyRecord,Energy];
                ReGenERecord=[ReGenERecord,ReGenEnery];   
                veoRecord=[veoRecord,CurrVeo];
                PowerRecord=[PowerRecord,power];
                locRecord=[locRecord,CurrLoc];
                AccRecord=[AccRecord,acc];
                CurrTime=CurrTime+dt;
                timeRecord =[timeRecord,CurrTime];
%                 if(SpeedLimitBrake(CurrLoc)<CurrVeo)
%                     switchPoint(index)=CurrLoc; %唯一保留的修正项
%                 end
          end
      elseif (state==1)
          %巡航工况 
          dt=TMSTEPLEN;  %仿真步长
          targetAcc=0;
          while(CurrLoc<switchPoint(index)) 
                lastAcc=acc;
                if(abs(targetAcc-acc)>dadt*dt)
                    acc=sign(targetAcc-acc)*dadt*dt+acc;
                else
                    dt=10*TMSTEPLEN;  %仿真步长
                    acc=targetAcc;
                end
                CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
                CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
                power=max(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH,0)*CurrVeo;
                Energy=Adams4(Energy,power,PowerRecord,dt);
                Jerk=Jerk+abs(lastAcc-acc);
                overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0);
                 %7个统计量
                stateList=[stateList,state];  
                EnergyRecord=[EnergyRecord,Energy];
                ReGenERecord=[ReGenERecord,ReGenEnery];   
                veoRecord=[veoRecord,CurrVeo];
                locRecord=[locRecord,CurrLoc];
                AccRecord=[AccRecord,acc];  
                PowerRecord=[PowerRecord,power];
                CurrTime=CurrTime+dt;
                timeRecord =[timeRecord,CurrTime];
          end
      elseif(state==0)
          %惰行工况
          dt=TMSTEPLEN;  %仿真步长
          while(CurrLoc<switchPoint(index)) 
                lastAcc=acc;            
                targetAcc=-1*AntiForce(CurrVeo,CurrLoc)/TRAINWGH;
                if(abs(targetAcc-acc)>dadt*dt)
                    acc=sign(targetAcc-acc)*dadt*dt+acc;                   
                else
                    dt=10*TMSTEPLEN;  %仿真步长
                    acc=targetAcc;
                end
                CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
                CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
                overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0);
                power=max(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH,0)*CurrVeo;
                Energy=Adams4(Energy,power,PowerRecord,dt);
                Jerk=Jerk+abs(lastAcc-acc);
                %7个统计量
                stateList=[stateList,state];  
                EnergyRecord=[EnergyRecord,Energy];
                ReGenERecord=[ReGenERecord,ReGenEnery];   
                veoRecord=[veoRecord,CurrVeo];
                locRecord=[locRecord,CurrLoc];
                AccRecord=[AccRecord,acc];
                PowerRecord=[PowerRecord,power];
                CurrTime=CurrTime+dt;
                timeRecord =[timeRecord,CurrTime];
                if(CurrVeo<minVeo)
                    flag=1;
                    return;
                end
          end   
      end 
      %提前停车
      if CurrVeo<minVeo
          flag=1;
          return;
      end          
end

%% 进站停车 
%最后一段制动工况
dt=0.5*TMSTEPLEN; %加速度大，采用小步长
state=-2;
if abs(CurrLoc - ENDPOINT) >  (ENDPOINT - STARTPOINT) * 0.1
	flag = 5; %提前停车
end
while(CurrLoc<ENDPOINT) 
        lastAcc=acc;
        MaxAcc=(-1*BrakeForce(CurrVeo)-AntiForce(CurrVeo,CurrLoc))/TRAINWGH;
        targetAcc = max( -0.5*CurrVeo^2/(ENDPOINT-CurrLoc),MaxAcc);
        if(abs(targetAcc-acc)>dadt*dt*4)
            acc=sign(targetAcc-acc)*2*dadt*dt+acc;
        else
            acc=targetAcc;
        end
        CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
        CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
        power=(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH)*CurrVeo*ReGenRate;
        power=(-1*BrakeForce(CurrVeo))*CurrVeo;
        ReGenEnery=Adams4(ReGenEnery,power,PowerRecord,dt);%能耗近似，忽略转折衔接那一块
        Jerk=Jerk+abs(lastAcc-acc);
        overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0); 
        %7个统计量
        stateList=[stateList,state];  
        EnergyRecord=[EnergyRecord,Energy];
        ReGenERecord=[ReGenERecord,ReGenEnery];   
        veoRecord=[veoRecord,CurrVeo];
        locRecord=[locRecord,CurrLoc];
        AccRecord=[AccRecord,acc]; 
        PowerRecord=[PowerRecord,power];
        CurrTime=CurrTime+dt;
        timeRecord =[timeRecord,CurrTime];
        %事件
        if(CurrVeo<0.1)
            break;
        end
end  
%终点超速
if CurrVeo>maxVeo
  flag=2;
end
if abs(CurrLoc - ENDPOINT) >  (ENDPOINT - STARTPOINT) * 0.1
     flag=5;
     return; %终点停车误差,没能到站
elseif CurrLoc<ENDPOINT
     MissError=ENDPOINT-CurrLoc; 
else
     acc=(-1*BrakeForce(CurrVeo)-AntiForce(CurrVeo,CurrLoc))/TRAINWGH;
     MissError=CurrVeo^2/2*(abs(acc)); %终点停车误差，到站没能停车
end
Time=CurrTime;
Jerk=Jerk/Time;
Energy=Energy-ReGenEnery;
veoRecord = veoRecord * 3.6; % 转换成km/h
if optional==1
        hold off;
        figure('Name','运行情况');%打开新窗口
        plot(locRecord,[veoRecord;stateList],'Marker','o');
        xlabel('行驶距离(m)');
%         ylabel('列车运行工况(m/s)');
        ylabel('列车运行工况(km/h)');
        hold on;
        plotSpeedLimit();
        plotRoadGrad();
        figure('Name','运行情况-时间');%打开新窗口
        plot(timeRecord,[veoRecord;stateList],'Marker','o');
        xlabel('行驶时间(s)');
%         ylabel('行驶速度(m/s)');
        ylabel('行驶速度(km/h)');
        figure('Name','能耗情况');%打开新窗口
        plot(locRecord,[EnergyRecord;ReGenERecord],'Marker','o');
        xlabel('行驶距离(m)');
        ylabel('列车功率(KJ)');
        figure('Name','加速度情况');%打开新窗口
        plot(locRecord,[AccRecord],'Marker','o');
        xlabel('行驶距离(m)');
        ylabel('列车加速度(m/s^2)');
        figure('Name','功率情况');%打开新窗口
        plot(locRecord,[PowerRecord],'Marker','o');
        xlabel('行驶距离(m)');
        ylabel('列车加速度(m/s^2)');
end
end



function  next= Adams4(yi,fi,record,h)
% 采用线性多步法解微分方程
% h :步长
% yi: 
% record:[fi-1,fi-2,...]
n=length(record);
if(n>=4)
    next=yi+h/24*(55*fi-59*record(n)+37*record(n-1)-9*record(n-2));
else
    disp('CalcEJT Error :255');
    next=0;
end
end


