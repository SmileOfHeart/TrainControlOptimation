classdef  GridIndexSet
    %UNTITLED4 �洢 GridIndex - Pos ����
    % һ�� GridIndex���Զ�Ӧ���pos
    
    properties
        Keys=[]; %���Ǹ��ӵ�����
        Values=[]; %ֵ����������ģ�������һ�������б�Popset��Popset�����Ԫ�ظ����ɱ�
    end
    
    methods
        function obj = GridIndexSet()
            %UNTITLED4 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
        end
        
        function obj=AddValue(obj,key,value)
             %METHOD1 ��Ӽ�ֵ��
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
            %METHOD1 ���key��Ӧ��value
           for i= 1:GetKeyNum(obj)
               if isKeyEqual(key,obj.Keys(i,:))==1
                   PopSet=obj.Values(i);
                   value=PopSet.randomGetValue;
                   return ;
               end
           end 
           disp('GridIndexSet:������key');
        end
        
        function len=GetKeyNum(obj)
            [m,n]=size(obj.Keys);
            len=m;
        end
        
    end
end

