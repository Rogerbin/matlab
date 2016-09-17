# -*- coding: utf-8 -*-
import urllib,urllib2,cookielib,re
from bs4 import BeautifulSoup as sp
from time import sleep

index = 'http://130.211.8.178/index.php'

def doReply(myopener,tUrl):
    s = myopener.open(urllib2.Request(tUrl)).read()
    #get formhash value
    formhash = re.findall('name=\"formhash\" value=\"([0-9a-f]*)\" ',s)
    #get reply url
    replyURL = tUrl.replace('viewthread','post') +'&action=reply&fid=23'+\
    '&replysubmit=yes&infloat=yes&handlekey=fastpost&inajax=1'
    # prepare reply post data
    rpdata = {'message':'{:1_1102:}nice,谢谢分享','formhash':formhash[0],'dhash':'12342543545335','usesig':'1'}
    # do reply request
    rpg = myopener.open(urllib2.Request(replyURL,urllib.urlencode(rpdata))).read()
    print rpg.decode('utf-8')

def getPg(opener,url,*args):
    if len(args)<1:
        return opener.open(urllib2.Request(url)).read()
    else:
        return opener.open(urllib2.Request(replyURL,urllib.urlencode(args[0]))).read()

def  getReply(opener,url,*args):
    pg = sp(getPg(opener,url,*args),'html.parser')
    tds = pg.findAll('td',{'class':'t_msgfont'})
    replys = [d.text.strip() for d in tds]
    return replys

url = 'http://130.211.8.178/logging.php?action=login'
qiandaourl='http://130.211.8.178/plugin.php?identifier=rs_sign&module=sign&operation=qiandao&infloat=1&inajax=1&inajax=1'

 # Add your headers
headers = {'User-Agent' : "Mozilla/5.0 (Windows NT 6.1; WOW64)"
    			  "AppleWebKit/537.36 (KHTML, like Gecko)"
    			  "Chrome/45.0.2454.101 Safari/537.36"}

data = {
'User-Agent' : "Mozilla/5.0 (Windows NT 6.1; WOW64)"
    			  "AppleWebKit/537.36 (KHTML, like Gecko)"
    			  "Chrome/45.0.2454.101 Safari/537.36",
    			"loginfield":"username",
    			"username": 'xiaomiii',
    			 "password": 'kksxwwwooos',
    			 "loginsubmit":"true"
    			 }
#qiandao post data
todaytosay = 'hello every one ,nice city'
qd_info={
        "qdxq":"yl",
        "qdmode":"1",
        "todaysay":todaytosay,
        "fastreply":"1"}
# combine two dicts
qd_info = dict(qd_info,**headers)
# code post data
params = urllib.urlencode(data)
#set cookie
cj = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
urllib2.install_opener(opener)
# first come by page :login
request2 = urllib2.Request(url,params)
response2 = opener.open(request2)
pp = response2.read()
# second come by page: qiandao
qiandao_rq = urllib2.Request(qiandaourl,urllib.urlencode(qd_info))
rsp3 = opener.open(qiandao_rq)
qdao_page = rsp3.read()

#   regular expression: acquire info
rx=re.compile(r'class="postbox">\r\n(.+?)</div')
qdresult = re.findall(rx,qdao_page)
#   print info
#print str(qdresult[0]).decode('utf-8').encode('gbk')
#print qdao_page
print qdresult[0].decode('utf-8')

##formhash = re.findall('name=\"formhash\" value=\"([0-9a-f]*)\" ',s)

uy = 'http://130.211.8.178/'

su1 = 'http://130.211.8.178/forum-19-1.html'#88-6
pg = sp(getPg(opener,su1),'html.parser')
ths = pg.findAll('th',{'class':'subject common'})
#rs = [d.span.a['href'] for d in ths]
for d in ths[0:-1:2]:
    print d.span.text
    h=uy + d.span.a['href']
    doReply(opener,h)
    sleep(20)