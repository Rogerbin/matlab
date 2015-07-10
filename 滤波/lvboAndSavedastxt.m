function lvboAndSavedastxt
%读取txt文件进行小波分解及滤波处理，并保存为txt
[filename, pathname] = uigetfile('H:\数据准备\1Hz,txt\*.txt', 'Pick files','MultiSelect', 'on');
if isnumeric(filename);return;end
if ischar(filename)
    filename={filename};
end
Nfile=length(filename);
if Nfile==0 ;return; end
for i=1:Nfile
   temp=fullfile(pathname,filename{i});
   data=importdata(temp);
   %- -- - ------------
   %filter part
   filterparas=[15,30,60,120];
%    for p=[1,2,4]
   %截止频率，(秒)
   cf1=15*p;
   cf2=2*cf1;
%    cf1=60;
%    cf2=120;
   %design filter 
   filtered=int32(filterD1(cf1,cf2,data));
   %save as txt file
   savefilename=[pathname,filename{i}(1:end-4),'.hamming',num2str(cf1),'.',num2str(cf2),'s.txt'];
   fod=fopen(savefilename,'wt');
   fprintf(fod,'%d\n',filtered(1:end-1));
   fprintf(fod,'%d',filtered(end));
   fclose(fod);
   pause(0.01);
%    end
   %--- --- -- - - - -- - - -
   %   wavelet part
%    waveletfilter(data,temp);
   disp([temp,'--->ok']);
end
% function outd=openonetxt(filename)
%open one txt file and read data to outd

function out=filterD1(f2,f1,data)
%design filter 4-7s ,fs=1hz
%f1 second of cutoff freq1,
%f2 second of cutoff freq2
%sample:filterD1(4,7,x);  filter from 4s to 7s
% All frequency values are in Hz.
Fs = 1;  % Sampling Frequency

N    = 100;      % Order
Fc1  = 1/f1;%7s   % First Cutoff Frequency
Fc2  = 1/f2;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
[b,a] = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
% Hd = dfilt.dffir(b);
out=filtfilt(b,a,data);
%---------------------------
% [h1,w1]=freqz(b,a,8192,1);
% hf=abs(h1).^2;
% hangle=angle(hf);
% figure;
% plot(w1,20*log(hf));
% hold on 
% plot(w1,hangle,'g');
% plot([Fc1 Fc1],get(gca,'ylim'),'r');
% plot([Fc2 Fc2],get(gca,'ylim'),'r');

function waveletfilter(Signal_Anal,temp)
        temp=strrep(temp,'1Hz,txt','1Hz,txt\xiaobo');
        Wave_Name='db6';%'db6';
        Level_Anal=6;
        detailparts=cell(1,6);
        slength=length(Signal_Anal);
        outD=zeros(slength,1);% detail part
        %小波分解
        [coefs,longs] = wavedec(double(Signal_Anal),Level_Anal,Wave_Name);
        for Level_i=1:Level_Anal
            outD = wrcoef('d',coefs,longs,Wave_Name,Level_i);
%           detailparts{1,Level_i}=outD;
           filtered=int32(outD);
           savefilename=strrep(temp,'.1Hz',['.1Hz','.D',num2str(Level_i),'.',Wave_Name]);
           fod=fopen(savefilename,'wt');
           fprintf(fod,'%d\n',filtered(1:end-1));
           fprintf(fod,'%d',filtered(end));
           fclose(fod);
           pause(0.01);
        end