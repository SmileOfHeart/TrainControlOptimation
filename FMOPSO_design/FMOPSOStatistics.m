function  [Population,Velocity,enterCount,gridPop,gridFit,avgPersonalFitness,avgGlobalFitnessList]= FMOPSOStatistics( Population,Velocity,iterGen)
%UNTITLED ��Ŀ������Ⱥ�㷨ͳ�ƺ���
% ͳ�ƣ�
%1.����������Ӧ��
%2.�����ⲿ��Ⱥ
%3.�����ܶ�
%4.enterCount: ���ε��������ⲿ��Ⱥ�ĸ�����
%��������iterGen
global  OldPopulation PBESTS PBSESTFitNess SWITCHNUM setNum ExternFitNess ExternPopulation fitVictorLen ExternREPCharacter Tmax Tmin   %iteraNum
swnum=SWITCHNUM;
indiviFitNess=zeros(setNum,fitVictorLen);  %�������Ӧ������
PopulationCharacter=zeros(setNum,fitVictorLen);  %�������Ӧ������
%% ������Ӧ��
enterCount=0;
%prob=iterGen/iteraNum*0.5;
for i=1:setNum  
        [flag,Energy,Time,MissError,overSpeed,swp,Jerk]=CalcEJT(Population(i,:),2);
        Population(i,:)=swp;
        %���Ը���,������Ҫ��Ͳ����¸���
        if flag~= 0
            Population(i,:)=OldPopulation(i,:);
           Velocity(i,:)=-0.2*Velocity(i,:);  %�ɳ��߽�����
            %�ٴβ���
            [flag,Energy,Time,MissError,overSpeed,swp,Jerk]=CalcEJT(Population(i,:),2);
            Population(i,:)=swp;
            while flag~= 0
               Population(i,:)=CreateInitPopulation(1,swnum,0);
               Velocity(i,:)=zeros(1,swnum);
               [flag,Energy,Time,MissError,overSpeed,swp,Jerk]=CalcEJT(Population(i,:),2);
               Population(i,:)=swp;
               disp(['���²������� ��ţ�',num2str(i)]);
            end
        end          
        indiviFitNess(i,:)=CacCMOFitNess([Energy,Time,MissError,overSpeed,Jerk]);%������Ӧ������
        PopulationCharacter(i,:)=[Energy,Time,MissError,overSpeed,Jerk];%��������
end
%% ����pbest
 for i=1:setNum
        %����pbest�ж�Լ���Ƿ����Pareto����
        state = IsParetoDom(indiviFitNess(i,:),PBSESTFitNess(i,:),3,0);
        if state==0
            PBSESTFitNess(i,:)=indiviFitNess(i,:);
            PBESTS(i,:)=Population(i,:);  
        elseif state==2
            %���ѡȡһ��
            if rand()<0.5
                PBSESTFitNess(i,:)=indiviFitNess(i,:);
                PBESTS(i,:)=Population(i,:); 
            end
        end  
 end
%% �����ⲿ�浵����Ӧ�� 
for i=1:setNum
      if ExternREPCharacter(i,:)>0
            ExternFitNess(i,:)= CacCMOFitNess(ExternREPCharacter(i,:));  %���¼����ⲿ��Ⱥ����Ӧ��
      end
end
%% ����gbest  ������ж�Ԫ�������� 
dom_vector= GetPeratoSet(indiviFitNess,3,0);%�Ƿ�����Ⱥ��ȫ�����Ž�ı�־
%ע:������Լ���Ĵ���,����Pareto�Ƚϵ�ƫ����

for i=1:setNum
    if dom_vector(i)==1
        ExternFitNess=[ExternFitNess;indiviFitNess(i,:)]; %���ָ������Ӧ�� 
        ExternPopulation=[ExternPopulation;Population(i,:)];
        ExternREPCharacter=[ExternREPCharacter;PopulationCharacter(i,:)];
    end
end

 %% �ⲿ�浵�Լ����£��ų������ʵĽ�


[m,~]=size(ExternPopulation);


dom_vector= GetPeratoSet(ExternFitNess,3,0);%�Ƿ���ȫ�����Ž�ı�־
 
 i=1;
 j=setNum+1;
 while i<=setNum && j<=m
     %�����߿�ʼ��
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
         ExternFitNess(i,:)=ExternFitNess(j,:); %���ָ������Ӧ�� 
         ExternPopulation(i,:)=ExternPopulation(j,:);
         ExternREPCharacter(i,:)=ExternREPCharacter(j,:);
         dom_vector(i)=dom_vector(j);
         enterCount=enterCount+1;
         i=i+1;
         j=j+1; 
     end
 end
%�ض�
ExternFitNess=ExternFitNess(1:setNum,:); %���ָ������Ӧ�� 
ExternPopulation=ExternPopulation(1:setNum,:);
ExternREPCharacter=ExternREPCharacter(1:setNum,:);

list=[];
for i=1:setNum
     if dom_vector(i)==1 
         list=[list,i];
     end
end
avgGlobalFitnessList=sum(ExternFitNess(list,:),1)./length(list);%�������

if mod(iterGen,20)==1
    str=['Paretoǰ��',num2str(iterGen)];
    figure('Name',str);
    scatter(ExternREPCharacter(:,2),ExternREPCharacter(:,1));
    str=['��Ⱥ�ֲ�',num2str(iterGen)];
    figure('Name',str);
    scatter(PopulationCharacter(:,2),PopulationCharacter(:,1));
end
%% ���¸�����ʷ���λ��
 %% ͳ���ⲿ��Ⱥ������Ӧ�����еķֲ�
k=2;%ȡ��kλ����ͳ��,��ʱ�����ͳ��
% upper=max(ExternREPCharacter(:,k),[],1); %�Ͻ�
% downer=min(ExternREPCharacter(:,k),[],1); %�½�
upper=Tmax; %�Ͻ�
downer=Tmin; %�½�
ObjGridSize=(upper-downer)/10;%�ָ�Ϊ20��С��
grid=GridIndexMap();%��Map���洢�������������������Ϊkey�����Ҵ洢�������Ӧ������������Ϊvalue
gridFit=GridIndexMap();%ÿ�����ӵ���Ӧ��ֵ
gridPop= GridIndexSet();%ÿ�����Ӷ�Ӧ�ĸ��壨����ΪExternPopulation��ţ�
for i=1:setNum
     GridIndex=floor((ExternREPCharacter(i,k)-downer)./ObjGridSize+1); 
     if GridIndex<0
         continue
     end
     gridPop=gridPop.AddValue(GridIndex,i);%������i���뵽������
     if grid.isKey(GridIndex)
         %�����������������������ֱ�Ӹ��¸����������������
        value=grid.getValue(GridIndex)+1;   
        grid=grid.setValue(GridIndex,value);
     else
         %���������������������������Ӹ�����
         grid=grid.setValue(GridIndex,1);
     end   
end
%����������Ӧ��
keys=grid.keys();
for i =1: grid.GetKeyNum()
     key=keys(i,:);
     if(key<0)
         disp('CMOPSOStatistic Error :149')
     end
     value=grid.getValue(key);
     gridFit=gridFit.setValue(key,1/value); %����������Ӧ��
end

avgPersonalFitness=sum(indiviFitNess,1)/setNum;

end

