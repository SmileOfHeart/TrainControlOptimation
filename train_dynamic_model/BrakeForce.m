function f= BrakeForce(veo)
%UNTITLED3 �����ƶ����߼���������С
%  �����ٶȵ�λΪm/s
%  ������λΪKN
    f=0;
    %u=veo;
    u=veo*3.6; %��λ����
    if u<5
        f=59.8*u;
    elseif u<106.7
        f=300-0.2851*u; 
    elseif u<400
         f=28880*3.6/u;
    end
end

