# matlab
some code used in my study of data analysis


matlab.cn login code
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
    
