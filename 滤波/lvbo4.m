function lvbo3
%binx文件选择进行小波分层处理或滤波处理保存为binx
clear all;
% renamefiles(getfilelist3());

% delfiles(getfilelist3());% delete files with 'hamm'in its name
do(getfilelist3());% go to filtering or wavelet transforming

end
%%
function file=getfilelist1()
[filename, pathname] = uigetfile('H:\*.binx', 'Pick files','MultiSelect', 'on');
if isnumeric(filename);return;end
if ischar(filename)
    filename={filename};
end
Nfile=length(filename);
if Nfile==0 ;return; end
filecount=0;
file={};
for i=1:Nfile
    if isempty(strfind(filename{i},'hamming'))
        filecount=filecount+1;
        file{filecount}=fullfile(pathname,filename{i});   
    end
end
end

%% 3级文件夹
function filepath=getfilelist3()
folder_name = uigetdir('h:\', 'Pick an maindir');
if folder_name==0
    return;
end
subdir1 = dir(folder_name);
number =0;N =0;allpath ={};
for i = 3 : length(subdir1)
    if ~(isequal(subdir1(i).name,'.')||isequal(subdir1(i).name,'..')||~subdir1(i).isdir)
        number = number + 1;
        sub1path{number}= [folder_name,'\',subdir1(i).name]; 
        subdir2{number} = dir(sub1path{number});
        for j = 1 :length(subdir2{number})-2
            sub2path{number,j} = [sub1path{number},'\',subdir2{1,number}(j+2).name];
            if isdir(sub2path{number,j})
                N = N + 1;
                allpath{N} =  sub2path{number,j};
            end
        end
    end
end  
filepath = {};
if isequal(allpath,{}) && ~isequal(sub2path,{})
    tempfilepath = reshape(sub2path,[],1);
    allnum = 0;
    for i = 1:length(tempfilepath)
        if ~isequal(tempfilepath{i},[])
            [pathstr,name,ext]=fileparts([tempfilepath{i}]);
            if isequal(ext,'.binx')
                allnum = allnum +1;
                filepath{allnum}=tempfilepath{i};
            end
        end
    end
else
        allnum = 0;
        for i = 1 : N
            files = dir(allpath{i});
            for j = 3 : length(files)
                [pathstr,name,ext]=fileparts( [allpath{i},'\',files(j).name]);
                if isequal(ext,'.binx')
                    allnum = allnum +1;
                    filepath{allnum}=[allpath{i},'\',files(j).name];
                end
            end
        end
end
end
%-----------------
%%
function  do(filepath)
filename=filepath';filepath=[];
Nfile=length(filename);
if Nfile==0 ;return; end
filecount=0;
for i=1:Nfile
    if isempty(strfind(filename{i},'hamming'))
        filecount=filecount+1;
        file{filecount}=filename{i};   
    end
end
filename=file';
for i = 1:length(filename)
file=filename{i};
%----- --------- - --- -- ---
fid = fopen(file,'rb','l');
while ~feof(fid)  
fg = fread(fid,40,'*char');%station name,char[32] &&channel name,char[8]
fg1 = fread(fid,2,'*uint');%sample numerator[4]&& sample denominator[4]
fg2 = fread(fid,1,'int64');%filetime begin time,int64[8]
fg3 = fread(fid,8,'*char');% data type ,char[8]
freserved = fread(fid,960,'*char');%reserved char[960]
Signal_Anal = fread(fid,'*int32');%data int32
end
fclose(fid);
slength=length(Signal_Anal);
%         outA=zeros(slength,Level_Anal);% approximate part
outD=zeros(slength,1);% detail part

%% 选择进行滤波还是小波变换
processing='xiaobo';
% processing='lvbo';

switch processing
%-------------------------------------------
%% 小波分层
case 'xiaobo'
Wavelet_Name='db6';%'db6';
Level_Anal=8;
[coefs,longs] = wavedec(double(Signal_Anal),Level_Anal,Wavelet_Name);
for Level_i=1:Level_Anal
    outD = wrcoef('d',coefs,longs,Wavelet_Name,Level_i);
    savefilename_part2=[file(1:end-5),'.',Wavelet_Name,'.D',num2str(Level_i),'.binx'];
    fod = fopen(savefilename_part2,'wb','l');% 'l' represents little_endian ordering
    fwrite(fod,fg,'*char');  
    fwrite(fod,fg1,'*uint');   % write sample fs: numerator/denominator
    fwrite(fod,fg2,'*int64');     %write filetime
    fwrite(fod,fg3,'*char');  %write data type
    reserved = [Wavelet_Name,'Level',num2str(Level_i),'d',num2str(Level_i)];
    fwrite(fod,reserved,'*char');  
    fwrite(fod,zeros(960-length(reserved),1),'*char');
    fwrite(fod,int32(outD),'*int32'); %write data
    fclose(fod);      %close file
end

if(rem(i,30)==0)
disp(fg');
end

% disp(fg');
%% ---------------------------------------------
case 'lvbo'
%%                 [2,15,30,60,120];
p=[2,15,30,60,120];%[1/9,1/8];
for g=1:4;%[1,2,4]
%截止频率，(秒)
   cf1=p(g);%15*p;
   cf2=p(g+1);%2*cf1;
%    filtered=int32(filterD1(cf1,cf2,double(Signal_Anal)));
    filtered=int32(myZerophfilter(cf1,cf2,double(fg1(1))/double(fg1(2)),1000,double(Signal_Anal)));
    
   if cf1<0.5
       savefilename_part2=[file(1:end-5),'.hamm.',num2str(1/cf2),'-',num2str(1/cf1),'Hz.binx'];
   else
    savefilename_part2=[file(1:end-5),'.hamm',num2str(cf1),'-',num2str(cf2),'s.binx'];
   end
    fod = fopen(savefilename_part2,'wb','l');% 'l' represents little_endian ordering
    fwrite(fod,fg,'*char');
    fwrite(fod,fg1,'*uint');   % write sample fs: numerator/denominator
    fwrite(fod,fg2,'*int64');  %write filetime
    fwrite(fod,fg3,'*char');  %write data type
    reserved = ['hamming',num2str(cf1),'-',num2str(cf2),'s'];
    fwrite(fod,reserved,'*char');  
    fwrite(fod,zeros(960-length(reserved),1),'*char');
    fwrite(fod,int32(filtered),'*int32'); %write data
    fclose(fod);      %close file
%     disp(savefilename_part2);
end
end
if(rem(i,18)==0)
disp(file);
end
pause(0.001);
end
disp('well done');
end
%-------------------------
%% matlabpool close
function out=filterD1(f2,f1,data)
%design filter 4-7s ,fs=1hz
%f1 second of cutoff freq1,
%f2 second of cutoff freq2
%sample:filterD1(4,7,x);  filter from 4s to 7s
% All frequency values are in Hz.

Fs = 1;  % Sampling Frequency
N    = 80000;      % Order
Fc1  = 1/f1;%7s   % First Cutoff Frequency
Fc2  = 1/f2;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

if Fc2==(Fs/2)
    Fc2=Fc2-0.0001;
end
% Calculate the coefficients using the FIR1 function.
[b,a] = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);
% out=filtfilt(b,a,data);\
out=filter(b,a,data);
end
% -------------------------

%% another zero phase filter
function out=myZerophfilter(f2,f1,fs,order,data)
Fs = fs;  % Sampling Frequency
N    = order;      % Order
Fc1  = 1/f1;%7s   % First Cutoff Frequency
Fc2  = 1/f2;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

if Fc2==(Fs/2)
    Fc2=Fc2-0.0001;
end
% Calculate the coefficients using the FIR1 function.
[b,a] = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);
% out=filtfilt(b,a,data);
out=filter(b,a,data);
end

%% 删除文件
function delfiles(fnames)
fnames=fnames';
Nfile=length(fnames);
if Nfile==0 ;return; end
filecount=0;
for i=1:Nfile
    if ~isempty(strfind(fnames{i},'hamm'))
        %找到滤波的文件，删除
       delete(fnames{i});
    end
end
disp('well done');
end
%% 重命名
function renamefiles(fnames)
fnames=fnames';
Nfile=length(fnames);
if Nfile==0 ;return; end
filecount=0;
for i=1:Nfile
    tempname=strrep(fnames{i},'02271600','02281600');
    tempname=strrep(tempname,'03301600','03311600');
    tempname=strrep(tempname,'04291600','04301600');
    tempname=strrep(tempname,'05301600','05311600');
    newnames{i}=tempname;
    if ~isequal(fnames{i},tempname)
    movefile(fnames{i},tempname);
    
    end
end
disp('rename done');
end