classdef GridIndexMap
    %UNTITLED �洢 GridIndex - num ��ֵ�ԣ�1��1�ļ���
    % 
    
    properties
       Keys=[];
       Values=[];
    end
    
    
    methods
        
         
        
        function obj = GridIndexMap()
            %UNTITLED ��������ʵ��
            %   �˴���ʾ��ϸ˵��
        end
        
        function value= getValue(obj,key)
            %METHOD1 ���key��Ӧ��value
           for i= 1:GetKeyNum(obj)
               if isKeyEqual(key,obj.Keys(i,:))==1
                   value=obj.Values(i);
                   return ;
               end
           end  
           disp('GridIndexMap:getValue:������key');
        end
        
        function obj=setValue(obj,key,value)
            %METHOD1 ���key��Ӧ��value
           for i= 1:GetKeyNum(obj)
               %���������ֱ������ֵ
               if isKeyEqual(key,obj.Keys(i,:))==1
                   obj.Values(i)=value;
                   return ;
               end
           end 
           %�������������Ӳ�����ֵ
           obj.Keys=[obj.Keys;key];
           obj.Values=[obj.Values;value];
        end
        
        function bool=isKey(obj,key)
            %�ж��Ƿ���ڼ�key
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
            %��ü��������ͳ���
            [m,n]=size(obj.Keys);
            len=m;
        end
        
        function key=GetKeyByRouletteWheel(obj)
            %��ĳ������ķ������Key,�������Roulette-Wheel��
            sumFit=obj.Values;
            setNum=length(sumFit);
            key=0;
            for i=2:setNum
                sumFit(i)=sumFit(i-1)+sumFit(i);
            end           
            sumFit=sumFit/sum(obj.Values);%��һ������
            index=findIndex(sumFit,rand())+1;
            if setNum ==0
                disp('GridIndexMap:GetKeyByRouletteWheel:������key');
                return;
            end
            if(index>setNum)
                index=setNum;
            end
            key=obj.Keys(index,:);
        end
    end
    
end




