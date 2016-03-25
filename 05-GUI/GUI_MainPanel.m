function varargout = GUI_MainPanel(varargin)
% GUI_MainPanel MATLAB code for GUI_MainPanel.fig
%      GUI_MainPanel, by itself, creates a new GUI_MainPanel or raises the existing
%      singleton*.
%
%      H = GUI_MainPanel returns the handle to a new GUI_MainPanel or the handle to
%      the existing singleton*.
%
%      GUI_MainPanel('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MainPanel.M with the given input arguments.
%
%      GUI_MainPanel('Property','Value',...) creates a new GUI_MainPanel or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI_MainPanel before GUI_MainPanel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_MainPanel_OpeningFcn via varargin.
%
%      *See GUI_MainPanel Options on GUIDE's Tools menu.  Choose "GUI_MainPanel allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_MainPanel

% Last Modified by GUIDE v2.5 09-Jul-2013 18:07:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_MainPanel_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_MainPanel_OutputFcn, ...
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


% --- Executes just before GUI_MainPanel is made visible.
function GUI_MainPanel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_MainPanel (see VARARGIN)

% Choose default command line output for GUI_MainPanel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_MainPanel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_MainPanel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_IJ.
function pushbutton_IJ_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_IJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Miji;


% --- Executes on button press in pushbutton_Initialise.
function pushbutton_Initialise_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Initialise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run Initialiser;


% --- Executes on button press in pushbutton_launch.
function pushbutton_launch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run Launcher;


% --- Executes on button press in pushbutton_setlib.
function pushbutton_setlib_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setlib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global libdir
libdir = uigetdir();



% --- Executes on button press in pushbutton_setbatch.
function pushbutton_setbatch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setbatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global libdir
batchdir=uigetdir(libdir);
filelist=dir(batchdir);
filelist={filelist.name};
filelist=filelist(3:end);
handles.batchdir=batchdir;
handles.filelist=filelist;
guidata(hObject,handles);


% --- Executes on button press in pushbutton_startbatch.
function pushbutton_startbatch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_startbatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global temppath resultpath homedir
filelist=handles.filelist;
len=size(filelist,2);

bar = waitbarT(0,'Working');


for i=1:len
    if isempty(strfind(char(filelist(i)),'.db'))==0
        continue
    end
    
    
    img=['path=[' handles.batchdir '\' char(filelist(i)) ']'];
    ijimg = strrep(img, '\', '\\');
    MIJ.run('Open...',ijimg);
    waitbarT(i/len,bar);
    
    try 
        run Launcher;
    catch exception 
        logname=[resultpath 'errors-' datestr(now,'yyyymmdd-HH') '.txt'];
        log=[char(filelist(i)), char(10)];
        fid = fopen(logname, 'a+');
        fwrite(fid, log);
        fclose(fid);
        IJMacroLoader(3);
    end
 
end
close(bar);


% --- Executes on button press in pushbutton_tools.
function pushbutton_tools_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run GUI_tools
