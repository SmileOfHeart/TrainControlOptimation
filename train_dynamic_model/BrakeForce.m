function f= BrakeForce(veo)
%UNTITLED3 根据制动曲线计算阻力大小
%  传入速度单位为m/s
%  阻力单位为KN
    f=0;
    %u=veo;
    u=veo*3.6; %单位换算
    if u<5
        f=59.8*u;
    elseif u<106.7
        f=300-0.2851*u; 
    elseif u<400
         f=28880*3.6/u;
    end
end

