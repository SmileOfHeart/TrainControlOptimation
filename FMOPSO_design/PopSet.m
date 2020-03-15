classdef PopSet
    %UNTITLED5 个体位置集
    %  每行是一个个体的索引，而且不允许重复
    
    properties
        PopSets=[];
    end
    
    methods
        function obj = PopSet(inputPop)
            %UNTITLED5 构造此类的实例
            %   此处显示详细说明;
            obj.PopSets=[inputPop];
        end
        
        function obj= put(obj,inputPop)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            if obj.IsContain(inputPop)==0
                obj.PopSets=[obj.PopSets;inputPop];
            else
                disp('PopSet:已包含此元素');
            end
        end
        function Pop= randomGetValue(obj)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
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

