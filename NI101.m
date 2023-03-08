clear;clc;
daq.getDevices  
global mydata;
% mytime=[];
mydata=[];
s = daq.createSession('ni');       
s.Rate= 1000;   %����Ƶ��                
s.DurationInSeconds = 60;       %����ʱ��  
[ch,idx]=addAnalogInputChannel(s,'cDAQ1Mod1','ai0','Voltage')  %���ͨ��
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
@(src,event) mydraw(h1,h2,event)); %������������
s.NotifyWhenDataAvailableExceeds = 100; %DataAvailable�¼�����ʱ��
s.startBackground(); %��̨����
s.wait();
% mysave(mydata,'ly01','train');%��������

function mydraw(h1,h2,event)
global mydata;
mydata=[mydata;event.Data];
addpoints(h1,event.TimeStamps,event.Data(:,1));
drawnow limitrate
end

function mysave(data,user,use)
new_folder = sprintf('.\\DATA\\Data_%s', user); %ָ��·��
if exist(new_folder,'dir')==0
    mkdir(new_folder); %�½��ļ���
end
savePath=[new_folder, '/',use, '.mat'];
save(savePath, 'data');  %����mat�ļ�
end