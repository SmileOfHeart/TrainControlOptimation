function f= BrakeForce(veo)
%UNTITLED3 �����ƶ����߼���������С
%  �����ٶȵ�λΪm/s
%  ������λΪKN
    f=0;
    u=veo*3.6; %��λ����
    if u<77
        f=166 ;
    elseif u<80
        f=0.1314*u*u-25.07*u+1300;  
    end
end

