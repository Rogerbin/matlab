[TOC]
# code整理
* 1.function
* 2.function

##1.function : abc

##2. function ： copyallfig2word
```matlab
function [ output_args ] = copyallfig2word( savefilename,varargin )
%COPYALLFIG2WORD 获取当前matlab下打开的所有figure,并保存在word中
% 不用调整图的顺序，程序里会自动排序
%   input: savefilename
%   output: word file including figures
%% 获取所有打开的figure句柄
hf = sort(get(0,'children'));% 按生成的先后顺序存
% for i =1:length(hf);set(hf(i),'visible','off');end % 隐藏所有figure
% arrayfun(@(i)set(hf(i),'visible','on'),(1:12))
%% 调用word,并保存之
%  word 处理部分
if nargin>0
    tempname = savefilename;
else
    tempname = 'test.docx';
end
savefilename = fullfile(pwd ,tempname);
wordflag = 1;
if wordflag
    %激活word
    try
        word = actxGetRunningServer('Word.Application');  %启动word引擎
    catch
        word = actxserver('Word.Application');
    end;
    word.Visible = 1;% 使word可视
    if exist(savefilename,'file')
        % 若存在，直接打开
        document = word.Documents.Open(savefilename);
    else
        % 若不存在文件，先创建
        document = word.Documents.Add;
        document.SaveAs(savefilename);
    end
     v = 65:-5:25;
    %% 粘贴每幅图片
    for ff = 1:length(hf)
%         Numofstart = word.Selection.Start;% 找到此时的字符个数
        Numofstart = word.ActiveDocument.Content.End;%找到此时(结尾处)字符个数
        word.Selection.SetRange(Numofstart,Numofstart);%移动光标到文档末尾
        Numofstart = word.Selection.Start;% 找到此时的字符个数
%         figure(hf(ff));%获取当前图
        figtitle = [get(get(gca,'title'),'string')];
%         figtitle = ['T2H',num2str(v(floor((ff+1)/2)))];
        title = [num2str(ff),'.  ',figtitle , ''];
        word.Selection.TypeText(title);% 打印标题
        Numofend = word.Selection.Start;% 找到此时的字符个数
        word.Selection.SetRange(Numofstart,Numofend);%选中整行
        %设置大纲级别2(wdOutlineLevel2)，正文文本是wdOutlineLevelBodyText
        word.Selection.ParagraphFormat.OutlineLevel = 'wdOutlineLevel2';
        word.Selection.Font.Color = 'wdColorRed';% 设置文本颜色
        word.Selection.Font.Size = 16;%设置文字大小
        
        word.Selection.MoveDown;
        word.Selection.TypeParagraph;% 换行
        word.Selection.ClearFormatting;%清格式
        %进行图片的复制粘贴进入word
        
%         figure(hf(ff));%获取当前图
%         uimenufcn(hf(ff),'EditCopyFigure');%调用复制功能
        hgexport(hf(ff),'-clipboard');
        invoke(word.Selection,'Paste');%粘贴
        word.Selection.TypeParagraph;%换行回车
        
    end
    word.ActiveDocument.Save;
end
% word.Quit;
%clear word;
end
```
###3.function :
