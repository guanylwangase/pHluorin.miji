function varargout = GUI_tools(varargin)
% GUI_TOOLS MATLAB code for GUI_tools.fig
%      GUI_TOOLS, by itself, creates a new GUI_TOOLS or raises the existing
%      singleton*.
%
%      H = GUI_TOOLS returns the handle to a new GUI_TOOLS or the handle to
%      the existing singleton*.
%
%      GUI_TOOLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TOOLS.M with the given input arguments.
%
%      GUI_TOOLS('Property','Value',...) creates a new GUI_TOOLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_tools_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_tools_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_tools

% Last Modified by GUIDE v2.5 09-Jul-2013 22:55:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_tools_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_tools_OutputFcn, ...
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


% --- Executes just before GUI_tools is made visible.
function GUI_tools_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_tools (see VARARGIN)

% Choose default command line output for GUI_tools
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_tools wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_tools_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in kinetic.
function kinetic_Callback(hObject, eventdata, handles)
% hObject    handle to kinetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

run KineticAnalyser
