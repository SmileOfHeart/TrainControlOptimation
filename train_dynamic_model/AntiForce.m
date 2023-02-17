function f = AntiForce(veo,pos)
%UNTITLED6 计算附加阻力
%单位是KN
%    传入速度单位为m/s
    M=194.295; 
    u=veo*3.6;
    w0=2.031+0.0622*u+0.001807*u*u;
    wi=RoadGradinet(pos);
    %wr
    %ws
    f=(w0+wi)*M*9.8/1000;
end

