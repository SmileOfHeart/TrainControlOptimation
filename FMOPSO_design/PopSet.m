classdef PopSet
    %UNTITLED5 ����λ�ü�
    %  ÿ����һ����������������Ҳ������ظ�
    
    properties
        PopSets=[];
    end
    
    methods
        function obj = PopSet(inputPop)
            %UNTITLED5 ��������ʵ��
            %   �˴���ʾ��ϸ˵��;
            obj.PopSets=[inputPop];
        end
        
        function obj= put(obj,inputPop)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            if obj.IsContain(inputPop)==0
                obj.PopSets=[obj.PopSets;inputPop];
            else
                disp('PopSet:�Ѱ�����Ԫ��');
            end
        end
        function Pop= randomGetValue(obj)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            [m,n]=size(obj.PopSets);
            Pop=obj.PopSets(unidrnd(m),:);
        end
        
        function bool=IsContain(obj,inputPop)
            n=length(obj.PopSets);
            for i=1:n
                if obj.PopSets(i)==inputPop
                   bool=1;
                    return;
                end
            end
            bool=0;
        end
        
    end
end

