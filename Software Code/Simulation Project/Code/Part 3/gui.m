function varargout = gui(varargin)

% Initialize GUI state
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

% Assign callback function if input argument is a character string
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% Return output arguments if requested
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% GUI opening function
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% GUI output function
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% Callback for Read Image button
function read_image_Callback(hObject, eventdata, handles)
global im
[fn,pn,~]=uigetfile('*.jpg','Choose Image');
im = imread([pn fn]);
axes(handles.axes1);
imshow(im);title('Original Image');
handles.image = im;
guidata(hObject, handles);

% Callback for Process Image button
function process_image_Callback(hObject, eventdata, handles)
global im
x = str2double(get(handles.Input2,'String'));
[f,g] = size(im);
[Im]=ya(im, f, g, x);
NM = str2double(get(handles.Input1,'String'));
hold on
L = size(Im);
height = x;
width = x;
max_row = floor(L(1) / height);
max_col = floor(L(2) / width);
seg = cell(max_row,max_col);
m_image = cell(max_row,max_col);

% Split input image into segments
for row = 1:max_row
    for col = 1:max_col
        seg(row,col)= { Im( (row-1)*height+1 : row*height, (col-1)*width+1 : col*width, : ) };
    end
end

% Apply linear reconstruction on each segment
for i=1:max_row*max_col
    [m_image{i}] = linear_reconstruction(seg{i}, NM);
end

% Combine reconstructed segments into a new image
new_image = zeros(f, g, 3);
for row = 1:max_row
    for col = 1:max_col
        new_image( (row-1)*height+1 : row*height, (col-1)*width+1 : col*width, : ) = m_image{row,col};
    end
end

hold off

% Resize and display the new image
H=im2double(new_image);
new_IM=imresize(H,[f g/3]);
M_H = im2double(im);
im = imresize(M_H,[f,g/3]);
global similarity
similarity = ssim(im, new_IM);
axes(handles.axes2);
imshow(new_IM);title('Reconstructed Image');
set(handles.edit_simi,'string',num2str(similarity));
guidata(hObject, handles);

% Callback for Input1 edit text field
function Input1_Callback(hObject, eventdata, handles)
input = get(handles.Input1,'String'); % Get the input from the edit text field
input = str2double(input); % Convert the input string to a number
guidata(hObject, handles);

% Input1 edit text field object creation function
function Input1_CreateFcn(hObject, eventdata, handles)
% Set the background color of Input1 edit text field to white if the platform is a PC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Callback for Input2 edit text field
function Input2_Callback(hObject, eventdata, handles)
input = get(handles.Input2,'String'); % Get the input from the edit text field
input = str2double(input); % Convert the input string to a number
guidata(hObject, handles);

% Input2 edit text field object creation function
function Input2_CreateFcn(hObject, eventdata, handles)
% Set the background color of Input2 edit text field to white if the platform is a PC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Callback for edit_simi edit text field
function edit_simi_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% edit_simi edit text field object creation function
function edit_simi_CreateFcn(hObject, eventdata, handles)
% Set the background color of edit_simi edit text field to white if the platform is a PC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);

