function f= TrateForce(veo)
%UNTITLED3 ����ǣ�����߼���ǣ������С
%  �����ٶȵ�λΪm/s
    f=0;
    %u=veo;
    u=veo*3.6; %��λ����
    if u<119
        f=300-0.2857*u;
    elseif u<300
        f=8800*3.6/u;  
    end
end
