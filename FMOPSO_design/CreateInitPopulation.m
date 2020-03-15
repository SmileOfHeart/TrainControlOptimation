function population= CreateInitPopulation(setNum, len,option)
%UNTITLED5产生初始种群
% 输入参数：SetNum  
%           Length    种群中工况转换点个数
%           option 1:只显示个数  2:显示图像
      if nargin==2
          option=1;
      end
      n=0;
      population=zeros(setNum,len);
      while n<setNum
             switchPoint=tryCreateOneIndivi(len);
             [flag,~,~,~,~,switchPoint]=CalcEJT(switchPoint,0);
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




