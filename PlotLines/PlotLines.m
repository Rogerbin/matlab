function varargout = PlotLines(varargin)
% PLOTLINES M-file for PlotLines.fig
%      PLOTLINES, by itself, creates a new PLOTLINES or raises the existing
%      singleton*.
%
%      H = PLOTLINES returns the handle to a new PLOTLINES or the handle to
%      the existing singleton*.
%
%      PLOTLINES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTLINES.M with the given input arguments.
%
%      PLOTLINES('Property','Value',...) creates a new PLOTLINES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotLines_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotLines_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help PlotLines

% Last Modified by GUIDE v2.5 16-Jun-2015 17:12:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotLines_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotLines_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PlotLines is made visible.
function PlotLines_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotLines (see VARARGIN)

% Choose default command line output for PlotLines
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlotLines wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlotLines_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_choosefiles.
function pushbutton_choosefiles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_choosefiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles allnames
% allFiles={};
[filename, pathname] = uigetfile('H:\*.txt', 'Pick files','MultiSelect', 'on');
if ~ischar(pathname);return ;end
if ischar(filename) ;choosedFiles={fullfile(pathname,filename)};else
for k=1:length(filename)
    choosedFiles{k,1}=fullfile(pathname,filename{k});
end
end
% if isempty(allFiles)
%     allFiles=choosedFiles;
% else
allFiles=[allFiles;choosedFiles];
% end
allFiles=unique(allFiles);
set(handles.listbox_filename,'String',allFiles);
contents = cellstr(get(handles.listbox_filename,'String'));
set(handles.listbox_filename ,'Value',1);


% --- Executes on button press in pushbutton_moveup.
function pushbutton_moveup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_moveup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles selectedItemval 
%move up the selected item
% selectedItemval=get(handles.listbox_filename ,'Value');
if selectedItemval>=2
%     allFiles{selectedItemval};
    tempstr=allFiles{selectedItemval-1};
    allFiles{selectedItemval-1}=allFiles{selectedItemval};
    allFiles{selectedItemval}=tempstr;
    set(handles.listbox_filename,'String',allFiles);

    set(handles.listbox_filename ,'Value',selectedItemval-1)
    selectedItemval=selectedItemval-1;
    if selectedItemval<2
        set(handles.pushbutton_moveup,'Enable','off');
    end
end
updatebtn(handles);

% --- Executes on button press in pushbutton_movedown.
function pushbutton_movedown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_movedown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles selectedItemval 
% selectedItemval=get(handles.listbox_filename ,'Value');
if selectedItemval<length(allFiles)
%     allFiles{selectedItemval};
    tempstr=allFiles{selectedItemval+1};
    allFiles{selectedItemval+1}=allFiles{selectedItemval};
    allFiles{selectedItemval}=tempstr;
    set(handles.listbox_filename,'String',allFiles);

    set(handles.listbox_filename ,'Value',selectedItemval+1)
    selectedItemval=selectedItemval+1;
    if selectedItemval==length(allFiles)
        set(handles.pushbutton_movedown,'Enable','off');
    end
end
updatebtn(handles);

% --- Executes on button press in pushbutton_remove.
function pushbutton_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles selectedItemval
%━
% allFiles={};
if isempty(allFiles)
    return;
end
allFiles(selectedItemval)=[];
if selectedItemval<2
    temp=1;
else
    temp=-1;
end
    
set(handles.listbox_filename ,'Value',selectedItemval+temp)
selectedItemval=selectedItemval+temp;
set(handles.listbox_filename,'String',allFiles);
% updatebtn(handles);

% --- Executes on button press in pushbutton_clearall.
function pushbutton_clearall_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles allnames selectedItemval h
h=[];
allFiles={};
allnames={};
selectedItemval=1;
set(handles.listbox_filename,'String',allFiles);
contents = cellstr(get(handles.listbox_filename,'String'));
set(handles.listbox_filename ,'Value',1);

% --- Executes on button press in pushbutton_drawlines.
function pushbutton_drawlines_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_drawlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles allnames h f1 fontval fontname
fontval=18;
fontname='Times New Roman';
if isempty(allFiles)
    return
end
for i=1:length(allFiles)
    [pathstr, tempname, ext]= fileparts(allFiles{i}); 
%     tempname=strrep(tempname,'-','_');
%     tempname=tempname(1:strfind(tempname,'2001')-1);
%for show xiaobo 4 levels data
%     tempname=strrep(tempname,'20011110-13Z',' ');
%     tempname=strrep(tempname,'.LHZ.1Hz.10-14Z.hann',' ');
%%%%________________OOOOO____________________
bereplacedstr='50-100s200804E';
tempname=strrep(tempname,bereplacedstr,'');
    tempname=strrep(tempname,'_',' ');
    allnames{i,1}=tempname;
end
f1=figure;
set(f1,'Position',[154 40 686 570]);
Nsub=length(allFiles);
linecolor='k';
for i=1:length(allFiles)
    tmp=importdata(allFiles{i});
    tmp=tmp-mean(tmp);
    if strfind(allFiles{i},'4-7')
        linecolor='b';
    elseif strfind(allFiles{i},'8-10')
        linecolor='r';
    end
    h(i)=subplot(Nsub,1,i);
    if length(allFiles)==3
    if i==1
        tmp=tmp-mean(tmp);
    end
    end
    plot(tmp,'color',linecolor);
    axis tight;
    set(gca,'xticklabel',{});%'yticklabel',{},
    tm=ceil(max(get(gca,'xlim'))/86400);
    set(gca,'xtick',[(0:tm-1)*86400+1,length(tmp)],'fontsize',fontval,'fontname',fontname);
    %%
%     if length(allFiles)==3
%        if i==1
%            ylimset=max(abs(get(gca,'ylim')));
%        else
%            set(gca,'ylim',[-ylimset,ylimset]);
%        end
%     end
ylimseta=-2e4;
ylimsetb=2e4;
set(gca,'ylim',[ylimseta,ylimsetb],'ytick',[ylimseta/2,0,ylimsetb/2]);
end
handlegap();
% xlim=max(get(gca,'xlim'));
% set(gca,'xticklabel',{})

function handlegap()
global allnames fontval fontname
%━h(1),h(2),h(3)...
h=sort(get(gcf,'children'));
botomadd=0;
topadd=0;
nsub=length(h);
toppos=get(h(1),'position');
botmpos=get(h(nsub),'position');
oldhigt=toppos(4);
botomedge=botmpos(2)+botomadd;
topedge=toppos(2)+oldhigt+topadd;
gapspace=0;
newhigt=(topedge-botomedge-gapspace*(nsub-1))/nsub;
higtandgap=gapspace+newhigt;
for k=1:nsub
   temppos=get(h(k),'position'); 
   temppos(2)=topedge-newhigt-higtandgap*(k-1);
   temppos(4)=newhigt;
   set(h(k),'position',temppos,'box','on');
   legtext=[allnames{k},' '];
   if nsub==3 
       if k==2 
           legtext=[allnames{k},' 4-7s'];
       end
       if k==3 
           legtext=[allnames{k},' 8-10s'];
       end
   end
   hleg=legend(h(k),legtext);
%    legend(h(k),'boxoff');
    set(hleg,'box','off');
    pause(0.0001);
end
% set(h(k),'xticklabel', strsplit(num2str(10:14),' '),'fontsize',10);
%set(gca,'xticklabel',{'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';})
% xtlabel={'10','11','12','13','14'};
xlabel_start=1;
xlabel_end=31;
xlabel_len=xlabel_end-xlabel_start+1;
for xb=1:xlabel_len  %xlabel_start:xlabel_end
    xtlabel{xb,1}=num2str(xlabel_start+xb-1);
end
set(h(k),'xticklabel', xtlabel,'fontsize',fontval,'fontname',fontname);

% --- Executes on button press in pushbutton_setYlim.
function pushbutton_setYlim_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setYlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f1 h allnames
ylim=abs(str2num(get(handles.edit_ylimset,'string')));
yticknum=abs(str2num(get(handles.edit_ytick,'string')));
if isempty(f1)
    return;
end
if ishandle(f1)
for k=1:length(allnames)
    set(h(k),'ylim',[-ylim ,ylim],'ytick',[-yticknum,0,yticknum]);
% set(gca,'ylim',[ylimseta,ylimsetb],'ytick',[ylimseta/2,0,ylimsetb/2]);
end
end

% --- Executes on selection change in listbox_filename.
function listbox_filename_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_filename contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_filename
updatebtn(handles);

%━btn
function updatebtn(handles)
global selectedItemval
contents=cellstr(get(handles.listbox_filename,'String'));
selectedItemval=get(handles.listbox_filename,'Value');
if selectedItemval<2
    set(handles.pushbutton_moveup,'Enable','off');
else
    set(handles.pushbutton_moveup,'Enable','on');
end
if selectedItemval>(length(contents)-1)
    set(handles.pushbutton_movedown,'Enable','off');
else
    set(handles.pushbutton_movedown,'Enable','on');
end

% --- Executes during object creation, after setting all properties.
function listbox_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ylimset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ylimset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ylimset as text
%        str2double(get(hObject,'String')) returns contents of edit_ylimset as a double


% --- Executes during object creation, after setting all properties.
function edit_ylimset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ylimset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in pushbutton_plot2.
function pushbutton_plot2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allFiles 
plot2linestogether(allFiles);

function plot2linestogether(filename)
fontval=18;
fontname='Times New Roman';
Nfile=length(filename);
if isnumeric(filename);return;end;
if Nfile==0 ;return; end
%  figure('MenuBar','none');%：：
for i=1:Nfile
   temp=filename{i};
   [pathstr, file{i,1}, ext]= fileparts(temp); 
    file{i,1}=strrep(file{i,1},'20011110-13Z','');
    file{i,1}=strrep(file{i,1},'-hann',' ');
   file{i,2}=importdata(temp);
end 
f1=figure;h=[];
set(gcf,'outerposition', get(0,'screensize')+[-6 40 -500 -40]);
subNum=ceil(Nfile/2);
for k=1:subNum
    h(k)=subplot(subNum,1,k);
%     t=(1:length(file{k*2-1,2}))';
%    plot(t,file{k*2-1,2},'b',t,file{k*2,2},'r');
    plot(file{k*2-1,2},'color','b');
    hold on
    plot(file{k*2,2},'color','r');
   legd=legend(file{k*2-1,1},file{k*2,1});
   set(legd,'box','off');
   axis tight
   ymax=max(abs(get(gca,'ylim')));
   ymaxstr=num2str(ymax);
   newymax=(str2num(ymaxstr(1))+1)*10^(length(ymaxstr)-1);
   set(gca,'fontsize',fontval,'fontname',fontname);
%    set(gca,'ytick',[-newymax/2,0, newymax/2]);
   set(gca,'ytick',[-3000,0, 3000]);
   set(gca,'xtick',[(0:4-1)*86400+1,length(file{k*2-1,2})]);
end
movesubplot(h);
set(gca,'xticklabel',{'10','11','12','13','14','15'});

function movesubplot(h)
% N=3;
N=length(h);
if N<2;return;end
for i=1:N
    %get(gcf,'children')
   pos{i}=get(h(i),'position');
end
%leftbottom, width, height
bottom=pos{N}(2);
top=pos{1}(2)+pos{1}(4);
maxgap=pos{1}(2)-pos{1}(4)-pos{2}(2);
% plotgap=0.02;
plotspace=top-bottom;%-plotgap*(N-1);
for j=1:N
pos{j}(4)=plotspace/N;
pos{j}(2)=bottom+(N-j)*plotspace/N;%+plotgap;
set(h(j),'position',pos{j},'box','on','xticklabel',{});%,'yticklabel',{});
end



function edit_xlabelstart_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xlabelstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xlabelstart as text
%        str2double(get(hObject,'String')) returns contents of edit_xlabelstart as a double


% --- Executes during object creation, after setting all properties.
function edit_xlabelstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xlabelstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton_xlimitset.
function pushbutton_xlimitset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_xlimitset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f1 h allnames
%by points num
% xlimtmin=abs(str2num(get(handles.edit_xlabelstart,'string')));
% xlimtmax=abs(str2num(get(handles.edit_xlabelend,'string')));
%by day num
xlimtmin=86400*(abs(str2num(get(handles.edit_xlabelstart,'string')))-1)+1;%set as days 
xlimtmax=86400*(abs(str2num(get(handles.edit_xlabelend,'string')))-1)+1;%set as days 
if isempty(f1)
    return;
end
if ishandle(f1)
for k=1:length(allnames)
    set(h(k),'xlim',[xlimtmin ,xlimtmax]);
end
end



function edit_xlabelend_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xlabelend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xlabelend as text
%        str2double(get(hObject,'String')) returns contents of edit_xlabelend as a double


% --- Executes during object creation, after setting all properties.
function edit_xlabelend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xlabelend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function edit_ytick_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ytick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ytick as text
%        str2double(get(hObject,'String')) returns contents of edit_ytick as a double


% --- Executes during object creation, after setting all properties.
function edit_ytick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ytick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


