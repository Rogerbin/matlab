function [out ,childfolder] = search4all(varargin)
%search current folder and its child folder for all files and folders list
% output :
%       out  a cell including all files full pathname
%       childfolder list of  all folders inclued 
% input:
% varargin{1}  folder will be searched 
% varargin{2}  this parameter for filtering filename including 'filter string'

% usage:  searchfolder('c:\');
%        [files,folders]= searchfoldr('d:\','binx');

% Author :Roger Guo,Hust Physics,edited 2015.11.20,All rights in reserved.
% 
out = {};childfolder={};
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
            [t_out,t_childfolder] = search4all(thisone,varargin{2});
            out = [out;t_out];
%             [~,t_childfolder] = searchfolder(thisone,varargin{2});
            childfolder=[childfolder;{thisone};t_childfolder];
        else
            %when thisone is file
            %        disp(thisone);
            %         if need filtering
            if strfind(thisone,varargin{2})
                out = [out ; {thisone}];
            end
        end
    else
        %nargin <= 1,   not need filtering
        if child.isdir
            [t_out,t_childfolder] = search4all(thisone);
            out = [out;t_out];
            childfolder=[childfolder;{thisone};t_childfolder];
        else
            out = [out ; {thisone}];
        end
    end
end
end
