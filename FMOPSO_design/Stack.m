classdef Stack
    %UNTITLED �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        values;
        len;
    end
    
    methods
        function obj = Stack()
            %UNTITLED ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.len=0;
            obj.values=[];
        end
        
        function [obj,outputArg]= Pop(obj)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            outputArg=0;
            if obj.len>0
                outputArg = obj.values(obj.len);
                obj.len=obj.len-1;
            else
                disp('stack empty');
            end
        end
        
        function obj= Push(obj,inputArg)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
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

