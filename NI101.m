clear;clc;
daq.getDevices  
global mydata;
% mytime=[];
mydata=[];
s = daq.createSession('ni');       
s.Rate= 1000;   %采样频率                
s.DurationInSeconds = 60;       %采样时间  
[ch,idx]=addAnalogInputChannel(s,'cDAQ1Mod1','ai0','Voltage')  %添加通道
%set(s.Channels,'InputType','SingleEnded') ;
ch.TerminalConfig = 'SingleEnded';

axes1=axes('position',[0.15 0.65 0.75 0.27]);
axes2=axes('position',[0.15 0.38 0.75 0.27]);
axes1.YGrid = 'on';
axes2.YGrid = 'on';
set(axes1,'YLim',[-15 15]);
set(axes2,'YLim',[-15 15]);
set(axes1,'Xtick','');
h1 = animatedline(axes1,'MaximumNumPoints',3000);
h2 = animatedline(axes2,'MaximumNumPoints',3000);

lh = addlistener(s,'DataAvailable',...
@(src,event) mydraw(h1,h2,event)); %创建监听程序
s.NotifyWhenDataAvailableExceeds = 100; %DataAvailable事件触发时间
s.startBackground(); %后台启动
s.wait();
% mysave(mydata,'ly01','train');%保存数据

function mydraw(h1,h2,event)
global mydata;
mydata=[mydata;event.Data];
addpoints(h1,event.TimeStamps,event.Data(:,1));
drawnow limitrate
end

function mysave(data,user,use)
new_folder = sprintf('.\\DATA\\Data_%s', user); %指定路径
if exist(new_folder,'dir')==0
    mkdir(new_folder); %新建文件夹
end
savePath=[new_folder, '/',use, '.mat'];
save(savePath, 'data');  %保存mat文件
end