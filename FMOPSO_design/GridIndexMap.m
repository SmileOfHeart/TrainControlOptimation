classdef GridIndexMap
    %UNTITLED 存储 GridIndex - num 键值对，1对1的集合
    % 
    
    properties
       Keys=[];
       Values=[];
    end
    
    
    methods
        
         
        
        function obj = GridIndexMap()
            %UNTITLED 构造此类的实例
            %   此处显示详细说明
        end
        
        function value= getValue(obj,key)
            %METHOD1 获得key对应的value
           for i= 1:GetKeyNum(obj)
               if isKeyEqual(key,obj.Keys(i,:))==1
                   value=obj.Values(i);
                   return ;
               end
           end  
           disp('GridIndexMap:getValue:不存在key');
        end
        
        function obj=setValue(obj,key,value)
            %METHOD1 获得key对应的value
           for i= 1:GetKeyNum(obj)
               %如果包含则直接设置值
               if isKeyEqual(key,obj.Keys(i,:))==1
                   obj.Values(i)=value;
                   return ;
               end
           end 
           %如果不包含则添加并设置值
           obj.Keys=[obj.Keys;key];
           obj.Values=[obj.Values;value];
        end
        
        function bool=isKey(obj,key)
            %判断是否存在键key
            for i= 1:GetKeyNum(obj)
               keyt=obj.Keys(i,:);
               if isKeyEqual(key,keyt)==1
                   bool=1;
                   return;
               end           
            end 
            bool=0;
        end
        
        function keys=keys(obj)
            keys=obj.Keys;
        end     
        
        
        
        function len=GetKeyNum(obj)
            %获得键的数量和长度
            [m,n]=size(obj.Keys);
            len=m;
        end
        
        function key=GetKeyByRouletteWheel(obj)
            %以某种特殊的方法获得Key,这里采用Roulette-Wheel法
            sumFit=obj.Values;
            setNum=length(sumFit);
            key=0;
            for i=2:setNum
                sumFit(i)=sumFit(i-1)+sumFit(i);
            end           
            sumFit=sumFit/sum(obj.Values);%归一化处理
            index=findIndex(sumFit,rand())+1;
            if setNum ==0
                disp('GridIndexMap:GetKeyByRouletteWheel:不存在key');
                return;
            end
            if(index>setNum)
                index=setNum;
            end
            key=obj.Keys(index,:);
        end
    end
    
end




