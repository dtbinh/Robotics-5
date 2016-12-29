% =====================================================================
%				Creacion de ficheros de referencia
% 			   Guiado,Navegacion y Control de Robots
%								MUAR
%							Curso 2015/16
% =====================================================================

% Declaracion de los nombres de los ficheros
nameSpatial = 'smooth_trayectoria.mat';
nameYaw = 'yaw.mat';

% Definicion de los puntos de paso obligados en trayectoria
posIni = [0,0,0];						% Posicion de inicio
posFin = [2,2,2];						% Posicion final
yaw = linspace(0,5,7)+rand(7,1);		% Vector a elegir 1-D
tol = 0.2;								% Tolerancia en la convergencia

% Planificacion de trayectorias
[smooth,raw,tree] = RT_smooth(posIni,posFin,tol);

% Alcanzada una trayectoria suave, guardar en ficheros externos
save(nameSpatial,'smooth')
save(nameYaw,'yaw')


