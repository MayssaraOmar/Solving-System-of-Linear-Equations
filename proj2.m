function varargout = proj2(varargin)
% PROJ2 MATLAB code for proj2.fig
%      PROJ2, by itself, creates a new PROJ2 or raises the existing
%      singleton*.
%
%      H = PROJ2 returns the handle to a new PROJ2 or the handle to
%      the existing singleton*.
%
%      PROJ2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJ2.M with the given input arguments.
%
%      PROJ2('Property','Value',...) creates a new PROJ2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proj2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proj2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proj2

% Last Modified by GUIDE v2.5 22-Dec-2019 22:19:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @proj2_OpeningFcn, ...
                   'gui_OutputFcn',  @proj2_OutputFcn, ...
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


% --- Executes just before proj2 is made visible.
function proj2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to proj2 (see VARARGIN)

% Choose default command line output for proj2
handles.output = hObject;
handles.method.String = {'GaussElimination', 'GaussJordan', 'GaussSiedel', 'LUDecomposition'};
method_Callback(handles.method, [], handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes proj2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = proj2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function nEq_Callback(hObject, eventdata, handles)
% hObject    handle to nEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nEq as text
%        str2double(get(hObject,'String')) returns contents of nEq as a double


% --- Executes during object creation, after setting all properties.
function nEq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%handles.nEq=hObject;


% --- Executes on button press in solveBttn.
function solveBttn_Callback(hObject, eventdata, handles)
% hObject    handle to solveBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n =  get(handles.nEq,'String');
n = str2double(n);
a = sym('a', [1 n]);
eqs = strings(1,n);
xlbls = '';
for i =1:n
    xlbls{1,i} = sprintf('x%d', i);
end
for i =1:n
    y = get(handles.hEdit(i),'String');
    eqs(1,i) = y;
end
[A,B] = equationsToMatrix(eqs,a);
solveMethod = get(handles.method,'Value');
switch(solveMethod)
    case 1
        tic;
        [res, err] = GaussElimination(A,B);
        ext = toc;
        res = res'
        set(handles.uitable1,'ColumnName',xlbls);
    case 2
        tic;
        [res, err] = GaussJordan(A,B);
        ext = toc;
        res = double(res')
        set(handles.uitable1,'ColumnName',xlbls);
    case 3
        Xold = str2num(char(get(handles.xi_edit,'String')));
        es = str2double(get(handles.eps_edit,'String'));
        maxi = str2double(get(handles.maxi_edit,'String'));
        tic;
        [res, err] = GaussSeidel(A,B,Xold',maxi,es);
        ext = toc;
        if(~err)
            ttl = {'i'};
            for i =1:n
                ttl{1,i+1} = sprintf("x%d", i);
            end
            for i =n+1:2*n
                ttl{1,i+1} = sprintf("ea%d", i-n);
            end
            set(handles.uitable1,'ColumnName',ttl);
            plotvals = res(:,2:n+1)';
            ploti = res(:,1)';
            axes(handles.axes1);
            for i =1:n
                plot(ploti,plotvals(i,:));
                hold on;
                grid on;
            end
            hold off;
        end
    case 4
        tic;
        [res, err] = LUDecomposition(A,B);
        ext = toc;
        res = res';
        set(handles.uitable1,'ColumnName',xlbls);
end
if(err)
    set(handles.ext_txt,'String','Error: Division by zero occurred');
else
    set(handles.uitable1, 'Data', res);
    strcat('execution time = ', sprintf(" %f", ext), ' seconds');
    set(handles.ext_txt,'String',strcat('execution time = ', sprintf(" %f", ext), ' seconds'));
end


% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method
if get(handles.method,'Value') ~= 3
    %hide
    disp('hide');
    set(handles.xi_text,'Visible','off');
    set(handles.xi_edit,'Visible','off');
    set(handles.eps_text,'Visible','off');
    set(handles.eps_edit,'Visible','off');
    set(handles.maxi_text,'Visible','off');
    set(handles.maxi_edit,'Visible','off');
else
    %show
    disp('show')
    set(handles.xi_text,'Visible','on');
    set(handles.xi_edit,'Visible','on');
    set(handles.eps_text,'Visible','on');
    set(handles.eps_edit,'Visible','on');
    set(handles.maxi_text,'Visible','on');
    set(handles.maxi_edit,'Visible','on');
end

% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetBttn.
function resetBttn_Callback(hObject, eventdata, handles)
% hObject    handle to resetBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to nxtBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n =  get(handles.nEq,'String');
n = str2double(n);
for i=1:n  
     delete(handles.hEdit(i));
     delete(handles.hText(i));
 end
 guidata(hObject,handles);


function maxi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxi_edit as text
%        str2double(get(hObject,'String')) returns contents of maxi_edit as a double


% --- Executes during object creation, after setting all properties.
function maxi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eps_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps_edit as text
%        str2double(get(hObject,'String')) returns contents of eps_edit as a double


% --- Executes during object creation, after setting all properties.
function eps_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xi_edit as text
%        str2double(get(hObject,'String')) returns contents of xi_edit as a double


% --- Executes during object creation, after setting all properties.
function xi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nxtBttn.
function nxtBttn_Callback(hObject, eventdata, handles)
% hObject    handle to nxtBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n =  get(handles.nEq,'String');
n = str2double(n);

for i=1:n  
     handles.hText(i)=uicontrol('Style', 'text', 'String', sprintf('Equation %d',i), ...
        'Position', [10, 350 - (i-1)*35, 100, 30], 'HorizontalAlignment', 'left');
     handles.hEdit(i)=uicontrol('Style', 'edit', ...
        'Position', [105, 350 - (i-1)*35, 200, 30]);
 end
 guidata(hObject,handles);



% --- Executes on key press with focus on nxtBttn and none of its controls.
function nxtBttn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to nxtBttn (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over nxtBttn.
function nxtBttn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to nxtBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.uitable = hObject;

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in readfile_bttn.
function readfile_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to readfile_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.txt');
fname=strcat(path,file);
fileID = fopen(fname,'r');
n = str2num(fgetl(fileID));
set(handles.nEq,'String',num2str(n));
for i=1:n  
     handles.hText(i)=uicontrol('Style', 'text', 'String', sprintf('Equation %d',i), ...
        'Position', [10, 350 - (i-1)*35, 100, 30], 'HorizontalAlignment', 'left');
     handles.hEdit(i)=uicontrol('Style', 'edit', ...
        'Position', [105, 350 - (i-1)*35, 200, 30]);
end
guidata(hObject,handles);
f = fgetl(fileID);
if(strcmp(f,'Gaussian-elimination'))
    set(handles.method,'Value',1);
else
    if(strcmp(f,'Gaussian-jordan'))
        set(handles.method,'Value',2);
    else
        if(strcmp(f,'Gaussian-seidel'))
            set(handles.method,'Value',3);
            method_Callback(handles.method, [], handles);
        else
            set(handles.method,'Value',4);
        end
    end
end
for i=1:n
    f = fgetl(fileID);
    set(handles.hEdit(i), 'String', f);
end
if(get(handles.method,'Value') == 3)
    f = fgetl(fileID)
    set(handles.xi_edit, 'String', f);
end
