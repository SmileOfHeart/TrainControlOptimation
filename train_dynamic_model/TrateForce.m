function f= TrateForce(veo)
%UNTITLED3 ����ǣ�����߼���ǣ������С
%  �����ٶȵ�λΪm/s
    f=0;
    u=veo*3.6; %��λ����
    if u<51.5
        f=203;
    elseif u<80
        f=-0.002032*u*u*u+0.4928*u*u-42.13*u+1343;  
    end
end
