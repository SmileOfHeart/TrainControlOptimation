function  [Population,Velocity,enterCount,gridPop,gridFit,avgPersonalFitness,avgGlobalFitnessList]= FMOPSOStatistics( Population,Velocity,iterGen)
%UNTITLED 多目标粒子群算法统计函数
% 统计：
%1.个体的最好适应度
%2.更新外部种群
%3.网格密度
%4.enterCount: 本次迭代进入外部种群的个体数
%迭代次数iterGen
global  OldPopulation PBESTS PBSESTFitNess SWITCHNUM setNum ExternFitNess ExternPopulation fitVictorLen ExternREPCharacter Tmax Tmin   %iteraNum
swnum=SWITCHNUM;
indiviFitNess=zeros(setNum,fitVictorLen);  %个体的适应度向量
PopulationCharacter=zeros(setNum,fitVictorLen);  %个体的适应度向量
%% 计算适应度
enterCount=0;
%prob=iterGen/iteraNum*0.5;
for i=1:setNum  
        [flag,Energy,Time,MissError,overSpeed,swp,Jerk]=CalcEJT(Population(i,:),2);
        Population(i,:)=swp;
        %测试个体,不符合要求就产生新个体
        if flag~= 0
            Population(i,:)=OldPopulation(i,:);
           Velocity(i,:)=-0.2*Velocity(i,:);  %飞出边界则反向
            %再次测试
            [flag,Energy,Time,MissError,overSpeed,swp,Jerk]=CalcEJT(Population(i,:),2);
            Population(i,:)=swp;
            while flag~= 0
               Population(i,:)=CreateInitPopulation(1,swnum,0);
               Velocity(i,:)=zeros(1,swnum);
               [flag,Energy,Time,MissError,overSpeed,swp,Jerk]=CalcEJT(Population(i,:),2);
               Population(i,:)=swp;
               disp(['重新产生个体 编号：',num2str(i)]);
            end
        end          
        indiviFitNess(i,:)=CacCMOFitNess([Energy,Time,MissError,overSpeed,Jerk]);%计算适应度向量
        PopulationCharacter(i,:)=[Energy,Time,MissError,overSpeed,Jerk];%保存特征
end
%% 更新pbest
 for i=1:setNum
        %更新pbest判断约束是否存在Pareto优势
        state = IsParetoDom(indiviFitNess(i,:),PBSESTFitNess(i,:),3,0);
        if state==0
            PBSESTFitNess(i,:)=indiviFitNess(i,:);
            PBESTS(i,:)=Population(i,:);  
        elseif state==2
            %随机选取一个
            if rand()<0.5
                PBSESTFitNess(i,:)=indiviFitNess(i,:);
                PBESTS(i,:)=Population(i,:); 
            end
        end  
 end
%% 更新外部存档的适应度 
for i=1:setNum
      if ExternREPCharacter(i,:)>0
            ExternFitNess(i,:)= CacCMOFitNess(ExternREPCharacter(i,:));  %重新计算外部种群的适应度
      end
end
%% 更新gbest  随机进行二元竞标赛法 
dom_vector= GetPeratoSet(indiviFitNess,3,0);%是否是种群中全局最优解的标志
%注:由于有约束的存在,导致Pareto比较的偏好性

for i=1:setNum
    if dom_vector(i)==1
        ExternFitNess=[ExternFitNess;indiviFitNess(i,:)]; %保持个体的适应度 
        ExternPopulation=[ExternPopulation;Population(i,:)];
        ExternREPCharacter=[ExternREPCharacter;PopulationCharacter(i,:)];
    end
end

 %% 外部存档自己更新，排除不合适的解


[m,~]=size(ExternPopulation);


dom_vector= GetPeratoSet(ExternFitNess,3,0);%是否是全局最优解的标志
 
 i=1;
 j=setNum+1;
 while i<=setNum && j<=m
     %从两边开始找
     while i<=setNum&&dom_vector(i)==1 
         i=i+1;
     end
     while j<=m&&dom_vector(j)==0 
         j=j+1; 
     end
     if j>m || i>setNum
         break;
     end
     if dom_vector(i)==0&&dom_vector(j)==1
         ExternFitNess(i,:)=ExternFitNess(j,:); %保持个体的适应度 
         ExternPopulation(i,:)=ExternPopulation(j,:);
         ExternREPCharacter(i,:)=ExternREPCharacter(j,:);
         dom_vector(i)=dom_vector(j);
         enterCount=enterCount+1;
         i=i+1;
         j=j+1; 
     end
 end
%截断
ExternFitNess=ExternFitNess(1:setNum,:); %保持个体的适应度 
ExternPopulation=ExternPopulation(1:setNum,:);
ExternREPCharacter=ExternREPCharacter(1:setNum,:);

list=[];
for i=1:setNum
     if dom_vector(i)==1 
         list=[list,i];
     end
end
avgGlobalFitnessList=sum(ExternFitNess(list,:),1)./length(list);%对列求和

if mod(iterGen,20)==1
    str=['Pareto前沿',num2str(iterGen)];
    figure('Name',str);
    scatter(ExternREPCharacter(:,2),ExternREPCharacter(:,1));
    str=['种群分布',num2str(iterGen)];
    figure('Name',str);
    scatter(PopulationCharacter(:,2),PopulationCharacter(:,1));
end
%% 更新个体历史最好位置
 %% 统计外部种群在自适应网格中的分布
k=2;%取第k位进行统计,即时间进行统计
% upper=max(ExternREPCharacter(:,k),[],1); %上界
% downer=min(ExternREPCharacter(:,k),[],1); %下界
upper=Tmax; %上界
downer=Tmin; %下界
ObjGridSize=(upper-downer)/10;%分割为20个小块
grid=GridIndexMap();%用Map来存储超立方体网格的索引作为key，并且存储该网格对应的粒子数来作为value
gridFit=GridIndexMap();%每个格子的适应度值
gridPop= GridIndexSet();%每个格子对应的个体（具体为ExternPopulation编号）
for i=1:setNum
     GridIndex=floor((ExternREPCharacter(i,k)-downer)./ObjGridSize+1); 
     if GridIndex<0
         continue
     end
     gridPop=gridPop.AddValue(GridIndex,i);%将个体i加入到盒子中
     if grid.isKey(GridIndex)
         %如果包含这个网格的索引，则直接更新该网格包含的粒子数
        value=grid.getValue(GridIndex)+1;   
        grid=grid.setValue(GridIndex,value);
     else
         %如果不包含这个网格的索引，则添加该网格
         grid=grid.setValue(GridIndex,1);
     end   
end
%计算网格适应度
keys=grid.keys();
for i =1: grid.GetKeyNum()
     key=keys(i,:);
     if(key<0)
         disp('CMOPSOStatistic Error :149')
     end
     value=grid.getValue(key);
     gridFit=gridFit.setValue(key,1/value); %计算网格适应度
end

avgPersonalFitness=sum(indiviFitNess,1)/setNum;

end

