clc
clear;
close all;
tic
%������ʼ��
arginitial();
%���ٺ��¶�Լ���������ұ��洦����
CacBrakeSpeedLimit();
[Emax,Tmin]=CacMinTime();
for num=1:1
%��ʽ��ʼ�Ż�

[ExREP,ExChar,REPNum,gridFit,Population,Velocity,enterCountList,repNumList,avgPersonalFitnessList,GobalFitNessList]=FMOPSOmain();
% for i=1:REPNum
%     [flag,Energy,Time,MissError] = CalcEJT(ExREP(i,:),2);
%     disp(['�����ܺģ�',num2str(Energy),'  ����ʱ�䣺',num2str(Time),'  ͣ����',num2str(MissError)])
% end
[flag,Energy,Time,MissError] = CalcEJT(ExREP(1,:),1);   %չʾ�Ż����
str=['Result',num2str(num),'.mat'];
save(str,'ExREP','ExChar','enterCountList','repNumList');
str=['���д���:',num2str(num)];
disp(str);

end
toc
