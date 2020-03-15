function switchPoint=tryCreateOneIndivi(N)
%���Բ���һ���������н�   ��ǣ��-Ѳ��-����-Ѳ���� -��ǣ��-Ѳ��-����-Ѳ����-...  -�ƶ�
%���������N�����н�����Ĺ���ת��������,������4*n��n���������ϣ�ǣ��-Ѳ��-����-Ѳ�����ظ�����
%����
global COADIS STARTPOINT  ENDPOINT MinCoastVeo stateTable; %stateTable - ����ת�����Ӧ�Ĺ�����
MinCoastDis=COADIS;%��̶��о���
switchPoint=zeros(1,N);
MaxStep=1;
MinCoastVeo=3;
%��ӵ�һ����
StartPointVeo=0.01;
StartPointLoc=STARTPOINT;%������ʼ��
for i=1:N-1
    state=stateTable(i); %��ǰ�Ĺ���
    if state==2
        %���ǣ�������յ�
        options=odeset('events',@odeEventAcc);
        [S,y]=ode45(@odeAccDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
        len=length(S);
        EndPointLoc=S(len);%S�����һ���㣬��ʾ�ù����ܳ�������Զ��
        switchPoint(i)=rand()*(EndPointLoc-StartPointLoc)*0.3+StartPointLoc+(EndPointLoc-StartPointLoc)*0.5;%�������תǣ���л���ȡ����1/2;
        %��ʼ����һ�����еĿ�ʼ����
        StartPointLoc=switchPoint(i);
        if len==1
            %����ǰ���������غϣ�����֮ǰ���о���������޷�������һ�ζ���
            break;
        end                    
        StartPointVeo=findAt(S,y,StartPointLoc);
        if(StartPointVeo<MinCoastVeo)
            break; %�����ٶ�̫С������
        end
    elseif state==1
        %Ѳ�������յ�
        options=odeset('events',@odeEventSpeedHold,'MaxStep',MaxStep);
        [S,y]=ode45(@odeSpeedHoldDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
        len=length(S);
        EndPointLoc=S(len);%S�����һ���㣬��ʾ�ù����ܳ�������Զ��
        switchPoint(i)=rand()*(EndPointLoc-StartPointLoc)*0.3+StartPointLoc;%���Ѳ��ת���л��л���ȡ����0.3;
        StartPointLoc=switchPoint(i);
    elseif state==0
        %���й����յ�
        options=odeset('events',@odeEventCoastA);
        [S,y]=ode45(@odeCoastDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
        len=length(S);
        EndPointLoc=S(len);%S�����һ���㣬��ʾ�ù����ܳ�������Զ��
        if(EndPointLoc-StartPointLoc<MinCoastDis)
            break;       %��ѡ���г��ȹ��̣���������
        end
        switchPoint(i)=rand()*(EndPointLoc-StartPointLoc)*2/3+StartPointLoc+MinCoastDis;%�������תǣ���л���ȡ����2/3;
        StartPointLoc=switchPoint(i);
        StartPointVeo=findAt(S,y,StartPointLoc);
    end
end

%�������ƶ������л���
options=odeset('events',@odeEventCoastA,'MaxStep',MaxStep);
[S,y]=ode45(@odeCoastDiffEqu,[StartPointLoc,ENDPOINT],StartPointVeo,options);
len=length(S);
switchPoint(N)=S(len);%S�����һ���㣬��ʾ�ù����ܳ�������Զ��
       
end

function [value,isterminal,direction]=odeEventCoastA(S,y)
     global MinCoastVeo;
     value(1)=y-MinCoastVeo;%�ٶ�ΪMinCoastVeo����ֹͣ����
     value(2)=y-SpeedLimitBrake(S);%�����ƶ����٣���ֹͣ����
     isterminal(1)=1;
     isterminal(2)=1;
     direction(1)=-1;
     direction(2)=1;
end

function [value,isterminal,direction]=odeEventAcc(S,y)
     value=y-SpeedLimitBrake(S);%�����ƶ����٣���ֹͣ����
     isterminal=1;
     direction=1;
end

function [value,isterminal,direction]=odeEventSpeedHold(S,y)
     value=y-SpeedLimitBrake(S);%�����ƶ����٣���ֹͣ����
     isterminal(1)=1;
     direction(1)=1;
end


function dydS=odeSpeedHoldDiffEqu(S,y)
     %Ѳ������
     %y=�ٶ�
     %global TRAINWGH;
     dydS=0;
     anti=AntiForce(y,S);
     tractionF=TrateForce(y);
     brakeF=BrakeForce(y);
     if anti>0 &&tractionF<anti
        dydS=tractionF-anti;%ǣ���������Կ˷���������   
     elseif  brakeF<abs(anti)
        dydS= abs(anti)-brakeF;  %�ƶ��������Կ˷������»��� 
     end

end


function dydS=odeAccDiffEqu(S,y)
     %ǣ������
     %y=�ٶ�
     global TRAINWGH;
     dydS=1/y*(TrateForce(y)-AntiForce(y,S))/TRAINWGH;
end  


function dydS=odeCoastDiffEqu(S,y)
     %���й���
     %y=�ٶ�
     global TRAINWGH;
     dydS=1/(y+0.01)*(-1*AntiForce(y,S))/TRAINWGH;
end

            
