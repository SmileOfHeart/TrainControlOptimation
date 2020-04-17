function [res,Population,Velocity]=PSO_d(options)
%UNTITLED3 粒子群优化算法的主函数
%
global SWITCHNUM TRAVDIS;
global setNum omiga C1 C2 MaxFlyVeo;
%粒子群算法参数
setNum=options.PopulationSize;   %种群数量 
iteraNum=options.MaxGenerations; %迭代次数
omiga=1.1;%惯性因子
C1=1.5;     %个体加速常数
C2=2;    %社会加速常数
MaxFlyVeo=1.5*TRAVDIS/SWITCHNUM; %最大飞行速度
%产生初始种群
if options.Continue == 1
    Population=options.Pop;
    Velocity=options.Velo;
else
    Population=CreateInitPopulation(setNum,SWITCHNUM);  %生成种群
    Velocity=zeros(setNum,SWITCHNUM);
end
socityMaxFitPos=zeros(1,SWITCHNUM);
indiviMaxFitPos=zeros(setNum,SWITCHNUM);
maxFitNessForIndivi=zeros(setNum,1);
maxFitNessForSocity=0;
maxSocityFitNessInIter=[];
indiviFitNess=zeros(setNum,1);
setnum=setNum;
swnum=SWITCHNUM;
OldPopulation=Population;
OldVelocity=Velocity;
for iter=1:iteraNum
    %对个体进行评估
    for i=1:setnum  
        [flag,Energy,Time,MissError,overSpeed,swp,jerk]=CalcEJT(Population(i,:),0);
        Population(i,:)=swp;		
        %测试个体,不符合要求就产生新个体
        if flag~= 0
           Population(i,:)=OldPopulation(i,:);
           Velocity(i,:)=-1*Velocity(i,:);  %飞出边界则反向
            %再次测试
            [flag,Energy,Time,MissError,overSpeed,swp,jerk]=CalcEJT(Population(i,:),0);
            Population(i,:)=swp;
            while flag~= 0
               Population(i,:)=CreateInitPopulation(1,SWITCHNUM);
               [flag,Energy,Time,MissError,overSpeed,swp,jerk]=CalcEJT(Population(i,:),0);
               Population(i,:)=swp;
               disp('PSOmain 44:重新产生个体');
            end
        end     
        indiviFitNess(i)=CacFitNess(Energy,Time,MissError,overSpeed,jerk);
    end
    for i=1:setNum
        if indiviFitNess(i)>maxFitNessForIndivi(i)
                %计算个体最大适应度和最适应位置
                maxFitNessForIndivi(i)=indiviFitNess(i);
                indiviMaxFitPos(i,:)=Population(i,:); 
                if indiviFitNess(i)>maxFitNessForSocity
                    %更新群体最大适应度和最适应位置
                    maxFitNessForSocity=indiviFitNess(i);
                    socityMaxFitPos=Population(i,:);           
                end
        end      
    end
     maxSocityFitNessInIter=[maxSocityFitNessInIter,maxFitNessForSocity];
     %保存旧的种群
     OldPopulation=Population;
     OldVelocity=Velocity;
     %产生新的种群
    [Population,Velocity]=PSOIterate(Population,Velocity,socityMaxFitPos,indiviMaxFitPos); 
     Population=sort(Population,2);%重新排序一下X
    %修改惯性因子 
    omiga=omiga*(1-iter/iteraNum*0.6);
    disp(iter);
end
    res=socityMaxFitPos; 
    save('Result.mat','maxSocityFitNessInIter','socityMaxFitPos');
    figure('Name','适应度变化');
    plot(maxSocityFitNessInIter);
end

