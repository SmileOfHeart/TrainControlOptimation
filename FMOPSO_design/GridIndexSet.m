classdef  GridIndexSet
    %UNTITLED4 存储 GridIndex - Pos 集合
    % 一个 GridIndex可以对应多个pos
    
    properties
        Keys=[]; %键是格子的索引
        Values=[]; %值可以是任意的，里面是一个二级列表Popset，Popset里面的元素个数可变
    end
    
    methods
        function obj = GridIndexSet()
            %UNTITLED4 构造此类的实例
            %   此处显示详细说明
        end
        
        function obj=AddValue(obj,key,value)
             %METHOD1 添加键值对
           for i= 1:GetKeyNum(obj)
               if isKeyEqual(key,obj.Keys(i,:))==1
                   obj.Values(i).put(value);
                   return ;
               end
           end 
           obj.Keys=[obj.Keys;key];
           obj.Values=[obj.Values; PopSet(value)];
        end       
        
        function value= getValue(obj,key)
            %METHOD1 获得key对应的value
           for i= 1:GetKeyNum(obj)
               if isKeyEqual(key,obj.Keys(i,:))==1
                   PopSet=obj.Values(i);
                   value=PopSet.randomGetValue;
                   return ;
               end
           end 
           disp('GridIndexSet:不存在key');
        end
        
        function len=GetKeyNum(obj)
            [m,n]=size(obj.Keys);
            len=m;
        end
        
    end
end

