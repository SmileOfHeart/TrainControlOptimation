function [ExREP,ExChar,REPNum,gridFit,Population,Velocity,enterCountList,repNumList,avgPersonalFitnessList,avgGlobalFitnessList]=FMOPSO_d(options)
% ����Ⱥ�Ż��㷨��������
% �㷨�������˵��
% Popָ����ʼ������Ⱥ��Ⱥ
% Veloָ����ʼ������Ⱥ�ٶ�
% �㷨�������˵��
%ExREP   					%�ⲿ��Ⱥ
%ExChar  					%�ⲿ��Ⱥ����������
%REPNum  					%�ⲿ��Ⱥ������������
%gridFit 					%��Ӧ�����񣬼�¼������Ŀ��ռ�ķֲ����
%Population  				%����Ⱥ�㷨��Ⱥ
%Velocity    				%���ӷ����ٶ�
%enterCountList   			%��¼ÿһ�ֽ����ⲿ��Ⱥ��������
%repNumList       			%��¼ÿһ���ⲿ��Ⱥ��������
%avgPersonalFitnessList     %ÿһ�ֵ���������Ⱥ����ƽ����Ӧ������
%avgGlobalFitnessList       %ÿһ�ֵ������ⲿ��Ⱥ��ƽ����Ӧ������

global SWITCHNUM TRAVDIS;
global setNum omiga C1 C2 MaxFlyVeo;
global OldPopulation PBESTS PBSESTFitNess  ExternFitNess ExternPopulation RepCount fitVictorLen ExternREPCharacter iteraNum  FitNessRate %ExpSetNum
%����Ⱥ�㷨����
setNum=options.PopulationSize;   %��Ⱥ���� 
%ExpSetNum=30; %�ⲿ��Ⱥ��Ⱥ��С
fitVictorLen=5; %��Ӧ����������
RepCount=0;%�ⲿ��Ⱥ�����Ĳ��ظ��������
omiga=1.4;%��������
C1=2.0;     %������ٳ���
C2=2.0;    %�����ٳ���
MaxFlyVeo=2*TRAVDIS/SWITCHNUM; %�������ٶ�
iteraNum=options.MaxGenerations; %��������
FitNessRate=1;
enterCountList=zeros(1,iteraNum);
repNumList=zeros(1,iteraNum);
avgPersonalFitnessList=[];
avgGlobalFitnessList=[];
%%
%������ʼ��Ⱥ
if options.Continue == 1
    Population=options.Pop;
    Velocity=options.Velo;
else
    Population=CreateInitPopulation(setNum,SWITCHNUM);  %������Ⱥ
    Velocity=zeros(setNum,SWITCHNUM);
end
ExternPopulation=zeros(setNum,SWITCHNUM);%�ⲿ��Ⱥ
ExternFitNess=zeros(setNum,fitVictorLen);%�ⲿ��Ⱥ����Ӧ������
ExternREPCharacter=zeros(setNum,fitVictorLen);%�ⲿ�洢������������ָ[Energy,Time,jerk,MissError,overSpeed,jerk]
PBSESTFitNess=zeros(setNum,fitVictorLen);
%��ʼ���ⲿ��Ⱥ
PBESTS=Population;
OldPopulation=Population;
[Population,Velocity,~,gridPop,gridFit] = FMOPSOStatistics( Population,Velocity,0);  %ͳ�Ʋ��Ҹ����ⲿ��Ⱥ
%%
%������ʼ
for iter=1:iteraNum
    %% ��������Ⱥ�е������ٶȺ�λ��
    OldPopulation=Population;
     FitNessRate=1-iter/iteraNum;
    SIGMA=(1-iter/iteraNum)*1000;  %f-gbest�ķ���
    [Population,Velocity]=FMOPSOIterate(Population,Velocity,PBESTS,SIGMA,gridFit,gridPop); 
    Population=sort(Population,2);%��������һ��
    %% �޸Ĺ�������,���Է�
    omiga=0.9*(1-iter/iteraNum)+0.4;    
    [Population,Velocity,enterConter,gridPop,gridFit,avgPersonalFitness,avgGlobalFitness] = FMOPSOStatistics( Population,Velocity,iter);
    enterCountList(iter)=enterConter;
    repNumList(iter)=RepCount;   
    avgPersonalFitnessList=[avgPersonalFitnessList;avgPersonalFitness];
    avgGlobalFitnessList=[avgGlobalFitnessList;avgGlobalFitness];
    disp(iter);
end
    ExREP=ExternPopulation;
    ExChar=ExternREPCharacter;
    REPNum=RepCount;
    save('Result.mat','ExREP','ExChar','enterCountList','repNumList','avgGlobalFitnessList','avgPersonalFitnessList');
    figure('Name','������');
    plot(enterCountList);
    hold on
    plot(repNumList);
end

