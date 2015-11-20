function out = searchfolder(varargin)
%search current folder and its child folder for all files 
% output : a cell including all files full pathname
% input:
% varargin{1}  folder will be searched 
% varargin{2}  this parameter for filtering filename including 'filter string'

% usage:  searchfolder('c:\');
%         searchfoldr('d:\','binx');

% Author :Roger Guo,Hust Physics,2015.11.19,All rights in reserved.

out = {};
if nargin<1
    helpdlg('no input floder');
    return;
else
    curfolder=varargin{1};
end
%if it is not a folder or it is an empty folder
if ~isdir(curfolder) || length(dir(curfolder)) < 3
    return;
end

%now we can list all its children
children = dir(curfolder);
%eliminate '.' and '..'
children = children(3:end);

for i=1:length(children)
    %get current struct
    child = children(i);
    %current child's full name
    thisone = fullfile(curfolder,child.name);
%     when  doing filter
    if nargin > 1
        if child.isdir
            %when thisone is folder
            out = [out;searchfolder(thisone,varargin{2})];
        else
            %when thisone is file
            %        disp(thisone);
            %         if need filtering
            if strfind(thisone,varargin{2})
                out = [out ; {thisone}];
            end
        end
    else
        %             not need filtering
        if child.isdir
            out = [out;searchfolder(thisone)];
        else
            out = [out ; {thisone}];
        end
    end
end
end
