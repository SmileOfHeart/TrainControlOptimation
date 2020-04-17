function [newPopulation,newVelocity] = PSOIterate(Population,Velocity,socityMaxFitPos,indiviMaxFitPos)
%UNTITLED5 ����Ⱥ�㷨��λ���ٶȸ��º���
%���������
%   Population����Ⱥ
%   Velocity����Ⱥ�����ٶ�
%   
%   �˴���ʾ��ϸ˵��
global setNum omiga C1 C2 MaxFlyVeo upLimit lowLimit;
len=size(Population,2);
%�����
R1=rand(setNum,len);
R2=rand(setNum,len);
%�ٶȵ�������
newVelocity=omiga*Velocity+C1*R1.*(indiviMaxFitPos-Population)+C2*R2.*(repmat(socityMaxFitPos,setNum,1)-Population);
%�ж��ٶ��Ƿ����
for i=1:setNum
    for j=1:len
        if abs(newVelocity(i,j))>MaxFlyVeo
            newVelocity(i,j)=sign(newVelocity(i,j))*MaxFlyVeo;
        end
    end
end
%�µ���Ⱥ
newPopulation=Population+newVelocity;
up = repmat(upLimit,[setNum,1]);
low = repmat(lowLimit,[setNum,1]);
newPopulation = min(up,newPopulation);
newPopulation = max(low,newPopulation);
end

