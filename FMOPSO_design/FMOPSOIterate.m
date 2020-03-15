function [newPopulation,newVelocity] = CMOPSOIterate(Population,Velocity,PBESTS,SIGMA,gridFit,gridPop)
%UNTITLED5 粒子群算法的位置速度更新函数
%输入参数：
%   Population：种群
%   Velocity：种群飞行速度
%   GBEST:选中的外部存档 1*len
%   PBESTS:粒子本身的最好位置
%   SIGMA:正态分布的方差
%   此处显示详细说明
global setNum omiga C1 C2 MaxFlyVeo  ExternPopulation;

len=size(Population,2);

%% 生成正态分布的全局最优位置
NormalGBEST=zeros(setNum,len);%setNum*len的矩阵
for i=1:setNum
    index=mod(i,setNum);
    if index==0
        index=setNum;
    end
    gbest=ExternPopulation(index,:);
    for j=1:len
        NormalGBEST(i,j)=normrnd(gbest(j),SIGMA); 
    end
end


%% 速度迭代过程
%随机数
R1=rand(setNum,len);
R2=rand(setNum,len);
newVelocity=omiga*Velocity+C1*R1.*(PBESTS-Population)+C2*R2.*(NormalGBEST-Population);
%判断速度是否过大
for i=1:setNum
    for j=1:len
        if abs(newVelocity(i,j))>MaxFlyVeo
            newVelocity(i,j)=sign(newVelocity(i,j))*MaxFlyVeo;
        end
    end
end
%% 局部粒子同步搜索SPLS
SLS=round(setNum/4);   %粒子数
NLS=2;%外部粒子数
PopIndex=randperm(setNum,SLS); %粒子数索引,随机选取SLS个粒子
h=[];
for i=1:NLS
   key=gridFit.GetKeyByRouletteWheel();%轮盘法获得要选中哪个格子
   h(i)=gridPop.getValue(key); %从格子中随机选取一个粒子 
end

for i=1:SLS
    row=PopIndex(i); %第i个粒子
    SLDim=randperm(len,1); %选中的决策变量（即解的某一个维度）
    %其它维度按照选择的gbest精确更新
    gIndex=mod(i,NLS);
    if gIndex==0
        gIndex=NLS;
    end
    gbest=ExternPopulation(h(gIndex),:);
    newVelocity(row,:)=omiga*Velocity(row,:)+C1*R1(row,:).*(PBESTS(row,:)-Population(row,:))+C2*R2(row,:).*(gbest-Population(row,:));
    %分配的维度SLDim按正态分布更新
    newVelocity(row,SLDim)=omiga*Velocity(row,SLDim)+C1*R1(row,SLDim).*(PBESTS(row,SLDim)-Population(row,SLDim))+C2*R2(row,SLDim).*(NormalGBEST(row,SLDim)-Population(row,SLDim));
end
%新的种群
newPopulation=Population+newVelocity;
end

