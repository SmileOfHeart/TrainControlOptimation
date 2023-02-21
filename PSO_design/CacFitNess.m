function  fitness = CacFitNess(Energy,Time,MissError,overSpeed,Jerk)
%UNTITLED 计算适应度函数
%       
global  DESINTIME EMAX;
y=zeros(1,5);
 %能耗
if  Energy>EMAX
    y(1)= 0;
else
    y(1)=-1+exp((EMAX-Energy)/EMAX);       
end
%时间
y(2)= 10/(1+(Time-DESINTIME)^2);     
%舒适度
if Jerk>3.15
    y(3)=exp(1-Jerk/3.15);       
else
   y(3)=1;
end
%超限速
if overSpeed>0
    y(4)=1/(1+overSpeed);       
else
    y(4)=1;
end
%停车误差
if abs(MissError)<10
    y(5)=1;
else
    y(5)=101/(MissError^2+1);    
end
fitness = 10*y(1)+100*y(2)+y(3)+10*y(4)+20*y(5);
end

