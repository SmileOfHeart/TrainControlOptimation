clc
clear;
close all;
tic
%参数初始化
arginitial();
%限速和坡度约束处理，并且保存处理结果
CacBrakeSpeedLimit();
[Emax,Tmin]=CacMinTime();

%多目标粒子群算法参数
options.PopulationSize = 10;  %种群大小  
options.MaxGenerations = 10;  %算法最大迭代次数
options.Continue = 0 ;  %是否继续原来的优化，如果要继续则要传入种群options.Pop和速度参数options.Veo
for num=1:1
%正式开始优化
[ExREP,ExChar,REPNum,gridFit,Population,Velocity,enterCountList,repNumList,avgPersonalFitnessList,GobalFitNessList]=FMOPSO_d(options);
% for i=1:REPNum
%     [flag,Energy,Time,MissError] = CalcEJT(ExREP(i,:),2);
%     disp(['运行能耗：',num2str(Energy),'  运行时间：',num2str(Time),'  停车误差：',num2str(MissError)])
% end
[flag,Energy,Time,MissError] = CalcEJT(ExREP(1,:),1);   %展示优化结果
str=['Result',num2str(num),'.mat'];
save(str,'ExREP','ExChar','enterCountList','repNumList');
str=['运行次数:',num2str(num)];
disp(str);

end
toc
