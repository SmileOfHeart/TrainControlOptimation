function f= BrakeForce(veo)
%UNTITLED3 根据制动曲线计算阻力大小
%  传入速度单位为m/s
%  阻力单位为KN
    f=0;
    u=veo*3.6; %单位换算
    if u<77
        f=166 ;
    elseif u<80
        f=0.1314*u*u-25.07*u+1300;  
    end
end

