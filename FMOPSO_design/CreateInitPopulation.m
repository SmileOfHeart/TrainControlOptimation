function population= CreateInitPopulation(setNum, len,option)
%UNTITLED5������ʼ��Ⱥ
% ���������SetNum  
%           Length    ��Ⱥ�й���ת�������
%           option 1:ֻ��ʾ����  2:��ʾͼ��
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
             str=['������Ⱥ��',num2str(n)];
             if option==1
             disp(str);
             elseif option==2 &&flag==0             
             disp(str);
             DispRuningCurve(switchPoint);
             end
      end
end




