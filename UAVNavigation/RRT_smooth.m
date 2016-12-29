function [path_smooth,path_raw,tree] = RRT_smooth(qinit,qgoal,tol)
% Planificador mediante Random Trees de trayectorias
    % qinit = Vector con la posicion inicial
    % qgoal = Vector con la posicion objetivo
    % tol = Tolerancia para la convergencia del metodo
close all;
% Inicializacion de variables utilizadas en el arbol =====================
nodes = [];
nodes(1,:) = qinit;
error = dist(qinit,qgoal');
prevNode = []; prevNode(1) = 0;
c = 2;

% Definicion de los obstáculos - Carga desde fichero externo =============
load 'obstacles.txt';

% Creacion del arbol de busqueda =========================================
while error > tol,
    qrand = 10*rand(1,3)-5;
    d = dist(nodes,qrand');
    [~, index] = min(d);
    qnear = nodes(index,:);
    direccion = qrand - qnear;
    qnew = qnear + direccion/(5*norm(direccion));
    if (collision(obstacles,qnew) == false) && (qnew(3) > 0),
        nodes(size(nodes,1)+1,:) = qnew;
        error = dist(qnew,qgoal');
        prevNode(c) = index;
        c = c + 1;
    end
end

% Obtencion de la trayectoria final ======================================
L = size(nodes,1);
temp = prevNode(L);
path = [];
c = 1;

while temp ~= 0,
   path(c,:) = nodes(temp,:);
   c = c+1;
   temp = prevNode(temp);
end

tree = nodes;   % Almacenamiento de los arboles de busqueda
path_raw = flipud(path);    % Camino provisional (sin suavizado)

% Suavizado de la trayectoria obtenida ===================================

path(:,1) = smooth(path(:,1));
path(:,2) = smooth(path(:,2));
path(:,3) = smooth(path(:,3));
path_smooth = path;
