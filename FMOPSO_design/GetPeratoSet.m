function  domIndex_vector = GetPeratoSet(InitSet,len,type)
%UNTITLED �ӳ�ʼ��Ӧ�Ƚ⼯�л�ȡPareto���ż�
%InitSet��ʼ�⼯��ÿ����һ����
%len��ʾ�Ƚ�����A��B��ǰK�������ǵ����ȼ������������Ǹ����ȼ�����
%Լ��������Ŀ��������ȼ�����
%type��ʾ��max���Ż���0������min���Ż���1��
%   �˴���ʾ��ϸ˵��
[m,~]=size(InitSet);
domIndex_vector=ones(m,1);%�Ƿ���ȫ�����Ž�ı�־
%��������
for num=1:m
         %�ж��Ƿ�Pareto֧��          
         out=unidrnd(m,[1,2]);
         i=out(1);
         j=out(2);
         while i == j
               out=unidrnd(m,[1,2]);
                i=out(1);
                j=out(2);
         end
         state = IsParetoDom(InitSet(i,:),InitSet(j,:),len,type);
         if state==0 ||state==3
                 domIndex_vector(j)=0;
         elseif state==1
                 domIndex_vector(i)=0;
         end
         
         if sum(InitSet(i,:))==0
             domIndex_vector(i)=0;
         end
         if sum(InitSet(j,:))==0
             domIndex_vector(j)=0;
         end
end
end

