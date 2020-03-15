classdef Stack
    %UNTITLED 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        values;
        len;
    end
    
    methods
        function obj = Stack()
            %UNTITLED 构造此类的实例
            %   此处显示详细说明
            obj.len=0;
            obj.values=[];
        end
        
        function [obj,outputArg]= Pop(obj)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            outputArg=0;
            if obj.len>0
                outputArg = obj.values(obj.len);
                obj.len=obj.len-1;
            else
                disp('stack empty');
            end
        end
        
        function obj= Push(obj,inputArg)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            obj.len=obj.len+1;
            obj.values(obj.len)=inputArg;
        end
        
        function bool=IsEmpty(obj)
            if obj.len==0
                bool=1;
            else
                bool=0;
            end
        end
    end
end

