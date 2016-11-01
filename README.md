# matlab
some code used in my study of data analysis

Matlab2word
```matlab
%%  word 处理部分
wordflag = 1;
if wordflag
    %激活word 
    try    
        word = actxGetRunningServer('Word.Application');  %启动word
    catch    
        word = actxserver('Word.Application'); 
    end;
    word.Visible = 1;%使word可见
    document = word.Documents.Add;
    document.SaveAs([pwd '\test3.docx']);
end
% ----------------------------------------
% 添加文件夹目录
addpath(genpath('Platform'));% add by gbin
for p=1:23%:23
    if wordflag
        mystring = myfunc(p,document);
        mystring = strcat(num2str(p),'. ',mystring);
        %获取所有打开的figure句柄
        hfig=get(0,'Children');
        Numofstart = word.Selection.Start;% 当前行开头位置
        word.Selection.TypeText(mystring);% 打印字符
        Numofend = word.Selection.Start;% 当前行末尾位置
        word.Selection.SetRange(Numofstart,Numofend);%选择当前行
        % 设置大纲级别1，,2，，正文文本是wdOutlineLevelBodyText  
        word.Selection.ParagraphFormat.OutlineLevel = 'wdOutlineLevel1';     
        word.Selection.Font.Color = 'wdColorRed';% 文字颜色
        word.Selection.Font.Size = 16;%文字大小
        
        word.Selection.MoveDown;
        word.Selection.TypeParagraph;% 换行
        word.Selection.ClearFormatting;% 清格式
        for ff=2:3
            figure(hfig(ff));
            uimenufcn(hfig(ff),'EditCopyFigure');
            invoke(word.Selection,'Paste');
            word.Selection.TypeParagraph;
            document.Save;
        end
        % ´存入word
    else
        myfunc(p);
    end
end
 
if wordflag
% quit word
word.Quit();
end
% 移除文件夹目录
rmpath(genpath('Platform'));% add by gbin
```

---
###python code  for matlab.cn login 
```python
import urllib,requests,cookielib,urllib2
from bs4 import BeautifulSoup as sp
ba = 'http://my.yjbys.com/resume-681931000.htm'

def login():
    u = 'http://www.ilovematlab.cn/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1'
    headers ={'Host':'www.ilovematlab.cn',
              'Referer':'http://www.ilovematlab.cn/forum.php',
              'User-Agent':'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.75 Safari/537.36',
              }
    formdata ={'fastloginfield':'username','username':'xkeksk','password':'497de64f0553ceed29619ca3a76cc960','quickforward':'yes','handlekey':'ls'}

    params= urllib.urlencode(formdata)
    cj = cookielib.CookieJar()
    opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    urllib2.install_opener(opener)

    req=urllib2.Request(u,params)
    resp=opener.open(req)
    pp = resp.read()

    req2 = urllib2.Request('http://www.ilovematlab.cn/forum.php')
    resp2=opener.open(req2)
    pp2 = resp2.read()
    print pp2
    
login()    
```
---
###python 回帖
最开始post数据之后出现问题：*“您的请求来路不正确，无法提交”*<br>
这个问题出现在：当你用模拟登陆的方法登陆了discuz论坛后，进行回复或与此类似的操作时。<br>
出现这项提示的原因是多种多样的，但是对于一个模拟登陆的程序而言，主要的可能是这样一种情况：在post时，**未设置formhash**。<br>
这个formhash的值可以在论坛的任意页面获得，只要用正则表达式简单匹配一下即可，以python为例：<br>
```formhash = re.findall('name=\"formhash\" value=\"([0-9a-f]*)\" ',page)```<br>
formhash的值是一个长度为8的字符串，以16进制表示.<br>
在一次的登陆过程中，formhash值是不会变的，不过为保险起见，你可以在每次进行新的相关操作时，均获取一遍该hash值。<br>
```python

# reply part
##帖子页面地址
tieUrl= 'http://130.211.8.178/viewthread.php?tid=4195196&extra=page%3D1'
#获取帖子页面
s = opener.open(urllib2.Request(tieUrl)).read()
#获取formhash值
formhash = re.findall('name=\"formhash\" value=\"([0-9a-f]*)\" ',s)

replyURL='http://130.211.8.178/post.php?action=reply&fid=23&tid=4195196&extra=page%3D1&replysubmit=yes&infloat=yes&handlekey=fastpost&inajax=1'
#需要post的 数据
rpdata = {'message':'kawayi','formhash':formhash[0],'dhash':'12342543545335','usesig':'1'}
#提交请求
rpg = opener.open(urllib2.Request(replyURL,urllib.urlencode(rpdata))).read()
```
