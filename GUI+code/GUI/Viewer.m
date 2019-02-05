function varargout = Viewer(varargin)
% VIEWER MATLAB code for Viewer.fig
%      VIEWER, by itself, creates a new VIEWER or raises the existing
%      singleton*.
%
%      H = VIEWER returns the handle to a new VIEWER or the handle to
%      the existing singleton*.
%
%      VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWER.M with the given input arguments.
%
%      VIEWER('Property','Value',...) creates a new VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Viewer

% Last Modified by GUIDE v2.5 01-Feb-2019 18:28:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Viewer_OpeningFcn, ...
    'gui_OutputFcn',  @Viewer_OutputFcn, ...
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


% --- Executes just before Viewer is made visible.
function Viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Viewer (see VARARGIN)


% Choose default command line output for Viewer
handles.output = hObject;



% UIWAIT makes Viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set (gcf, 'WindowButtonMotionFcn', @mouseMove);
set (gcf, 'WindowButtonDownFcn', @mouseClickDown);
set (gcf, 'WindowButtonUpFcn', @mouseClickUp);
handles.ImagesImported=false;
handles.selecting=false;
handles.mode='view';

% Update handles structure
guidata(hObject, handles);





% --- Outputs from this function are returned to the command line.
function varargout = Viewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

num=str2num(get(hObject,'String'));

data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    if num<=data.slices || num>=1
        data.layer=num;
    end
    
    data = displayImagesLayer(data);
    
    guidata(hObject,data)
    
end



function data = displayImagesLayer(data)

colormap(gcf, data.colormap)

layer = data.Volume.getLayer();

imagesc(data.axesT2, layer.T2)

if get(data.btnRigid, 'Value')
    imagesc(data.axesDWI, layer.DWIRigid)
elseif get(data.btnAffine, 'Value')
    imagesc(data.axesDWI, layer.DWIAffine)
elseif get(data.btnThin, 'Value')
    imagesc(data.axesDWI, layer.DWIThin)
else
    imagesc(data.axesDWI, layer.DWI)
end

TxLimits = get(data.axesT2, 'XLim');
TyLimits = get(data.axesT2, 'YLim');
DxLimits = get(data.axesDWI, 'XLim');
DyLimits = get(data.axesDWI, 'YLim');

data.TLimits={TxLimits, TyLimits};
data.DLimits={DxLimits, DyLimits};

ThHoriz = line(data.axesT2, data.TLimits{1}, nan(1, 2),'Color','g');
ThVert = line(data.axesT2, nan(1, 2), data.TLimits{2},'Color','g');

DhHoriz = line(data.axesDWI, data.DLimits{1}, nan(1, 2),'Color','g');
DhVert = line(data.axesDWI, nan(1, 2), data.DLimits{2},'Color','g');

data.Tline={ThHoriz, ThVert};
data.Dline={DhHoriz, DhVert};


function data = updateImagesLayer(data)


colormap(gcf, data.colormap)

layer = data.Volume.getLayer();

imagesc(data.axesT2, layer.T2)

if get(data.btnRigid, 'Value')
    imagesc(data.axesDWI, layer.DWIRigid)
elseif get(data.btnAffine, 'Value')
    imagesc(data.axesDWI, layer.DWIAffine)
elseif get(data.btnThin, 'Value')
    imagesc(data.axesDWI, layer.DWIThin)
else
    imagesc(data.axesDWI, layer.DWI)
end


TxLimits = get(data.axesT2, 'XLim');
TyLimits = get(data.axesT2, 'YLim');
DxLimits = get(data.axesDWI, 'XLim');
DyLimits = get(data.axesDWI, 'YLim');

data.TLimits={TxLimits, TyLimits};
data.DLimits={DxLimits, DyLimits};

ThHoriz = line(data.axesT2, data.TLimits{1}, nan(1, 2),'Color','g');
ThVert = line(data.axesT2, nan(1, 2), data.TLimits{2},'Color','g');

DhHoriz = line(data.axesDWI, data.DLimits{1}, nan(1, 2),'Color','g');
DhVert = line(data.axesDWI, nan(1, 2), data.DLimits{2},'Color','g');

data.Tline={ThHoriz, ThVert};
data.Dline={DhHoriz, DhVert};




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    key=eventdata.Key;
    
    if isequal(key,'rightarrow') || isequal(key,'uparrow')
        data.Volume=data.Volume.nextLayer;
    elseif isequal(key,'leftarrow') || isequal(key,'downarrow')
        data.Volume=data.Volume.previousLayer;
    end
    
    layer = data.Volume.getLayer();
    layer.clearPointsT2Display;
    layer.clearPointsDWIDisplay;
    
    set(handles.edit1,'string',num2str(data.Volume.getLayerNr));
    
    data = displayImagesLayer(data);
    
    if isequal(data.mode,'select')
        data = drawpoints(data);
    end
    guidata(hObject,data)
    
end






% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function importImages(hObject)

imagesImported=false;
volumeImported=false;

[file,path] = uigetfile({'*.mat;*.jpg;*.jpeg'},'Select a file');
if ~isequal(file,0)
    
    if file(end-3:end)=='.mat'
        
        num='';
        ok=0;
        for i = 1:length(file)
            
            if file(i)=='.'
                ok=0;
            end
            
            if ok
                num=strcat(num,file(i));
            end
            
            if file(i)=='_'
                ok=1;
            end
            
        end
        try
            try
                V=load(strcat(path,file));
                V=struct2cell(V);
                V=V{1};
                if isequal(class(V),'Volume')
                    volumeImported=true;
                    imagesImported=true;
                else
                    error('error');
                end
            catch
                IT2=load(strcat(path,'T2_',num,'.mat'));
                IT2=IT2.mat_img_T2;
                
                IDWI=load(strcat(path,'DWI_',num,'.mat'));
                IDWI=IDWI.mat_img_DWI;
            end
            
        catch
            try
                IM=load(strcat(path,file));
                IM=struct2cell(IM);
                IM=IM{1};
                IT2=IM.T2;
                IDWI=IM.DWI;
            catch
                IT2=load(strcat(path,file));
                [file,path] = uigetfile('*.mat','Select the DWI .mat file',path);
                try
                    IDWI=load(strcat(path,file));
                    IT2=struct2cell(IT2);
                    IDWI=struct2cell(IDWI);
                    try
                        IT2=IT2{1};
                        IDWI=IDWI{1};
                    catch
                        error('Could not load images');
                    end
                catch
                    error('Could not load images');
                end
            end
        end
        
    else
        IT2=imread(strcat(path,file));
        [file,path] = uigetfile({'*.jpg;*.jpeg'},'Select the DWI image file',path);
        IDWI=imread(strcat(path,file));
        if ndims(IT2)==3
            IT2=rgb2gray(IT2);
        end
        if ndims(IDWI)==3
            IDWI=rgb2gray(IDWI);
        end
    end
    
    if ~volumeImported && isnumeric(IT2) && isnumeric(IDWI) && 2<=ndims(IT2) && ndims(IT2)<=4 && 2<=ndims(IDWI) && ndims(IDWI)<=3
        if max(max(max(IT2)))<=1
            IT2=round(IT2*255);
        end
        if max(max(max(IDWI)))<=1
            IDWI=round(IDWI*255);
        end
        IT2=uint8(IT2);
        IDWI=uint8(IDWI);
        imagesImported = true;
    end
    
    if imagesImported
        
        data = guidata(hObject);
        
        if volumeImported
            data.Volume=V;
            data.file=file;
            data.path=path;
            data.firstSave=false;
        else
            data.Volume = Volume(IT2, IDWI);
            data.firstSave=true;
        end
        
        data.colormap='gray';
        
        set(data.edit1,'string',num2str(data.Volume.getLayerNr()));
        
        data.ImagesImported=true;
        data.selecting = false;
        data.dialogbox=NaN;
        data.dialogerror=nan;
        data.mouseClick = false;
        data.mouseX = nan;
        data.mouseY = nan;
        data.Tcont = 0;
        data.Tbright = 0;
        data.Dcont = 0;
        data.Dbright = 0;
        
        
        data = displayImagesLayer(data);
        guidata(hObject,data)
        
    end
end



% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to open_file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

if ~data.selecting
    importImages(hObject)
end



% --------------------------------------------------------------------
function uiselectpoints_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiselectpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    set(handles.uipointsadd,'Visible','on')
    set(handles.uipointsremove,'Visible','on')
    set(handles.ui3DView,'Visible','off')
    set(handles.btnevaluation,'Visible','off')
    set(handles.uiColormap,'Visible','off')
    set(handles.uiresetedit,'Visible','off')

    
    if ~isequal(data.mode,'select')
        data.selectPointsDisplay=cell(0,4);
        data.mode = 'select';
        set(data.btnRigid,'Value',0);
        set(data.btnAffine,'Value',0);
        set(data.btnThin,'Value',0);
        data = displayImagesLayer(data);
        data = drawpoints(data);
        guidata(hObject, data);
        
    end
    
end



% --------------------------------------------------------------------
function uipointsadd_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipointsadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    
    ThHoriz=data.Tline{1};
    ThVert=data.Tline{2};
    DhHoriz=data.Dline{1};
    DhVert=data.Dline{2};
    set(gcf, 'Pointer', 'arrow');
    set(ThHoriz, 'YData', nan(1, 2), 'LineStyle', '-');
    set(ThVert, 'XData', nan(1, 2), 'LineStyle', '-');
    set(DhHoriz, 'YData', nan(1, 2), 'LineStyle', '-');
    set(DhVert, 'XData', nan(1, 2), 'LineStyle', '-');
    
    set(data.editTX, 'string', ' ');
    set(data.editTY, 'string', ' ');
    
    set(data.editDX, 'string', ' ');
    set(data.editDY, 'string', ' ');
    
    set(data.editTV, 'string', ' ');
    set(data.editDV, 'string', ' ');
    
    %
    
    
    
    layer = data.Volume.getLayer();
    sizeT2=layer.getSizeT2();
    sizeDWI=layer.getSizeDWI();
    
    TxLimits=data.TLimits{1};
    TyLimits=data.TLimits{2};
    
    DxLimits=data.DLimits{1};
    DyLimits=data.DLimits{2};
    
    nrpoints = size(layer.pointsT2,1);
    
    button=1;
    x = TxLimits(1);
    y = TyLimits(1);
    
    data.selecting = true;
    guidata(hObject, data);
    
    while button == 1 && (((x >= TxLimits(1)) && (x <= TxLimits(2)) && (y >= TyLimits(1)) && (y <= TyLimits(2))) || ((x >= DxLimits(1)) && (x <= DxLimits(2)) && (y >= DyLimits(1)) && (y <= DyLimits(2))))
        
        [x, y, button] = ginput2(1);
        
        if isequal(gca, data.axesT2)
            layer=layer.addPointsT2([x, y]);
            
            hold(data.axesT2,'on')
            sT=scatter(data.axesT2,x,y,'g','Linewidth',2);
            tT=text(data.axesT2,x+sizeT2(2)*0.03, y-sizeT2(1)*0.03, num2str(size(layer.getPointsT2,1)),'BackgroundColor','w');
            hold(data.axesT2,'off')
            
            layer=layer.addPointsT2Display({sT, tT});
        elseif isequal(gca, data.axesDWI)
            layer=layer.addPointsDWI([x, y]);
            
            hold(data.axesDWI, 'on')
            sD=scatter(data.axesDWI,x,y,'g','Linewidth',2);
            tD=text(data.axesDWI,x+sizeDWI(2)*0.03, y-sizeDWI(1)*0.03, num2str(size(layer.getPointsDWI,1)),'BackgroundColor','w');
            hold(data.axesDWI, 'off')
            
            layer=layer.addPointsDWIDisplay({sD, tD});
        end
        
    end
    
    if size(layer.pointsT2,1)>size(layer.pointsDWI,1)
        for i = 1:(size(layer.pointsT2,1)-size(layer.pointsDWI,1))
            layer=layer.removePointsT2;
            layer=layer.removePointsT2Display;
        end
    elseif size(layer.pointsT2,1)<size(layer.pointsDWI,1)
        for i = 1:(size(layer.pointsDWI,1)-size(layer.pointsT2,1))
            layer=layer.removePointsDWI;
            layer=layer.removePointsDWIDisplay;
        end
    end
    
    if ~isequal(nrpoints, size(layer.pointsT2))
        layer.pointsChanged = true;
    else
        layer.pointsChanged = false;
    end
    
    data.Volume = data.Volume.setLayer(layer);
    
end

data.selecting = false;
guidata(hObject, data);



% --------------------------------------------------------------------
function uipointsremove_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipointsremove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    layer=data.Volume.getLayer();
    
    layer=layer.removePointsT2();
    layer=layer.removePointsDWI();
    layer=layer.removePointsT2Display();
    layer=layer.removePointsDWIDisplay();
    layer.pointsChanged = true;
    
end

data.Volume = data.Volume.setLayer(layer);

guidata(hObject, data);


function data = drawpoints(data)

if data.ImagesImported && ~data.selecting
    
    layer = data.Volume.getLayer();
    
    hold(data.axesT2,'on')
    hold(data.axesDWI,'on')
    for i=1:size(layer.getPointsT2,1)
        sT=scatter(data.axesT2, layer.pointsT2(i,1),layer.pointsT2(i,2),'g','Linewidth',2);
        tT=text(data.axesT2, layer.pointsT2(i,1)+layer.sizeT2(2)*0.03, layer.pointsT2(i,2)-layer.sizeT2(1)*0.03, num2str(i),'BackgroundColor','w');
        layer=layer.addPointsT2Display({sT, tT});
        
        sD=scatter(data.axesDWI, layer.pointsDWI(i,1), layer.pointsDWI(i,2),'g','Linewidth',2);
        tD=text(data.axesDWI, layer.pointsDWI(i,1)+layer.sizeDWI(2)*0.03, layer.pointsDWI(i,2)-layer.sizeDWI(1)*0.03, num2str(i),'BackgroundColor','w');
        layer=layer.addPointsDWIDisplay({sD, tD});
        
    end
    hold(data.axesT2,'off')
    hold(data.axesDWI,'off')
    
    data.Volume = data.Volume.setLayer(layer);
    
end


function mouseMove (hObject, ~)
data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    show_lines(hObject);
end

function mouseClickDown (hObject, ~)
data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    data.mouseClick = true;
end

guidata(hObject, data)

function mouseClickUp (hObject, ~)
data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    data.mouseClick = false;
    data.mouseX = nan;
    data.mouseY = nan;
end

guidata(hObject, data)


function show_lines(hObject)

data = guidata(hObject);

TxLimits=data.TLimits{1};
TyLimits=data.TLimits{2};
DxLimits=data.DLimits{1};
DyLimits=data.DLimits{2};

ThHoriz=data.Tline{1};
ThVert=data.Tline{2};
DhHoriz=data.Dline{1};
DhVert=data.Dline{2};

layer = data.Volume.getLayer();

mousePosT = get(data.axesT2, 'CurrentPoint');  % Current mouse position in axes
mousePosD = get(data.axesDWI, 'CurrentPoint');  % Current mouse position in axes
if (mousePosT(1, 1) >= TxLimits(1)) && (mousePosT(1, 1) <= TxLimits(2)) && ...
        (mousePosT(1, 2) >= TyLimits(1)) && (mousePosT(1, 2) <= TyLimits(2))
    
    if data.mouseClick && isequal(data.uiview.State, 'on')
        if isnan(data.mouseX)
            data.mouseX = mousePosT(1, 1);
            data.mouseY = mousePosT(1, 2);
        else
            xDif = -(data.mouseX - mousePosT(1, 1))/abs(TxLimits(2)-TxLimits(1));
            yDif = (data.mouseY - mousePosT(1, 2))/abs(TyLimits(2)-TyLimits(1));
            data.mouseX = mousePosT(1, 1);
            data.mouseY = mousePosT(1, 2);
            
            data.Tcont = data.Tcont + xDif;
            data.Tbright = data.Tbright + yDif;
            
            if data.Tcont<-1
                data.Tcont=-1;
            elseif data.Tcont>1
                data.Tcont=1;
            end
            
            if data.Tbright<-1
                data.Tbright=-1;
            elseif data.Tbright>1
                data.Tbright=1;
            end
             
            new_T2 = changeBrightCont(layer.T2default, data.Tcont, data.Tbright);
            layer.T2 = new_T2;
            
            data.Volume=data.Volume.setLayer(layer);
            data=updateImagesLayer(data);
        end
        ThHoriz=data.Tline{1};
        ThVert=data.Tline{2};
        DhHoriz=data.Dline{1};
        DhVert=data.Dline{2};
    end
    
    % Mouse is within axes limits:
    set(gcf, 'Pointer', 'custom', 'PointerShapeCData', nan(16));
    set(ThHoriz, 'YData', mousePosT(1, 2).*[1 1]);
    set(ThVert, 'XData', mousePosT(1, 1).*[1 1]);
    
    if get(data.btnRigid,'Value') || get(data.btnAffine,'Value') || get(data.btnThin,'Value')
        matrix=eye(3);
    else
        matrix=data.Volume.getLayer().transfNormal;
    end
    
    cord = matrix*[mousePosT(1,1); mousePosT(1,2); 1];
    set(DhHoriz, 'YData', cord(2).*[1 1], 'LineStyle', '--');
    set(DhVert, 'XData', cord(1).*[1 1], 'LineStyle', '--');
    
    displayCoordinates(data, [mousePosT(1,1), mousePosT(1,2)], [cord(1), cord(2)]);
    
    
elseif (mousePosD(1, 1) >= DxLimits(1)) && (mousePosD(1, 1) <= DxLimits(2)) && ...
        (mousePosD(1, 2) >= DyLimits(1)) && (mousePosD(1, 2) <= DyLimits(2))
   
    
    if data.mouseClick && isequal(data.uiview.State, 'on')
        if isnan(data.mouseX)
            data.mouseX = mousePosT(1, 1);
            data.mouseY = mousePosT(1, 2);
        else
            xDif = -(data.mouseX - mousePosT(1, 1))/abs(TxLimits(2)-TxLimits(1));
            yDif = (data.mouseY - mousePosT(1, 2))/abs(TyLimits(2)-TyLimits(1));
            data.mouseX = mousePosT(1, 1);
            data.mouseY = mousePosT(1, 2);
            
            data.Dcont = data.Dcont + xDif;
            data.Dbright = data.Dbright + yDif;
            
            if data.Dcont<-1
                data.Dcont=-1;
            elseif data.Dcont>1
                data.Dcont=1;
            end
            
            if data.Dbright<-1
                data.Dbright=-1;
            elseif data.Dbright>1
                data.Dbright=1;
            end
             
            if get(data.btnRigid, 'Value')
                new_DWIRigid = changeBrightCont(layer.DWIRigiddefault, data.Dcont, data.Dbright);
                layer.DWIRigid = new_DWIRigid;
            elseif get(data.btnAffine, 'Value')
                new_DWIAffine = changeBrightCont(layer.DWIAffinedefault, data.Dcont, data.Dbright);
                layer.DWIAffine = new_DWIAffine;
            elseif get(data.btnThin, 'Value')
                new_DWIThin = changeBrightCont(layer.DWIThindefault, data.Dcont, data.Dbright);
                layer.DWIThin = new_DWIThin;
            else
                new_DWI = changeBrightCont(layer.DWIdefault, data.Dcont, data.Dbright);
                layer.DWI = new_DWI;
            end
            
            data.Volume=data.Volume.setLayer(layer);
            data=updateImagesLayer(data);
            
        end
        ThHoriz=data.Tline{1};
        ThVert=data.Tline{2};
        DhHoriz=data.Dline{1};
        DhVert=data.Dline{2};
    end
    
    
    
    % Mouse is within axes limits:
    set(gcf, 'Pointer', 'custom', 'PointerShapeCData', nan(16));
    set(DhHoriz, 'YData', mousePosD(1, 2).*[1 1]);
    set(DhVert, 'XData', mousePosD(1, 1).*[1 1]);
    
    if get(data.btnRigid,'Value') || get(data.btnAffine,'Value') || get(data.btnThin,'Value')
        matrix=eye(3);
    else
        matrix=data.Volume.getLayer().transfNormalInv;
    end
    
    cord = matrix*[mousePosD(1,1); mousePosD(1,2); 1];
    set(ThHoriz, 'YData', cord(2).*[1 1], 'LineStyle', '--');
    set(ThVert, 'XData', cord(1).*[1 1], 'LineStyle', '--');
    
    displayCoordinates(data, [cord(1), cord(2)], [mousePosD(1,1), mousePosD(1,2)]);
    
else
    % Mouse is outside of axes limits:
    set(gcf, 'Pointer', 'arrow');
    set(ThHoriz, 'YData', nan(1, 2), 'LineStyle', '-');
    set(ThVert, 'XData', nan(1, 2), 'LineStyle', '-');
    set(DhHoriz, 'YData', nan(1, 2), 'LineStyle', '-');
    set(DhVert, 'XData', nan(1, 2), 'LineStyle', '-');
    
    set(data.editTX, 'string', ' ');
    set(data.editTY, 'string', ' ');
    
    set(data.editDX, 'string', ' ');
    set(data.editDY, 'string', ' ');
    
    set(data.editTV, 'string', ' ');
    set(data.editDV, 'string', ' ');
    
end

guidata(hObject, data);



function displayCoordinates(data, mouse1, mouse2)

set(data.editTX, 'string', round(mouse1(1)));
set(data.editTY, 'string', round(mouse1(2)));

set(data.editDX, 'string', round(mouse2(1)));
set(data.editDY, 'string', round(mouse2(2)));

layer = data.Volume.getLayer();


set(data.editTV, 'string', layer.getT2value(round([mouse1(2), mouse1(1)])));

Dpos=round([mouse2(2), mouse2(1)]);
            if get(data.btnRigid, 'Value')
                DWIvalue=layer.DWIRigid(Dpos(2), Dpos(1));
            elseif get(data.btnAffine, 'Value')
                DWIvalue=layer.DWIAffine(Dpos(2), Dpos(1));
            elseif get(data.btnThin, 'Value')
                DWIvalue=layer.DWIThin(Dpos(2), Dpos(1));
            else
                DWIvalue=layer.DWI(Dpos(2), Dpos(1));
            end
set(data.editDV, 'string',DWIvalue);





% --- Executes on mouse press over axes background.
function axesDWI_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesdwi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnNextSlice.
function btnNextSlice_Callback(hObject, eventdata, handles)
% hObject    handle to btnNextSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    data.Volume=data.Volume.nextLayer;
    layer = data.Volume.getLayer();
    layer.clearPointsT2Display;
    layer.clearPointsDWIDisplay;
    
    set(handles.edit1,'string',num2str(data.Volume.getLayerNr));
    
    data = displayImagesLayer(data);
    
    if isequal(data.mode,'select')
        data = drawpoints(data);
    end
    
    guidata(hObject,data)
    
end


% --- Executes on button press in btnPreviousSlice.
function btnPreviousSlice_Callback(hObject, eventdata, handles)
% hObject    handle to btnPreviousSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    data.Volume=data.Volume.nextLayer;
    layer = data.Volume.getLayer();
    layer.clearPointsT2Display;
    layer.clearPointsDWIDisplay;
    
    set(handles.edit1,'string',num2str(data.Volume.getLayerNr));
    
    guidata(hObject, data);
    
    if isequal(data.mode,'select')
        data = drawpoints(data);
    end
    
    guidata(hObject,data)
    
end


% --- Executes on button press in btnRigid.
function btnRigid_Callback(hObject, eventdata, handles)
% hObject    handle to btnRigid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnRigid

data = guidata(hObject);

if data.ImagesImported && ~isequal(data.mode,'select') && ~data.selecting
    
    if get(handles.btnRigid, 'Value')
        
        layer = data.Volume.getLayer;
        
        if ~isequal(layer.transfRigid,[])
            
            set(handles.btnAffine,'Value',0);
            set(handles.btnThin,'Value',0);
            
        else
            data.dialogerror=errordlg('You must select at least 5 points');
            set(handles.btnRigid,'Value',0);
        end
    end
    data = displayImagesLayer(data);
    guidata(hObject,data)
else
    set(handles.btnRigid,'Value',0);
end

% --- Executes on button press in btnAffine.
function btnAffine_Callback(hObject, eventdata, handles)
% hObject    handle to btnAffine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnAffine

data = guidata(hObject);

if data.ImagesImported && ~isequal(data.mode,'select') && ~data.selecting
    
    if get(data.btnAffine, 'Value')
        
        layer = data.Volume.getLayer;
        
        if ~isequal(layer.transfAffine,[])
            guidata(hObject,data);
            
            set(data.btnRigid,'Value',0);
            set(data.btnThin,'Value',0);
        else
            data.dialogerror=errordlg('You must select at least 5 points');
            set(data.btnAffine,'Value',0);
        end
    end
    data = displayImagesLayer(data);
    guidata(hObject,data)
else
    set(handles.btnAffine,'Value',0);
end



% --- Executes on button press in btnThin.
function btnThin_Callback(hObject, eventdata, handles)
% hObject    handle to btnThin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnThin

data = guidata(hObject);

if data.ImagesImported && ~isequal(data.mode,'select') && ~data.selecting
    
    if get(data.btnThin, 'Value')
        layer = data.Volume.getLayer;
        
        if ~isequal(layer.DWIThin,[])
            guidata(hObject,data);
            
            set(data.btnRigid,'Value',0);
            set(data.btnAffine,'Value',0);
        else
            data.dialogerror=errordlg('You must select at least 5 points');
            set(data.btnThin,'Value',0);
        end
    end
    data = displayImagesLayer(data);
    guidata(hObject,data)
else
    set(handles.btnThin,'Value',0);
end

function editTX_Callback(hObject, eventdata, handles)
% hObject    handle to editTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTX as text
%        str2double(get(hObject,'String')) returns contents of editTX as a double


% --- Executes during object creation, after setting all properties.
function editTX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTY_Callback(hObject, eventdata, handles)
% hObject    handle to editTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTY as text
%        str2double(get(hObject,'String')) returns contents of editTY as a double


% --- Executes during object creation, after setting all properties.
function editTY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTR_Callback(hObject, eventdata, handles)
% hObject    handle to editTR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTR as text
%        str2double(get(hObject,'String')) returns contents of editTR as a double


% --- Executes during object creation, after setting all properties.
function editTR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTV_Callback(hObject, eventdata, handles)
% hObject    handle to editTV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTV as text
%        str2double(get(hObject,'String')) returns contents of editTV as a double


% --- Executes during object creation, after setting all properties.
function editTV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTB_Callback(hObject, eventdata, handles)
% hObject    handle to editTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTB as text
%        str2double(get(hObject,'String')) returns contents of editTB as a double


% --- Executes during object creation, after setting all properties.
function editTB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDX_Callback(hObject, eventdata, handles)
% hObject    handle to editDX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDX as text
%        str2double(get(hObject,'String')) returns contents of editDX as a double


% --- Executes during object creation, after setting all properties.
function editDX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDY_Callback(hObject, eventdata, handles)
% hObject    handle to editDY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDY as text
%        str2double(get(hObject,'String')) returns contents of editDY as a double


% --- Executes during object creation, after setting all properties.
function editDY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDR_Callback(hObject, eventdata, handles)
% hObject    handle to editDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDR as text
%        str2double(get(hObject,'String')) returns contents of editDR as a double


% --- Executes during object creation, after setting all properties.
function editDR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDV_Callback(hObject, eventdata, handles)
% hObject    handle to editDV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDV as text
%        str2double(get(hObject,'String')) returns contents of editDV as a double


% --- Executes during object creation, after setting all properties.
function editDV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDB_Callback(hObject, eventdata, handles)
% hObject    handle to editDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDB as text
%        str2double(get(hObject,'String')) returns contents of editDB as a double


% --- Executes during object creation, after setting all properties.
function editDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiopenfile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiopenfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

if ~data.selecting
    importImages(hObject);
end



% --------------------------------------------------------------------
function uisavefigure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uisavefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

if data.ImagesImported && ~data.selecting
    saveVolume(hObject)
end

function saveImages(hObject)
data=guidata(hObject);
layer=data.Volume.getLayer;
l=num2str(data.Volume.layer);

if data.firstSave
    [file, path] = uiputfile(strcat('_Slice_',l,'_.jpg'));
    if isequal(file,0)
        return
    end
else
    [file, path] = uiputfile(strcat('_Slice_',l,'_.jpg'),data.path);
    if isequal(file,0)
        return
    end
end

if isequal(file(end-3:end),'.jpg')
    file=file(1:end-4);
end

imwrite(data.Volume.getLayer.T2,strcat(path,file,'T2.jpg'))
imwrite(data.Volume.getLayer.DWI,strcat(path,file,'DWI.jpg'))

if ~isequal(layer.DWIRigid,[])
    imwrite(layer.DWIAffine,strcat(path,file,'DW_Rigid.jpg'))
end
if ~isequal(layer.DWIAffine,[])
    imwrite(layer.DWIAffine,strcat(path,file,'DW_Affine.jpg'))
end
if ~isequal(layer.DWIThin,[])
    imwrite(layer.DWIThin,strcat(path,file,'DW_TPS.jpg'))
end



function saveVolume(hObject)

data=guidata(hObject);

if data.firstSave
    [file, path] = uiputfile('_Volume.mat');
    if ~isequal(file,0)
        if ~isequal(file(end-3:end),'.mat')
            file=strcat(file,'.mat');
        end
        data.file=file;
        data.path=path;
        data.firstSave=false;
    else
        return
    end
else
    file=data.file;
    path=data.path;
end

V=data.Volume;

save(strcat(path,file),'V');

guidata(hObject, data);


% --------------------------------------------------------------------
function uiview_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    data.Volume = data.Volume.updateTransforms();
    
    data.mode='view';
    
    set(handles.uipointsadd,'Visible','off')
    set(handles.uipointsremove,'Visible','off')
    set(handles.ui3DView,'Visible','on')
    set(handles.btnevaluation,'Visible','on')
    set(handles.uiColormap,'Visible','on')
    set(handles.uiresetedit,'Visible','on')
    
    layer=data.Volume.getLayer;
    layer.clearPointsT2Display;
    layer.clearPointsDWIDisplay;
    
    data.Volume = data.Volume.setLayer(layer);
    
end

guidata(hObject, data);


% --------------------------------------------------------------------
function uiview_OffCallback(hObject, eventdata, handles)
% hObject    handle to uiview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiview_OnCallback(hObject, eventdata, handles)
% hObject    handle to uiview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiselectpoints_OffCallback(hObject, eventdata, handles)
% hObject    handle to uiselectpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiselectpoints_OnCallback(hObject, eventdata, handles)
% hObject    handle to uiselectpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiColormap_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    colormaps={'hot', 'cool', 'bone', 'copper', 'pink', 'gray'};
    
    for i = 1 : length(colormaps)
        if isequal(data.colormap, colormaps{i})
            if i==length(colormaps)
                data.colormap = colormaps{1};
                break
            else
                data.colormap = colormaps{i+1};
                break
            end
        end
    end
    
    data = displayImagesLayer(data);
    
    guidata(hObject,data)
end


% --------------------------------------------------------------------
function Save_Images_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

if data.ImagesImported && ~data.selecting
    saveImages(hObject);
end


% --------------------------------------------------------------------
function Save_Volume_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveVolume(hObject)


% --------------------------------------------------------------------
function Save_Volume_As_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Volume_As (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

if data.ImagesImported && ~data.selecting
    data=guidata(hObject);
    data.firstSave=true;
    guidata(hObject,data)
    saveVolume(hObject)
end


% --------------------------------------------------------------------
function btnevaluation_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to btnevaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


data = guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    l = data.Volume.getLayer;
    
    if size(l.pointsT2,1)>=5
        
        
        dialogbox=DialogEvaluation(l);
        data.dialogbox=dialogbox;
        
    else
        data.dialogerror=errordlg('You must select at least 5 points');
    end
    
    guidata(hObject,data);
    
end


% --------------------------------------------------------------------
function ui3DView_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to ui3DView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

if data.ImagesImported && ~data.selecting
    
    V=data.Volume;
    
    figure(123);
    
    subplot(1,2,1)
    slidingviewer(V.volT2)
    pbaspect([1 1 1])
    
    subplot(1,2,2)
    slidingviewer(V.volDWI)
    pbaspect([1 1 1])
end


% --------------------------------------------------------------------
function uiresetedit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiresetedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=guidata(hObject);

layer=data.Volume.getLayer();
data.Volume=data.Volume.setLayer(layer.resetImages());

data = updateImagesLayer(data);

guidata(hObject, data);
