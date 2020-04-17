function [res,Population,Velocity]=PSO_d(options)
%UNTITLED3 ����Ⱥ�Ż��㷨��������
%
global SWITCHNUM TRAVDIS;
global setNum omiga C1 C2 MaxFlyVeo;
%����Ⱥ�㷨����
setNum=options.PopulationSize;   %��Ⱥ���� 
iteraNum=options.MaxGenerations; %��������
omiga=1.1;%��������
C1=1.5;     %������ٳ���
C2=2;    %�����ٳ���
MaxFlyVeo=1.5*TRAVDIS/SWITCHNUM; %�������ٶ�
%������ʼ��Ⱥ
if options.Continue == 1
    Population=options.Pop;
    Velocity=options.Velo;
else
    Population=CreateInitPopulation(setNum,SWITCHNUM);  %������Ⱥ
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
    %�Ը����������
    for i=1:setnum  
        [flag,Energy,Time,MissError,overSpeed,swp,jerk]=CalcEJT(Population(i,:),0);
        Population(i,:)=swp;		
        %���Ը���,������Ҫ��Ͳ����¸���
        if flag~= 0
           Population(i,:)=OldPopulation(i,:);
           Velocity(i,:)=-1*Velocity(i,:);  %�ɳ��߽�����
            %�ٴβ���
            [flag,Energy,Time,MissError,overSpeed,swp,jerk]=CalcEJT(Population(i,:),0);
            Population(i,:)=swp;
            while flag~= 0
               Population(i,:)=CreateInitPopulation(1,SWITCHNUM);
               [flag,Energy,Time,MissError,overSpeed,swp,jerk]=CalcEJT(Population(i,:),0);
               Population(i,:)=swp;
               disp('PSOmain 44:���²�������');
            end
        end     
        indiviFitNess(i)=CacFitNess(Energy,Time,MissError,overSpeed,jerk);
    end
    for i=1:setNum
        if indiviFitNess(i)>maxFitNessForIndivi(i)
                %������������Ӧ�Ⱥ�����Ӧλ��
                maxFitNessForIndivi(i)=indiviFitNess(i);
                indiviMaxFitPos(i,:)=Population(i,:); 
                if indiviFitNess(i)>maxFitNessForSocity
                    %����Ⱥ�������Ӧ�Ⱥ�����Ӧλ��
                    maxFitNessForSocity=indiviFitNess(i);
                    socityMaxFitPos=Population(i,:);           
                end
        end      
    end
     maxSocityFitNessInIter=[maxSocityFitNessInIter,maxFitNessForSocity];
     %����ɵ���Ⱥ
     OldPopulation=Population;
     OldVelocity=Velocity;
     %�����µ���Ⱥ
    [Population,Velocity]=PSOIterate(Population,Velocity,socityMaxFitPos,indiviMaxFitPos); 
     Population=sort(Population,2);%��������һ��X
    %�޸Ĺ������� 
    omiga=omiga*(1-iter/iteraNum*0.6);
    disp(iter);
end
    res=socityMaxFitPos; 
    save('Result.mat','maxSocityFitNessInIter','socityMaxFitPos');
    figure('Name','��Ӧ�ȱ仯');
    plot(maxSocityFitNessInIter);
end

