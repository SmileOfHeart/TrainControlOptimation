function bool=isKeyEqual(key1,key2)
            %判断两个键值是否相等
            if length(key1)~=length(key2)
                bool=0;
                return ;
            end
            for i=1:length(key1)
                if key1(i)~=key2(i)
                    bool=0;
                    return;
                end
            end
            bool=1;
end

