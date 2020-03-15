function  state = IsParetoDom(A,B,len,type)
%UNTITLED 判断向量A和向量B是之间的Pareto关系
%len表示比较向量A和B的前K个分量是低优先级分量，后面是高优先级分量
%约束变量比目标分量优先级更高
%type表示是max最优化（0）还是min最优化（1）
%ConAllow约束允许误差，在此范围内的约束变量不存在Pareto支配
%max最优化（0）：>ConAllow            min最优化（1）  <ConAllow
%state=0   A Pareto Dominante B
%state=1   B Pareto Dominante A
%state=2   A B 不存在 Pareto支配
%state=3   A=B
state=2; %先假设互相都不支配
n=length(A);
%判断是否近似相等
Dis=(A-B)*(A-B)';
if(Dis<0.0001)
    state=3;
    return ;
end
%正式开始比较
if type==0
    %求最大化的问题
        %高优先级比较
        AGreatBFlag=zeros(1,n-len);%保存比较结果  -1 0 1  小于 等于 大于
        for i=len+1:n
            if A(i)>B(i)
                AGreatBFlag(i)=1;         
            elseif A(i)<B(i)
                AGreatBFlag(i)=-1;         
            end        
        end
        if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0)
           %全为非负数则A支配B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0)
           %全为1则B支配1;
           state=1;
           return;
        end
        %低优先级比较 
        AGreatBFlag=zeros(1,len);%保存比较结果
        for i=1:len
            %求目标,再A,B相互不Pareto支配的标志
            if A(i)>B(i)
                 AGreatBFlag(i)=1;   
            elseif A(i)<B(i)
                 AGreatBFlag(i)=-1;  
            end
        end
         if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0)
           %全为非负数则A支配B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0)
           %全为1则B支配1;
           state=1;
           return;
        end
%% 最小化问题的比较
else
    %求最小化的问题
     %高优先级比较
        AGreatBFlag=zeros(1,n-len);%保存比较结果
        for i=len+1:n
            if A(i)>B(i)
                AGreatBFlag(i)=1;         
            elseif A(i)<B(i)
                AGreatBFlag(i)=-1;         
            end        
        end
        if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0)
           %全为非负数则A支配B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0) 
           %全为1则B支配1;
           state=1;
           return;
        end
         %低优先级比较 
        AGreatBFlag=zeros(1,len);%保存比较结果
        for i=1:len
            %求目标,再A,B相互不Pareto支配的标志
            if A(i)>B(i)
                 AGreatBFlag(i)=1;   
            elseif A(i)<B(i)
                 AGreatBFlag(i)=-1;  
            end
        end
         if prod(AGreatBFlag<=0)&&sum(AGreatBFlag<0) 
           %全为非负数则A支配B;
           state=0;        
           return;
        end
        if prod(AGreatBFlag>=0)&&sum(AGreatBFlag>0)
           %全为1则B支配1;
           state=1;
           return;
        end
     
end

end

