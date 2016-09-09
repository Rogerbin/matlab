maltab 7.0:
mbuild -setup
mex -setup
mcc -B sgl sss.m

%matlab内容保存在word中
%Create the word application

%and make it visible

word = actxserver('Word.Application');
word.Visible = 1;
%Add a new document and get the current selection

document = word.Documents.Add;
selection = word.Selection;
%add text and paragraphs

selection.TypeText('Hello world. ');
selection.TypeText('My name is Professor Kitchin');
selection.TypeParagraph;
selection.TypeText('How are you today?');
selection.TypeParagraph;
%Setting a Header

selection.TypeText('Big Finale');
selection.Style='Heading 1';
selection.TypeParagraph;
%Modifying Header properties

H1 = document.Styles.Item('Heading 1')
H1.Font.Name = 'Garamond';
H1.Font.Size = 20;
H1.Font.Bold = 1;
H1.Font.TextColor.RGB=60000; % some ugly color green

selection.TypeParagraph
selection.TypeText('That is all for today!')
 
%H1 =
 
%	Interface.0002092C_0000_0000_C000_000000000046

%Now we save the document

document.SaveAs2([pwd '/test.docx']);
word.Quit();

% 结束


测试运行时间
tic;w=searchfolder('H:\数据备份SAC20hz','.sac');toc

%----------------------------
%----------------------------
匿名函数
fhandle=@（arglist）express
（1）express是一个matlab变量表达式，比如：x+x.^2，sin（x）等
（2）argilst是参数列表；
（3）符号@是matlab创建函数句柄的操作符，表示创建有输入参数列表arglist和
    表达式express确定的函数句柄，并把这个函数句柄返回给变量fhandle，
     这样，以后就可以通过fhandle来调用定义好的函数了。
f1=@(x)x*2+1;
f1(2)=5;


对array中每个元素进行处理，arrayfun
apply function to each element of array
对数组用匿名函数：
f=@(x)['show ',num2str(x)];
a=1:4;
arrayfun(f,a,'UniformOutput',false)
ans = 

    'show 1'    'show 2'    'show 3'    'show 4'
结果以元胞形式存储
%----------------------
对元胞应用匿名函数：
f=@(name)[name,' exists'];
x={'a.txt','b.txt',  'c.txt'};
cellfun(f,x,'UniformOutput',false)
ans = 

    'a.txt exists'    'b.txt exists'    'c.txt exists'

结果以元胞形式存储
%----------------------------
%----------------------------

x = sym('x');
>> x + x
ans =
2*x
>> x * x
ans =
x^2
>> sin(x)^2 + cos(x)^2
ans =
sin(x)^2 + cos(x)^2

%微分
>> diff(3*x^2 + sin(x))
ans =
6*x + cos(x)
%积分
>> int(6*x + cos(x))
ans =
sin(x) + 3*x^2
>> taylor(exp(x), x, 0, 'Order', 10)
ans =
x^9/362880 + x^8/40320 + x^7/5040 + x^6/720 + x^5/120 + x^4/24 + x^3/6 + x^2/2 + x + 1

>> p = matlabFunction(x^2 + 2*x + sin(x))
p =
@(x)x.*2.0+sin(x)+x.^2
>> p(0.2)
ans =
0.6387




%--------------------------
%十进制数转换为字符相互转换
char(65) 'A'
char(ones(1,3)+64) 'AAA'
uint32('A')   65

% 保存数据/结构体
save filename   structname 
save  filename   variablename

% cell上下翻转
b=cell(3,5);
b=b(end:-1:1,:);
% 合并cell
c=[c1,c2];or  c1=[c1; c2]

%------------------------------
freqz(b,a,8192,Fs)
% 频谱和相移
[H,W]=freqz(b,a,1024);
HH=abs(H).^2;
Hff=abs(HH);
Hxx=angle(HH);
figure
subplot(2,1,2);
plot(W*Fs/(2*pi),Hxx);
xlim([0,Fs/2]);
ylabel('Phase(degrees)');
xlabel('Frequency(Hz)');
grid on;
subplot(2,1,1);
plot(W*Fs/(2*pi),20*log(Hff));
ylabel('Magnitude(dB)');
xlabel('Frequency(Hz)');
grid on;
%------------------------------

添加背景图片
在openingfcn下添加
ha=axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'down')
II=imread('d3w.jpg');
image(II)
colormap gray
set(ha,'handlevisibility','off','visible','off');
改变按钮的背景
I=imread('buttoncdata.bmp');
set(handles.pushbutton1,'cdata',I);

-------------------------------------------------------------
matlab中figure窗口图片保存的问题

 figure('MenuBar','none');%不显示工具栏
%窗口最大化
%当前图形窗口get(gcf,'outerposition')
set(gcf,'outerposition', get(0,'screensize')+[-6 40 100 -40]);
 %去掉菜单栏和工具栏
%        set(0,'DefaultFigureMenu','none');
%显示工具栏和菜单栏
%         set(gcf,'MenuBar','figure')
%         set(0,'DefaultFigureMenu','figure')
%         保存figure为图片格式
 fig=getframe(gcf);
imwrite(fig.cdata,['.\',fdname,'\','test.png']);

Figure窗口中的图形导出成jpg格式的图片时，所有的字号都会变大，而且坐标刻度值在有些情况下会改变。
我想得到与屏幕上显示完全相同的jpg图形，但又不想用尺寸比较大的bmp.
另：用print生成24位色的bmp时字体也会变大，用saveas生成的bmp不会变大，但只能保存成256色，会丢失颜色。
下面详细说明一下我的要求与解决方法。
由于所绘制的图形用到了colorbar，所以颜色比较多。
1.保存成图片后要求颜色尽量不失真
2.图片要小
3.格式比较常见
4.方法要能够进行批量处理

暂以bmp,jpg,gif三种常见格式的图片结合matlab导出图片的方法进行说明：

1.saveas 能生成bmp，jpg图形
此法生成的bmp只能为256色造成色彩失真。
jpg可以为24位色，但会造成字体显示或坐标显示与屏幕显示不符，字体变大。

2.print 能生成bmp，jpg图形
此法生成的bmp可以为24位色，但和jpg一样都会产生字体和坐标显示与屏幕显示的不符，而且bmp文件比较大。

3.菜单Edit->Copy Figure拷贝至剪贴版->保存->转换为jpg或gif格式

该方法能生成24位色的与屏幕显示效果完全相同的bmp，再由第三方软件转化为jpg或gif格式解决文件大小问题。

转化问题：
      (1) jpg格式是有损压缩，在转化后图像质量有所损失。
      (2) gif格式是无损压缩，但只支持256色。用一般的格式转换工具将24位色bmp转换为gif格式时会出现色彩失真，
该图形中虽colorbar，但所使 用到的颜色种类没有超过256种，所以用Acdsee等专业的转换工具转换后其效果与bmp基本
完全一样，效果比jpg好的多，而且文件也比jpg的要 小。

批量处理问题：
      (1) Edit -> Copy Figure ，经研究得出Copy Figure菜单的回调函数是
      uimenufcn(gcf,'EditCopyFigure');
我们把gcbf换成gcf即可实现点击当前figure菜单Edit -> Copy Figure 相同的功能，把图片拷贝到剪贴版中。
      (2) 从剪贴版获取图片并保存为bmp，此项操作有VB来完成。在VB中获取图片并保存的代码如下：
      picBitmap = ClipBoard.GetData(vbCFBitmap)
       savepicture picBitmap.picture,"test.bmp"
其中picBitmap为picture控件，将程序编译为exe，在matlab里用system调用
      (3)由于没有找到将24位色bmp转换为gif的较好的模块，在生成所有bmp后，用Acdsee批量转换。

----------------------------------------------------------------
把秒（slength）转换成日时分秒字符串

rishengyu=rem(slength,86400);
ri=(slength-rishengyu)/86400;
shishengyu=rem(rishengyu,3600);
shi=(rishengyu-shishengyu)/3600;
fenshengyu=rem(shishengyu,60);
fen=(shishengyu-fenshengyu)/60;
miao=rem(fenshengyu,60);
datestr2='00000000';
datestr3='00号00:00:00';
pp=[ri+1,shi,fen,miao];
for k=1:4
if pp(k)<10    
    tempstr=['0',num2str(pp(k))];
else
    tempstr=num2str(pp(k));
end
datestr2(2*k-1:2*k)=tempstr;
datestr(3*k-2:3*k-1)=tempstr;
end
set(handles.edit2,'string',datestr2);
----------------------------------------------------------------


nargin :函数参数的总个数
varargin： 函数 可选参数的总个数

画x=a和y=b的直线
水平线：plot([xmin,xmax],[a,a]);
垂线：  plot([b,b],[ymin,ymax]);
xmin,xmax,ymin,ymax 分别是水平线和垂线的起点和终点。

把只含有0,1的矩阵每行转换为十进制
  N = size(Qbinnum,2);
   k = ((N-1):-1:0)';
   v = 2.^k;
   cgroup = Qbinnum*v;
或者
bin2dec(int2str(Qbinnum（1，：）))


rem(x,y);取余数x/y
把矩阵改为向量
A=A(：)
all（A，dim）判断每行或每列是否是非0的
all（A>1)

统计矩阵中元素出现次数
grp2idx()
length(a(a==2))
或者
length(find(a==2))
 [p,q]=hist(a,unique(a));
得到的结果q为相应的量，对应的p为q在a中出现的次数
a=[11 2 33 45 2];
[p,q]=hist(a,unique(a));
p =

     2     1     1     1
q =

     2    11    33    45

画圆
rectangle('position',[1,1,5,5],'curvature',[1,1],'edgecolor','r','facecolor','g');
'position',[1,1,5,5]表示从（1,1）点开始高为5，宽为5；
'curvature',[1,1]表示x,y方向上的曲率都为1，即是圆弧；
'edgecolor','r'表示边框颜色是红色；
'facecolor','g'表示面内填充颜色为绿色。
%最大化figure窗口
        set(gcf,'outerposition', get(0,'screensize'));

 %去掉菜单栏和工具栏
        set(0,'DefaultFigureMenu','none');
or
figure('MenuBar','figure')
figure('MenuBar','none')
%显示工具栏和菜单栏
% set(0,'DefaultFigureMenu','figure')

关于日期转换：
datenum(0,0,1,0,0,0)=1  %返回单位是天，起始时间是 0
datevec(addtodate(datenum(1601,1,1,0,0,0),fg2*1e-7,'second'))
%将秒加到日期上
 addtime = int64((datenum(datewritevec)-datenum(1601,1,1,0,0,0))*24*3600)*1e7;
写binx格式文件
%open file
    fod = fopen(path_file,'wb','l');% 'l' represents little_endian ordering
    %write station Name
    fwrite(fod,stationName,'*char');  
    fwrite(fod,zeros(32-length(stationName),1),'*char');   %write null to binx
    %write channel name
    fwrite(fod,chnName,'*char');    %write null to binx
    fwrite(fod,zeros(8-length(chnName),1),'*char'); 
    %write sample fs
    fwrite(fod,[1,1],'*uint');   % write sample fs: numerator/denominator,this is 1/1Hz
    %write filetime
    fwrite(fod,addtime,'*int64');     %write filetime
    %write date type
    fwrite(fod,'I32','*char');  %write data type
    fwrite(fod,[0,0,0,0,0],'*char');
    %write reservered info
    fwrite(fod,zeros(960,1),'*char');
    %write data
    fwrite(fod,data,'int32'); %write data
    %close file
    fclose(fod);      %close file

guidata(hObject, handles);% Update handles structure


旋转xy轴
set(gca,'view',[90 -90])
设置刻度线显示
设置db显示
 set(gca,'yticklabel',20.*log10(get(gca,'ytick')))
set(gca,'xticklabel',sprintf('.4f|',get(gca,'xtick')));%style 3
set(gca,'xtick',[min(x) (max(x)+min(x))/2 max(x)]);
set(gca,'XMinorTick','off');
set(gca,'XGrid','on');

set(gca,'XMinorGrid','off');

%顺便附上可以格式化坐标刻度的程序段
x=get(gca,'xlim');

y=get(gca,'ylim');

set(gca,'xtick',[x(1) (x(1)+x(2))/2 x(2)]);

set(gca,'ytick',[y(1) (y(1)+y(2))/2 y(2)]);

－－－－－－－－－－－－－

get(gca,'xlim');是获取最大最小刻度的

如果需要获取所有在坐标轴上显示的刻度，需要使用
get(gca,'ytick')
set(gca,'xticklabel',strsplit(num2str(10:14),' '));%{'10'    '11'    '12'    '13'    '14'}

%或者下面这种（适用低版本Matlab）
xlabel_start=1;
xlabel_end=31;
xlabel_len=xlabel_end-xlabel_start+1;
for xb=1:xlabel_len  %xlabel_start:xlabel_end
    xtlabel{xb,1}=num2str(xlabel_start+xb-1);
end
set(h(k),'xticklabel', xtlabel);

-----------
%求矩阵S中的最大值： 
max(max(S))
%暂停0.5秒
pause（0.5）
---------------------------------------
%指定位置显示图形
plot(30,30,'r.','markersize',5)

axis xy就是普通的坐标格式。
axis ij就是image系列的坐标格式

%矩阵翻转
flipud(a) 矩阵上下翻转 
fliplr(a) 矩阵左右翻转
rot90(a)矩阵逆时针旋转90度
B = flipdim(A,dim) returns A with dimension dim flipped.

设置colorbar 范围 caxis([0,1])


对矩阵A每一列归一化：A./repmat(max(A),size(A,1),1);
 对矩阵A每一行归一化：A./repmat(max(A,[],2),1,size(A,2));
 这里要注意若有全零行或者全零列，结果中会有NAN
或者下面这种
(a- repmat(min(a),size(a,1),1))./(repmat(max(a)-min(a),size(a,1),1))

创建自然数矩阵
n=5;
A=1：n；
B=1./(1:n);

字符串str分割
counter = 1;
for index = 1 : 8 : length(str)
	lastIndex = min(index+7, length(str));
	ca{counter} = str(index:lastIndex);
	counter = counter + 1;
end
celldisp(ca)

 fid = fopen('examp02_03.txt','wt');    % 以写入方式打开文件，返回文件标识符
% 把矩阵x以指定格式写入文件examp02_03.txt
fprintf(fid,'%.4f\n',xxx);
fclose(fid);    % 关闭文件

  for i=2:10
 disp(['d',num2str(i),'=get(handles.checkbox',num2str(i+3),',''value'');'])
end

------------------------
help wfilters
wavemngr('read',1)

wavebox={'haar', 'dmey',...
    'db1','db2','db3','db4','db5','db6','db7','db8','db9','db10',...
    'db11','db12','db13','db14','db15','db16','db17','db18','db19','db20','db21',...
    'db22','db23','db24','db25','db26','db27','db28','db29',...
    'db30','db31','db32','db33','db34','db35','db36','db37','db38','db39',...
    'db40','db41','db42','db43','db44','db45',...
   'sym2','sym3','sym4','sym5','sym6','sym7','sym8','sym9','sym10',...
    'sym11','sym12','sym13','sym14','sym15','sym16','sym17','sym18','sym19','sym20',
    'sym21','sym22','sym23','sym24','sym25','sym26','sym27','sym28','sym29',...
    'sym30','sym31','sym32','sym33','sym34','sym35','sym36','sym37','sym38','sym39',...
    'sym40','sym41','sym42','sym43','sym44','sym45',...
    'coif1','coif2','coif3','coif4','coif5',...
    'bior1.1','bior1.3','bior1.5','bior2.2','bior2.4','bior2.6','bior2.8',...
    'bior3.1','bior3.3','bior3.5','bior3.7','bior3.9','bior4.4','bior5.5','bior6.8',...
    'rbio1.1','rbio1.3','rbio1.5','rbio2.2','rbio2.4','rbio2.6','rbio2.8','rbio3.1',...
    'rbio3.3','rbio3.5','rbio3.7','rbio3.9','rbio4.4','rbio5.5','rbio6.8',...
    };

for i=1:length(wavebox)
disp(wavebox{i})
end

haar
db1
db2
db3
db4
db5
db6
db7
db8
db9
db10
sym2
sym3
sym4
sym5
sym6
sym7
sym8
coif1
coif2
coif3
coif4
coif5
bior1.1
bior1.3
bior1.5
bior2.2
bior2.4
bior2.6
bior2.8
bior3.1
bior3.3
bior3.5
bior3.7
bior3.9
bior4.4
bior5.5
bior6.8
rbio1.1
rbio1.3
rbio1.5
rbio2.2
rbio2.4
rbio2.6
rbio2.8
rbio3.1
rbio3.3
rbio3.5
rbio3.7
rbio3.9
rbio4.4
rbio5.5
rbio6.8
meyr
dmey
gaus1
gaus2
gaus3
gaus4
gaus5
gaus6
gaus7
gaus8
mexh
morl
cgau1
cgau2
cgau3
cgau4
cgau5
shan1-1.5
shan1-1
shan1-0.5
shan1-0.1
shan2-3
fbsp1-1-1.5
fbsp1-1-1
fbsp1-1-0.5
fbsp2-1-1
fbsp2-1-0.5
fbsp2-1-0.1
cmor1-1.5
cmor1-1
cmor1-0.5
cmor1-0.1
