function f= TrateForce(veo)
%UNTITLED3 根据牵引曲线计算牵引力大小
%  传入速度单位为m/s
    f=0;
    %u=veo;
    u=veo*3.6; %单位换算
    if u<119
        f=300-0.2857*u;
    elseif u<300
        f=8800*3.6/u;  
    end
end
