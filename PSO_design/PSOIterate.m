function [newPopulation,newVelocity] = PSOIterate(Population,Velocity,socityMaxFitPos,indiviMaxFitPos)
%UNTITLED5 粒子群算法的位置速度更新函数
%输入参数：
%   Population：种群
%   Velocity：种群飞行速度
%   
%   此处显示详细说明
global setNum omiga C1 C2 MaxFlyVeo upLimit lowLimit;
len=size(Population,2);
%随机数
R1=rand(setNum,len);
R2=rand(setNum,len);
%速度迭代过程
newVelocity=omiga*Velocity+C1*R1.*(indiviMaxFitPos-Population)+C2*R2.*(repmat(socityMaxFitPos,setNum,1)-Population);
%判断速度是否过大
for i=1:setNum
    for j=1:len
        if abs(newVelocity(i,j))>MaxFlyVeo
            newVelocity(i,j)=sign(newVelocity(i,j))*MaxFlyVeo;
        end
    end
end
%新的种群
newPopulation=Population+newVelocity;
up = repmat(upLimit,[setNum,1]);
low = repmat(lowLimit,[setNum,1]);
newPopulation = min(up,newPopulation);
newPopulation = max(low,newPopulation);
end

