function  domIndex_vector = GetPeratoSet(InitSet,len,type)
%UNTITLED 从初始适应度解集中获取Pareto最优集
%InitSet初始解集，每行是一个解
%len表示比较向量A和B的前K个分量是低优先级分量，后面是高优先级分量
%约束变量比目标分量优先级更高
%type表示是max最优化（0）还是min最优化（1）
%   此处显示详细说明
[m,~]=size(InitSet);
domIndex_vector=ones(m,1);%是否是全局最优解的标志
%竞标赛法
for num=1:m
         %判断是否Pareto支配          
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

