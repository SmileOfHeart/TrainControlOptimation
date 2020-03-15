function  y= CacCMOFitNess(x)
%UNTITLED ������Ӧ�Ⱥ���
%       
global EMAX Tmin Tmax FitNessRate ;

Energy=x(1);
Time=x(2);
MissError=x(3);
overSpeed=x(4);
Jerk=x(5);
y=zeros(1,5);
 %�ܺ�
if  Energy>EMAX
    y(1)= 0;
else
    y(1)=-1+exp((EMAX-Energy)/EMAX);       
end
%ʱ��
if Time>Tmin && Time<Tmax
    y(2)= 1-(Time- Tmin)/(Tmax-Tmin);
else
    y(2)=0;
end
%���ʶ�
if Jerk>3.15
    y(3)=exp(1-Jerk/3.15);       
else
   y(3)=1;
end
%������
OSC=100*FitNessRate;
if overSpeed>OSC
    y(4)=(1+OSC)/(1+overSpeed);       
else
    y(4)=1;
end
%ͣ�����
MEC=100*FitNessRate;
if abs(MissError)<MEC
    y(5)=1;
else
    y(5)=(MEC^2+1)/(MissError^2+1);    
end

end


