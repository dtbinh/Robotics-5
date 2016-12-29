function [] = Control_Tanque()
close all
clear
clc
% Funcion con la interfaz gr·fica del usuario y el programa de ejecucion de
% un control borroso aplicado a un depÛsito de agua.

global backColor;
backColor = [0.8 0.9 1];

% Pantalla principal sobre la que construir
figure_handles = figure('units','normalized',...
    'position',[0.005 0.005 0.99 0.95],'menubar','none','resize','on',...
    'NumberTitle','off','name','Controlador del sistema de tanque',...
    'color',backColor);
handles = guihandles(figure_handles);

% Texto de presentacion
uicontrol('style','text','units','normalized',...
    'position',[0.3 0.95 0.4 0.05],'string','SISTEMA DE CONTROL',...
    'FontSize',21,'FontWeight','bold','backg',backColor);

% Texto y box para el tiempo de simulacion
uicontrol('style','text','units','normalized','string','Tiempo simulado',...
    'position',[0.09 0.88 0.1 0.05],'backg',backColor,'FontSize',10);
handles.editTime = uicontrol('style','edit','units','normalized',...
    'position',[0.11 0.88 0.05 0.02],'string',30);

% Slider, texto y box para el control de la ALTURA H de referencia
uicontrol('style','text','units','normalized','string','Altura de ref.',...
    'position',[0.1 0.8 0.08 0.05],'backg',backColor,...
    'FontSize',13);
handles.sliderH = uicontrol('style','slider','units','normalized',...
    'position',[0.19 0.825 0.15 0.025],'Tag','sliderH',...
    'min',0,'max',6,'value',3);
handles.editH = uicontrol('style','edit','units','normalized',...
    'position',[0.35 0.825 0.03 0.02],'Tag','editH','string','3');
set([handles.sliderH,handles.editH],'call',{@slicall,handles});

% Slider, texto y box para el control de la CONCENTRACION X de referencia
uicontrol('style','text','units','normalized','string','Concentracion de ref.',...
    'position',[0.1 0.71 0.08 0.05],'backg',backColor,...
    'FontSize',13);
handles.sliderX = uicontrol('style','slider','units','normalized',...
    'position',[0.19 0.72 0.15 0.025],'Tag','sliderX',...
    'min',0,'max',100,'value',50);
handles.editX = uicontrol('style','edit','units','normalized',...
    'position',[0.35 0.725 0.03 0.02],'Tag','editX','string','50');
set([handles.sliderX,handles.editX],'call',{@slicall,handles});

% Slider, texto y box para el control del FLUJO F de referencia
uicontrol('style','text','units','normalized','string','Flujo de ref.',...
    'position',[0.1 0.6 0.08 0.05],'backg',backColor,...
    'FontSize',13);
handles.sliderF = uicontrol('style','slider','units','normalized',...
    'position',[0.19 0.62 0.15 0.025],'Tag','sliderF',...
    'min',0,'max',20,'value',10);
handles.editF = uicontrol('style','edit','units','normalized',...
    'position',[0.35 0.625 0.03 0.02],'Tag','editF','string','10');
set([handles.sliderF,handles.editF],'call',{@slicall,handles});

% Slider, texto y box para el control de la TEMPERATURA T de referencia
uicontrol('style','text','units','normalized','string','Temperatura de ref.',...
    'position',[0.1 0.51 0.08 0.05],'backg',backColor,...
    'FontSize',13);
handles.sliderT = uicontrol('style','slider','units','normalized',...
    'position',[0.19 0.52 0.15 0.025],'Tag','sliderT',...
    'min',0,'max',70,'value',35);
handles.editT = uicontrol('style','edit','units','normalized',...
    'position',[0.35 0.525 0.03 0.02],'Tag','editT','string','35');
set([handles.sliderT,handles.editT],'call',{@slicall,handles});

% Pop-up para seleccionar un tipo de control borroso: TRIANGULAR,
% TRAPEZOIDAL,MIXTO Y ORIGINAL
handles.popup = uicontrol('units','normalized','style','pop',...
    'position',[0.15 0.45 0.08 0.025],'string',{'Triangular',...
    'Trapezoidal','Mixto','Original'});

% Ejes de representacion de variables a controlar: F1,F2,Kv
handles.axisF1 = axes('units','normalized',...
    'position',[0.45 0.66 0.25 0.2],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('Caudal F_1');
handles.axisF2 = axes('units','normalized',...
    'position',[0.72 0.66 0.25 0.2],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('Caudal F_2');
handles.axisKv = axes('units','normalized',...
    'position',[0.58 0.39 0.25 0.2],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('V·lvula K_v');

% Ejes de representacion de variables controladas: H,X3,T3,F3
handles.axisH = axes('units','normalized',...
    'position',[0.05 0.05 0.2 0.28],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('Altura H');
handles.axisX3 = axes('units','normalized',...
    'position',[0.29 0.05 0.2 0.28],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('Concentracion X_3');
handles.axisT3 = axes('units','normalized',...
    'position',[0.52 0.05 0.2 0.28],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('Temperatura T_3');
handles.axisF3 = axes('units','normalized',...
    'position',[0.75 0.05 0.2 0.28],...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[]);title('Caudal F_3');

% Boton de comienzo de la simulacion
handles.pushStart = uicontrol('style','push','units','normalized',...
    'position',[0.25 0.445 0.07 0.03],'string','Start','busyaction','cancel',...
    'interrupt','off','callback',{@pbStart_call,handles});

% Boton de terminacion de la simulacion
handles.pushStop = uicontrol('style','push','units','normalized',...
    'position',[0.35 0.445 0.07 0.03],'string','Borrar todo','busyaction','cancel',...
    'interrupt','off','callback',{@pbStop_call,handles});
 
guidata(figure_handles,handles)

function [] = slicall(varargin)
% Funcion general que liga los boxes y sliders para realizar cambios
% simultaneos en ambos elementos.

[h,handles] = varargin{[1,3]};
name = get(h,'Tag');
id = name(end);
if (strcmp(name(1),'s')),
    %Slider modificado
    related = findobj('Tag',strcat('edit',id));
    set(related,'string',get(h,'value'));
else
    %Box modificado
    related = findobj('Tag',strcat('slider',id));
    slider_value = get(related,{'min','max','value'});
    edit_string = str2double(get(h,'string'));
    if (edit_string >= slider_value{1}) && (edit_string <= slider_value{2}),
        set(related,'value',edit_string);
    else
        set(h,'string',slider_value{3});
    end
end

function [] = pbStart_call(varargin)
% Simulacion y representacion de los resultados
[h,handles] = varargin{[1,3]};
chose = get(handles.popup,'string');
control_option = chose{get(handles.popup,'value')};
switch control_option,      % Elegir el tipo de controlador
    case 'Triangular',
        CONTROL = readfis('triangular.fis');
    case 'Trapezoidal',
        CONTROL = readfis('trapezoidal.fis');
    case 'Mixto',
        CONTROL = readfis('mixto.fis');
end

t = 1;      % Inicializacion del tiempo
timeMax = str2double(get(handles.editTime,'string'));
% Condiciones iniciales
H(1:2) = zeros(1,2);
F3(1:2) = zeros(1,2);
X3(1:2) = 50*ones(1,2);
T3(1:2) = 10*ones(1,2);
F1(1) = 0;
F2(1) = 0;
Kv(1) = 0.5;
if (strcmp(control_option,'Original')),
    % Control casero
    t = 2;
    while (t<timeMax),
        % Obtener valores de referencia
        refH = get(handles.sliderH,'value');set(handles.editH,'string',num2str(refH));
        refX = get(handles.sliderX,'value');set(handles.editX,'string',num2str(refX));
        refT = get(handles.sliderT,'value');set(handles.editT,'string',num2str(refT));
        refF = get(handles.sliderF,'value');set(handles.editF,'string',num2str(refF));
        % Definir regiones de pertenencia
        H_alto = refH - 0.3;
        T_alto = refT + 2;
        T_bajo = refT - 2;
        X_alto = refX + 2;
        X_bajo = refX - 2;
        F_bajo = 10;
        % Reglas borrosas
        if H(t) > H_alto,
            F1(t) = F1(t-1) - 2;
            F2(t) = F2(t-1) - 2;
        end
        if (X3(t) < X_bajo),
            F1(t) = F1(t-1) + 1;
            F2(t) = F2(t-1) - 1;
        elseif (X3(t) > X_alto),
            F1(t) = F1(t-1) - 1;
            F2(t) = F2(t-1) + 1;
        end
        if (T3(t) < T_bajo),
            Kv(t) = Kv(t-1) + 0.3;
        elseif (T3(t) > T_alto),
            Kv(t) = Kv(t-1) - 0.3;
        else
            Kv(t) = Kv(t-1);
        end
        if (F3(t) < F_bajo),
            F1(t) = F1(t-1) + 1;
            F2(t) = F2(t-1) + 1;
        end
        
        % Control de minimos y maximos
        if (F1(t) > 10),
            F1(t) = 10;
        elseif (F1(t) < 0),
            F1(t) = 0;
        end
        if (F2(t) > 10),
            F2(t) = 10;
        elseif (F2(t) < 0),
            F2(t) = 0;
        end
        if (Kv(t) > 1),
            Kv(t) = 1;
        elseif (Kv(t) < 0),
            Kv(t) = 0;
        end
        
        [F3(t+1),X3(t+1),T3(t+1),H(t+1)] = IA0_ModeloPlanta(F1(t),F2(t),Kv(t),F3(t),X3(t),T3(t),H(t));
        % Control de limites en las variables de control
        if (H(t+1) > 6),
            H(t+1) = 6;
        end
        if (X3(t+1) > 90),
            X3(t+1) = 90;
        elseif (X3(t+1) < 10),
            X3(t+1) = 10;
        end
        % Representacion de variables de entrada H,X3,T3,F3
        axes(handles.axisH)
        plot(H,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Altura H');
        axes(handles.axisX3)
        plot(X3,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Concentracion X_3');
        axes(handles.axisT3)
        plot(T3,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Temperatura T_3');
        axes(handles.axisF3)
        plot(F3,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Caudal F_3');
        % Representacion de variables de salida F1,F2,Kv
        axes(handles.axisF1)
        plot(F1,'ok-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Caudal F_1');
        axis([1 timeMax 0 10])
        axes(handles.axisF2)
        plot(F2,'ok-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Caudal F_2');
        axis([1 timeMax 0 10])
        axes(handles.axisKv)
        plot(Kv,'ok-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('V·lvula K_v');
        drawnow

        t = t + 1;
    end
else
    %Control de toolbox
    while (t<timeMax),
        % Tomar valores de referencia de las entradas
        refH = get(handles.sliderH,'value');set(handles.editH,'string',num2str(refH));
        refX = get(handles.sliderX,'value');set(handles.editX,'string',num2str(refX));
        refT = get(handles.sliderT,'value');set(handles.editT,'string',num2str(refT));
        error = [refH-H(t);refX-X3(t);refT-T3(t)];
        L = evalfis(error,CONTROL);      % Evaluacion del modelo
        F1(t) = L(1); F2(t) = L(2);Kv(t) = L(3);% Asignacion de variables

        [F3(t+1),X3(t+1),T3(t+1),H(t+1)] = IA0_ModeloPlanta(F1(t),F2(t),...
            Kv(t),F3(t),X3(t),T3(t),H(t)); % Modelo de la planta

        % Representacion de variables de entrada H,X3,T3,F3
        axes(handles.axisH)
        plot(H,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Altura H');
        axes(handles.axisX3)
        plot(X3,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Concentracion X_3');
        axes(handles.axisT3)
        plot(T3,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Temperatura T_3');
        axes(handles.axisF3)
        plot(F3,'ob-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Caudal F_3');

        % Representacion de variables de salida F1,F2,Kv
        axes(handles.axisF1)
        plot(F1,'ok-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Caudal F_1');
        axis([1 timeMax 0 10])
        axes(handles.axisF2)
        plot(F2,'ok-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('Caudal F_2');
        axis([1 timeMax 0 10])
        axes(handles.axisKv)
        plot(Kv,'ok-','MarkerFaceColor','k','MarkerSize',3);grid on;hold on;title('V·lvula K_v');
        drawnow

        t = t + 1;

    end
end
guidata(gcbo,handles)

function [] = pbStop_call(varargin)
% Detencion de la simulacion
[h,handles] = varargin{[1,3]};
clear;clc;
arrayfun(@cla,findall(0,'type','axes'))
