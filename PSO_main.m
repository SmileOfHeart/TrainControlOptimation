clc
clear;
close all;
t0=cputime;
%������ʼ��
arginitial();
%���ٺ��¶�Լ���������ұ��洦����
CacBrakeSpeedLimit();
[Emax,Tmin]=CacMinTime();

%��Ŀ������Ⱥ�㷨����
options.PopulationSize = 10;  %��Ⱥ��С  
options.MaxGenerations = 100;  %�㷨����������
options.Continue = 0 ;  %�Ƿ����ԭ�����Ż������Ҫ������Ҫ������Ⱥoptions.Pop���ٶȲ���options.Veo
%��ʽ��ʼ�Ż�
for num=1:1
    disp(['���д�����',num2str(num)]);
    [res,pos,velo]=PSO_d(options);
    figure('Name','�Ż����');
    [flag,Energy,Time,MissError,overSpeed,sw,jerk] = CalcEJT(res,1);
    fitness = CacFitNess(Energy,Time,MissError,overSpeed,jerk);
    disp(['�����ܺģ�',num2str(Energy),' ����ʱ�䣺',num2str(Time), '  ͣ����',num2str(MissError),'  ��������',num2str(overSpeed) ,'   ���ʶȣ�',num2str(jerk)])
    runTime=cputime-t0;
    Charaters=[Energy,Time,MissError,overSpeed,sw,jerk,fitness];
    save('Result.mat','Charaters');
     %��������
	 str=['Resul',num2str(num)];
     save(str, 'Charaters');
     %fid = fopen('0513data.txt','a+');
     %for i= 1:length(Charaters)
     %   fprintf(fid,'%.4f   ',Charaters(i));
     %end
     %fprintf(fid,'\r\n');
     %fclose(fid);
end