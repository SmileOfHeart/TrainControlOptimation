function [flag,Energy,Time,MissError,overSpeed,switchPoint,Jerk,CoastSpeedDecRate] = CalcEJT(switchPoint,optional)
%UNTITLED4 ����һ�鹤��ת������ܺĺ�ʱ�� �����  ͣ�����   �ۼƳ��� �� �ж��Ƿ����Լ��
%����
%switchPoint��ת���������
%optional��ѡ��    0:���ж��Ƿ����Լ�� 1:������� 
% ����ֵ
%Energy,Time,MissError,overSpeed Jerk CoastSpeedDecRate
%�ܺ�  ʱ��  �����  ͣ�����   �ۼƳ��� ���ʶ�  ��������ٶȺ�����ٶȵı���
%����ֵ��flag ���Խ���� 0���������Լ����1�����о�������� 2:�յ��ٶȲ�Ϊ0; 3:�����޲�����Լ�� 4�����о����С 5:��ǰͣ��
global STARTPOINT ENDPOINT TRAINWGH COADIS minVeo stateTable ReGenRate COMFACC TMSTEPLEN; %stateTable - ����ת�����Ӧ�Ĺ�����
%ReGenRate�������ƶ���
ReGenRate=0;
minVeo=3;                                    %�м���������С�ٶ�
maxVeo=10;                                   %�յ㴦���������ٶ�
n = length(switchPoint);                     %����ת��������
%�м���
CurrLoc = STARTPOINT;                         %��ǰλ��
CurrVeo =0;                               %��ǰ�ٶ�
CurrTime=0;
overSpeed=0;                                 %�ۼƳ���
Energy=0;
acc=0.6;
power=0;                                     %����
ReGenEnery=0;                                %�����ƶ����յ��ܺ�
state=2;              %����
%EnergyRecord=[CurrEnergy];
%��ʼ�������������ֹ����
flag = 0;                                    %���п��Ƶ���жϣ���Ч����1����Ч����0
Time=0;
MissError=0;
Jerk=0;                                       %���е����ʶ�
dadt=COMFACC;                             %���ٶȱ仯��
%ͳ�Ʊ���7��
stateList=[2];                                %����ʱ����
EnergyRecord=[Energy];        
ReGenERecord=[ReGenEnery]; 
PowerRecord=[power];
AccRecord=[acc];
veoRecord=[CurrVeo];
locRecord=[CurrLoc];
timeRecord=[CurrTime];
%% �߽����
for index=1:n
    if switchPoint(index)<STARTPOINT||switchPoint(index)>=ENDPOINT
        %��������½�    
        flag=3;
        return;
    end
end
for index=2:n
    %�ж�ĳһ�ι����Ƿ�̫��
    if switchPoint(index)-switchPoint(index-1)<COADIS
        flag=4;
        return;
    end 
end



%% �����ֵ
%���Զಽ���ĳ�ֵ,5����
dt=TMSTEPLEN;  %���沽��
for i=1:4
    CurrVeo=CurrTime*dt;
    dS=0.5*acc*CurrTime^2;
    CurrLoc= CurrLoc+dS;
    power=TrateForce(CurrVeo)*CurrVeo;
    Energy=TrateForce(CurrVeo)*dS;   %�ܺĽ��ƣ�����ת���ν���һ��
    %ͳ�Ʊ���7��
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


%% ������ʻ
for index=1:n
    state=stateTable(index); %��ǰ�Ĺ���    
    if(state==2)
          %ǣ������
          dt=TMSTEPLEN;  %���沽��
          while(CurrLoc<switchPoint(index)) 
                targetAcc=(TrateForce(CurrVeo)-AntiForce(CurrVeo,CurrLoc))/TRAINWGH; 
                lastAcc=acc;
                if(abs(targetAcc-acc)>dadt*dt)
                    %ת�۴�����õ;������Զಽ�����
                    acc=sign(targetAcc-acc)*dadt*dt+acc;
                else
                    dt=10*TMSTEPLEN;  %���沽��
                    acc=targetAcc; 
                end
                CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
                CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
                power=max(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH,0)*CurrVeo;
                Energy=Adams4(Energy,power,PowerRecord,dt);  %�ܺĽ��ƣ�����ת���ν���һ��
                Jerk=Jerk+abs(lastAcc-acc);
                overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0);
                %%ͳ�Ʊ���7��
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
%                     switchPoint(index)=CurrLoc; %Ψһ������������
%                 end
          end
      elseif (state==1)
          %Ѳ������ 
          dt=TMSTEPLEN;  %���沽��
          targetAcc=0;
          while(CurrLoc<switchPoint(index)) 
                lastAcc=acc;
                if(abs(targetAcc-acc)>dadt*dt)
                    acc=sign(targetAcc-acc)*dadt*dt+acc;
                else
                    dt=10*TMSTEPLEN;  %���沽��
                    acc=targetAcc;
                end
                CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
                CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
                power=max(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH,0)*CurrVeo;
                Energy=Adams4(Energy,power,PowerRecord,dt);
                Jerk=Jerk+abs(lastAcc-acc);
                overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0);
                 %7��ͳ����
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
          %���й���
          dt=TMSTEPLEN;  %���沽��
          while(CurrLoc<switchPoint(index)) 
                lastAcc=acc;            
                targetAcc=-1*AntiForce(CurrVeo,CurrLoc)/TRAINWGH;
                if(abs(targetAcc-acc)>dadt*dt)
                    acc=sign(targetAcc-acc)*dadt*dt+acc;                   
                else
                    dt=10*TMSTEPLEN;  %���沽��
                    acc=targetAcc;
                end
                CurrVeo=Adams4(CurrVeo,acc,AccRecord,dt);
                CurrLoc=Adams4(CurrLoc,CurrVeo,veoRecord,dt);
                overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0);
                power=max(AntiForce(CurrVeo,CurrLoc)+acc*TRAINWGH,0)*CurrVeo;
                Energy=Adams4(Energy,power,PowerRecord,dt);
                Jerk=Jerk+abs(lastAcc-acc);
                %7��ͳ����
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
      %��ǰͣ��
      if CurrVeo<minVeo
          flag=1;
          return;
      end          
end

%% ��վͣ�� 
%���һ���ƶ�����
dt=0.5*TMSTEPLEN; %���ٶȴ󣬲���С����
state=-2;
if abs(CurrLoc - ENDPOINT) >  (ENDPOINT - STARTPOINT) * 0.1
	flag = 5; %��ǰͣ��
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
        ReGenEnery=Adams4(ReGenEnery,power,PowerRecord,dt);%�ܺĽ��ƣ�����ת���ν���һ��
        Jerk=Jerk+abs(lastAcc-acc);
        overSpeed=overSpeed+max(CurrVeo-SpeedLimitBrake(CurrLoc),0); 
        %7��ͳ����
        stateList=[stateList,state];  
        EnergyRecord=[EnergyRecord,Energy];
        ReGenERecord=[ReGenERecord,ReGenEnery];   
        veoRecord=[veoRecord,CurrVeo];
        locRecord=[locRecord,CurrLoc];
        AccRecord=[AccRecord,acc]; 
        PowerRecord=[PowerRecord,power];
        CurrTime=CurrTime+dt;
        timeRecord =[timeRecord,CurrTime];
        %�¼�
        if(CurrVeo<0.1)
            break;
        end
end  
%�յ㳬��
if CurrVeo>maxVeo
  flag=2;
end
if abs(CurrLoc - ENDPOINT) >  (ENDPOINT - STARTPOINT) * 0.1
     flag=5;
     return; %�յ�ͣ�����,û�ܵ�վ
elseif CurrLoc<ENDPOINT
     MissError=ENDPOINT-CurrLoc; 
else
     acc=(-1*BrakeForce(CurrVeo)-AntiForce(CurrVeo,CurrLoc))/TRAINWGH;
     MissError=CurrVeo^2/2*(abs(acc)); %�յ�ͣ������վû��ͣ��
end
Time=CurrTime;
Jerk=Jerk/Time;
Energy=Energy-ReGenEnery;
veoRecord = veoRecord * 3.6; % ת����km/h
if optional==1
        hold off;
        figure('Name','�������');%���´���
        plot(locRecord,[veoRecord;stateList],'Marker','o');
        xlabel('��ʻ����(m)');
%         ylabel('�г����й���(m/s)');
        ylabel('�г����й���(km/h)');
        hold on;
        plotSpeedLimit();
        plotRoadGrad();
        figure('Name','�������-ʱ��');%���´���
        plot(timeRecord,[veoRecord;stateList],'Marker','o');
        xlabel('��ʻʱ��(s)');
%         ylabel('��ʻ�ٶ�(m/s)');
        ylabel('��ʻ�ٶ�(km/h)');
        figure('Name','�ܺ����');%���´���
        plot(locRecord,[EnergyRecord;ReGenERecord],'Marker','o');
        xlabel('��ʻ����(m)');
        ylabel('�г�����(KJ)');
        figure('Name','���ٶ����');%���´���
        plot(locRecord,[AccRecord],'Marker','o');
        xlabel('��ʻ����(m)');
        ylabel('�г����ٶ�(m/s^2)');
        figure('Name','�������');%���´���
        plot(locRecord,[PowerRecord],'Marker','o');
        xlabel('��ʻ����(m)');
        ylabel('�г����ٶ�(m/s^2)');
end
end



function  next= Adams4(yi,fi,record,h)
% �������Զಽ����΢�ַ���
% h :����
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


