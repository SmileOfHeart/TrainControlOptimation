clc
clear;
close all;
t0=cputime;
%参数初始化
arginitial();
%限速和坡度约束处理，并且保存处理结果
CacBrakeSpeedLimit();
[Emax,Tmin]=CacMinTime();

%多目标粒子群算法参数
options.PopulationSize = 10;  %种群大小  
options.MaxGenerations = 100;  %算法最大迭代次数
options.Continue = 0 ;  %是否继续原来的优化，如果要继续则要传入种群options.Pop和速度参数options.Veo
%正式开始优化
for num=1:1
    disp(['运行次数：',num2str(num)]);
    [res,pos,velo]=PSO_d(options);
    figure('Name','优化结果');
    [flag,Energy,Time,MissError,overSpeed,sw,jerk] = CalcEJT(res,1);
    fitness = CacFitNess(Energy,Time,MissError,overSpeed,jerk);
    disp(['运行能耗：',num2str(Energy),' 运行时间：',num2str(Time), '  停车误差：',num2str(MissError),'  超限速误差：',num2str(overSpeed) ,'   舒适度：',num2str(jerk)])
    runTime=cputime-t0;
    Charaters=[Energy,Time,MissError,overSpeed,sw,jerk,fitness];
    save('Result.mat','Charaters');
     %保存数据
	 str=['Resul',num2str(num)];
     save(str, 'Charaters');
     %fid = fopen('0513data.txt','a+');
     %for i= 1:length(Charaters)
     %   fprintf(fid,'%.4f   ',Charaters(i));
     %end
     %fprintf(fid,'\r\n');
     %fclose(fid);
end