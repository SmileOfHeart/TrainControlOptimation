function population= CreateInitPopulation(setNum, len,option)
%UNTITLED5产生初始种群
% 输入参数：SetNum  
%           Length    种群中工况转换点个数
%           option 1:只显示个数  2:显示图像
global lowLimit upLimit
      if nargin==2
          option=1;
      end
      n=0;
      population=zeros(setNum,len);
      while n<setNum
             switchPoint = lowLimit + (upLimit -lowLimit).*rand(1,len);
             plotFlag = 0;   % 是否画图，方便debug
             if plotFlag == 1
                 close all;
             end
             [flag,~,~,~,~,switchPoint]=CalcEJT(switchPoint,plotFlag);
             if(flag==0)
                 population(n+1,:)=switchPoint;
                 n=n+1;
             end
             str=['生成种群：',num2str(n)];
             if option==1
                disp(str);
             elseif option==2 &&flag==0             
                disp(str);
                DispRuningCurve(switchPoint);
             end
      end
end




