function [newPopulation,newVelocity] = CMOPSOIterate(Population,Velocity,PBESTS,SIGMA,gridFit,gridPop)
%UNTITLED5 ����Ⱥ�㷨��λ���ٶȸ��º���
%���������
%   Population����Ⱥ
%   Velocity����Ⱥ�����ٶ�
%   GBEST:ѡ�е��ⲿ�浵 1*len
%   PBESTS:���ӱ�������λ��
%   SIGMA:��̬�ֲ��ķ���
%   �˴���ʾ��ϸ˵��
global setNum omiga C1 C2 MaxFlyVeo  ExternPopulation;

len=size(Population,2);

%% ������̬�ֲ���ȫ������λ��
NormalGBEST=zeros(setNum,len);%setNum*len�ľ���
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


%% �ٶȵ�������
%�����
R1=rand(setNum,len);
R2=rand(setNum,len);
newVelocity=omiga*Velocity+C1*R1.*(PBESTS-Population)+C2*R2.*(NormalGBEST-Population);
%�ж��ٶ��Ƿ����
for i=1:setNum
    for j=1:len
        if abs(newVelocity(i,j))>MaxFlyVeo
            newVelocity(i,j)=sign(newVelocity(i,j))*MaxFlyVeo;
        end
    end
end
%% �ֲ�����ͬ������SPLS
SLS=round(setNum/4);   %������
NLS=2;%�ⲿ������
PopIndex=randperm(setNum,SLS); %����������,���ѡȡSLS������
h=[];
for i=1:NLS
   key=gridFit.GetKeyByRouletteWheel();%���̷����Ҫѡ���ĸ�����
   h(i)=gridPop.getValue(key); %�Ӹ��������ѡȡһ������ 
end

for i=1:SLS
    row=PopIndex(i); %��i������
    SLDim=randperm(len,1); %ѡ�еľ��߱����������ĳһ��ά�ȣ�
    %����ά�Ȱ���ѡ���gbest��ȷ����
    gIndex=mod(i,NLS);
    if gIndex==0
        gIndex=NLS;
    end
    gbest=ExternPopulation(h(gIndex),:);
    newVelocity(row,:)=omiga*Velocity(row,:)+C1*R1(row,:).*(PBESTS(row,:)-Population(row,:))+C2*R2(row,:).*(gbest-Population(row,:));
    %�����ά��SLDim����̬�ֲ�����
    newVelocity(row,SLDim)=omiga*Velocity(row,SLDim)+C1*R1(row,SLDim).*(PBESTS(row,SLDim)-Population(row,SLDim))+C2*R2(row,SLDim).*(NormalGBEST(row,SLDim)-Population(row,SLDim));
end
%�µ���Ⱥ
newPopulation=Population+newVelocity;
end

