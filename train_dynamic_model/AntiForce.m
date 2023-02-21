function f = AntiForce(veo,pos)
%UNTITLED6 计算附加阻力
%单位是KN
%    传入速度单位为m/s
    M=428;
   % u=veo;
    u=veo*3.6;
    w0=0.66+0.00245*u+0.000132*u*u;
    wi=RoadGradinet(pos);
    %wr
    %ws
    f=(w0+wi)*M*9.8/1000;%单位是KN
end

