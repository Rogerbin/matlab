function simpleGui
%pcode simpleGui
h.fig = figure('position',[600 350 210 400],'menu','none');

h.buttonone = uicontrol('style','pushbutton',...
                    'position',[10 360 100 40],...
                    'string','btn1');
                
set(h.buttonone,'callback',{@addbutton , h});
h.btnMenu = uicontrol('style','pushbutton',...
                       'position',[10, 300, 100,40],...
                       'string','menu');
set(h.btnMenu,'callback',{@showmenu,h});

function h = addbutton(hObject, eventdata,h)

h.buttonTwo = uicontrol('style','pushbutton',...
                        'position',[100 360 100 40],...
                        'string','remove button');
set(h.buttonTwo, 'callback',{@removebutton,h});
set(h.buttonone,'enable','off');

function h = removebutton(hObject, eventdata, h)

delete(h.buttonTwo);
h = rmfield(h,'buttonTwo');

set(h.buttonone,'enable','on');

function h = showmenu(hObject, eventdata, h)

if isequal(get(h.fig,'menu'),'none')
    set(h.fig,'MenubBar','auto');
end

% -------------下面为GUI 笔记---------------
FigColor=get(0,'DefaultUicontrolBackgroundColor');
%使用结构体创建控件
btn = 

       style: 'pushbutton'
      string: 'open'
    position: [20 30 100 20]
 uicontrol(hfig, btn)
 
 %
