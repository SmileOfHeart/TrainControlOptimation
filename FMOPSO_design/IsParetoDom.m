function  state = IsParetoDom(A,B,len,type)
%UNTITLED �ж�����A������B��֮���Pareto��ϵ
%len��ʾ�Ƚ�����A��B��ǰK�������ǵ����ȼ������������Ǹ����ȼ�����
%Լ��������Ŀ��������ȼ�����
%type��ʾ��max���Ż���0������min���Ż���1��
%ConAllowԼ���������ڴ˷�Χ�ڵ�Լ������������Pareto֧��
%max���Ż���0����>ConAllow            min���Ż���1��  <ConAllow
%state=0   A Pareto Dominante B
%state=1   B Pareto Dominante A
%state=2   A B ������ Pareto֧��
%state=3   A=B
state=2; %�ȼ��軥�඼��֧��
n=length(A);
%�ж��Ƿ�������
Dis=(A-B)*(A-B)';
if(Dis<0.0001)
    state=3;
    return ;
end
%��ʽ��ʼ�Ƚ�
if type==0
    %����󻯵�����
        %�����ȼ��Ƚ�
        AGreatBFlag=zeros(1,n-len);%����ȽϽ��  -1 0 1  С�� ���� ����
        for i=len+1:n
            if A(i)>B(i)
                AGreatBFlag(i)=1;         
            elseif A(i)<B(i)
                AGreatBFlag(i)=-1;         
            end        
        end
        if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0)
           %ȫΪ�Ǹ�����A֧��B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0)
           %ȫΪ1��B֧��1;
           state=1;
           return;
        end
        %�����ȼ��Ƚ� 
        AGreatBFlag=zeros(1,len);%����ȽϽ��
        for i=1:len
            %��Ŀ��,��A,B�໥��Pareto֧��ı�־
            if A(i)>B(i)
                 AGreatBFlag(i)=1;   
            elseif A(i)<B(i)
                 AGreatBFlag(i)=-1;  
            end
        end
         if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0)
           %ȫΪ�Ǹ�����A֧��B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0)
           %ȫΪ1��B֧��1;
           state=1;
           return;
        end
%% ��С������ıȽ�
else
    %����С��������
     %�����ȼ��Ƚ�
        AGreatBFlag=zeros(1,n-len);%����ȽϽ��
        for i=len+1:n
            if A(i)>B(i)
                AGreatBFlag(i)=1;         
            elseif A(i)<B(i)
                AGreatBFlag(i)=-1;         
            end        
        end
        if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0)
           %ȫΪ�Ǹ�����A֧��B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0) 
           %ȫΪ1��B֧��1;
           state=1;
           return;
        end
         %�����ȼ��Ƚ� 
        AGreatBFlag=zeros(1,len);%����ȽϽ��
        for i=1:len
            %��Ŀ��,��A,B�໥��Pareto֧��ı�־
            if A(i)>B(i)
                 AGreatBFlag(i)=1;   
            elseif A(i)<B(i)
                 AGreatBFlag(i)=-1;  
            end
        end
         if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0) 
           %ȫΪ�Ǹ�����A֧��B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0)
           %ȫΪ1��B֧��1;
           state=1;
           return;
        end
     
end

end

