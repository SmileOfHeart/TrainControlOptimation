function f = AntiForce(veo,pos)
%UNTITLED6 ���㸽������
%��λ��KN
%    �����ٶȵ�λΪm/s
    M=194.295; 
    u=veo*3.6;
    w0=2.031+0.0622*u+0.001807*u*u;
    wi=RoadGradinet(pos);
    %wr
    %ws
    f=(w0+wi)*M*9.8/1000;
end


