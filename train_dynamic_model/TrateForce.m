function f= TrateForce(veo)
%UNTITLED3 根据牵引曲线计算牵引力大小
%  传入速度单位为m/s
    f=0;
    u=veo*3.6; %单位换算
    if u<51.5
        f=203;
    elseif u<80
        f=-0.002032*u*u*u+0.4928*u*u-42.13*u+1343;  
    end
end
