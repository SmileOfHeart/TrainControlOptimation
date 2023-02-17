function arginitial( )
%相关参数的初始设置，包列车相关参数，线路条件和限速
%   Detailed explanation goes here
global MAXACC MAXBACC INTERDIS TRAINWGH TRAVDIS TRAINLEN COADIS DESINTIME...
    COMFACC...
    SPDLIMARRAY GRAARRAY STARTPOINT ENDPOINT SWITCHNUM ReGenRate ...
    EMAX TMSTEPLEN Tmin stateTable Tmax  upLimit lowLimit;
TRAINWGH =194.295;                      %列车质量t
MAXACC = 1;                           %最大加速度m/s^2
MAXBACC = 1;                            %最大减速度m/s^2
TRAINLEN = 0;                           %列车长度
COADIS = 30;                            %最小惰行距离m
COMFACC = 0.5;                          %舒适性加速度变化率(m/s^2)/s
ReGenRate=0.3;                            %再生制动产能率
EMAX=0;                         %最大运行能耗
TMSTEPLEN=0.1;                  %仿真时间步长
Tmin=0;                         %最小运行时间
Tmax=300;                         %最长运行时间
DESINTIME= 105;                  %计划时间
%1宋家庄-肖村段
SPDLIMARRAY = [173.7,451.2,695.3,1264.6,2686,2806; 55,80,65,80,55,55];  
% SPDLIMARRAY = [173.7,2806; 80,50];  
GRAARRAY = [173.7,335,	535,	865,	1525,	2055,	2425,	2625 ;-2,-3,	12,	3.15,-8,3,4.25,	-2 ]; 
% GRAARRAY = [173.7,	865,	1925,	2425,	2625 ;-2, -15,   -4.25, 0, 2 ]; 
ENDPOINT=2806;                           %旅行终点
% SPDLIMARRAY = [0,2400;80,50];
% GRAARRAY = [0,2400;0,0];
STARTPOINT=173.7;                           %旅行起
%2肖村-小红门站
% SPDLIMARRAY = [2806,3961,4081; 80,55,0];  
% GRAARRAY = [2625	2945	3325	3745 ;-2	-3.84	8	2 ]; 
% STARTPOINT=2806;                        %旅行起点
% ENDPOINT=4081;                           %旅行终点
%3小红门-旧宫站
% SPDLIMARRAY = [4081	6044.9		6327	6447;	80	75	55	0];  
% GRAARRAY = [4115	4375	4535	4975	5375	5975	6225 ;-20	-23.8	-24	0	-2	-3.2	0 ]; 
% STARTPOINT=4081;                        %旅行起点
% ENDPOINT=6447;                           %旅行终点
%4旧宫站-亦庄桥站
% SPDLIMARRAY = [6447 6457.6	8309	8429 ;55 80 55 0];  
% GRAARRAY = [6545	6945	7325	7590	7850;3.25	2.8	-15.6	9	0];
% GRAARRAY = [6545	6945	7325	7590	7850;0 0 0	0 0];
% STARTPOINT=6447;                        %旅行起点
% ENDPOINT=8429;                           %旅行终点

%5亦庄桥站-亦庄文化园站
% SPDLIMARRAY = [8429	9302	9423.9;	80	55 0];  
% GRAARRAY = [7850 8550	8910	9210;0	5	-2	0];
% STARTPOINT=8429;                        %旅行起点
% ENDPOINT=9422;   

%6亦庄文化园站-万源街站
SPDLIMARRAY = [9302 9423.9	10840	10960;55 80	55	0];  
% GRAARRAY = [9210 9540	9980	10300	10780;0	-2	5	2.96	0];
GRAARRAY = [9210 9540	9980	10300	10780;0	0	0	0	0];
STARTPOINT=9422;                        %旅行起点
ENDPOINT=10960;   

%7万源街-荣京东街
% SPDLIMARRAY = [10960 12120 12240 ; 80 55	50];  
% GRAARRAY = [10780 11040	11600	12000	12290 ;0  2	-3	 0	0 ]; 
% STARTPOINT=10960;                        %旅行起点
% ENDPOINT=12240;                           %旅行终点

%8荣京东街-荣昌东街
% SPDLIMARRAY = [12240	13474	13594;	80	55	0];  
% GRAARRAY = [12290	12910	13290;	3.5	-1.8	0];
% STARTPOINT=12240;                        %旅行起点
% ENDPOINT=13594;   

%9荣昌东街-同济南路
% SPDLIMARRAY = [13594	14884.8	15535.2	15812	15932;	80	70	80	55	0];  
% GRAARRAY = [13700	14100	14720	15350	15650;	-0.5	1.5	-1	6.135	0];
% STARTPOINT=13594;                        %旅行起点
% ENDPOINT=15932;   

%10同济南路-经海路站
% SPDLIMARRAY = [15932	18077	18197;	80	55	0];  
% GRAARRAY = [15650	16180	16500	16870	17310	17990;	0	-8	-3	5	1.35	0];
% STARTPOINT=15932;                        %旅行起点
% ENDPOINT=18197;   

%11经海路站-次渠南站
% SPDLIMARRAY = [18197	20163	20283;	80	55	0];  
% GRAARRAY = [17990	18310	18660	19360	19600	19950;	0	15.5	24	-3	10.105	2];
% STARTPOINT=18197;                        %旅行起点
% ENDPOINT=20283;   

%12次渠南站-次渠站
% SPDLIMARRAY = [20283	21449	21569;	80	55	0];  
% GRAARRAY = [19950	20295	20970	21405;	2	-3	3	2];
% STARTPOINT=20283;                        %旅行起点
% ENDPOINT=21569;   

%13次渠站-亦庄火车站
% SPDLIMARRAY = [21569	22783	22903;	80	55	0];  
% GRAARRAY = [21405	21655	21855	22250	22590;	2	20	3.13	-19.7	2];
% STARTPOINT=21569;  %旅行起点
% ENDPOINT=22903;   




INTERDIS =ENDPOINT- STARTPOINT;          %站间距m
TRAVDIS = INTERDIS + TRAINLEN;          %旅行距离



if INTERDIS < 4096
    SWITCHNUM=3;                    %工况转换点数量 必须为偶数
    stateTable=[2,1,0 -2];           %4工况表：2.牵引；1.巡航；0.惰行；-2.制动
    upLimit  =  [9822  10560 10960];                        %解的上限
    lowLimit =  [9422  9522  10360];                         %解的下限	    
elseif INTERDIS < 2048
    SWITCHNUM=5;                    %工况转换点数量 必须为偶数
    stateTable=[2,0,2,1,0,-2];           %4工况表：2.牵引；1.巡航；0.惰行；-2.制动
	upLimit  =  [260  550  600  2500   2806];                        %解的上限
	lowLimit =  [230  420  450  865    2500];                         %解的下限	
elseif INTERDIS < 4096
    SWITCHNUM = 6 ;                    %工况转换点数量 必须为偶数
    stateTable=[2,1,0,2,1,0,-2];      %8工况表：2.牵引；1.巡航；0.惰行；-2.制动
	upLimit  =  [260  550  600  1200  2500  2806];                        %解的上限
	lowLimit =  [230  420  450  865   1200  2500];                         %解的下限	
end





end

