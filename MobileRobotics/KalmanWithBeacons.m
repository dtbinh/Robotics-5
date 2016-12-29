% -----------------------------------------------------------------------
%                           FILTRO DE KALMAN
% -----------------------------------------------------------------------
clear;close all;clc;tic %TRAYECTORIA (AHORA CIRCULAR)
velocidadL = 0.2;       % Velocidad lineal
tStep = 0.5;            % Intervalo de actualizacion de los sensores (s)
distTotal = 4*pi;       % Distancia total recorrida por el robot
nPasos = 2*ceil(distTotal/(velocidadL*tStep));    % Nº de pasos del algoritmo
velocidadA = 2*pi/(nPasos*tStep/2);               % Velocidad angular
%   B) DEFINICION DE MATRICES DE COVARIANZA (ASUMIMOS CONSTANTES)
Q = [0.01*velocidadL*tStep 0;  % Covarianza del ruido del proceso
    0 0.002*velocidadA*tStep];  
P = 0.001*eye(3);       % Covarianza de la estimacion. Filas: x,y,theta
R = 0.001*eye(3);       % Covarianza del ruido de la medida. Filas: x,y,theta
%   C) POSICIONES DE LAS BALIZAS DE LOCALIZACION
balizas = [4 8;1 1;11 3];
%% Parte 1: Definicion de CCII y de parametros
%   A) DEFINICION DE LA]; % Columna 1 - Posicion X. Columna 2 - Posicion Y
%   D) INICIALIZACION DE LA GANANCIA DEL FILTRO K
K = zeros(3);
%   E) CONDICIONES INICIALES
X = [5;2;0];            % Estado real inicial
Xest = [6;3;pi];        % Estado estimado inicial (Similar al estado real inicial)
%   F) DEFINICION DE LAS TRAYECTORIAS IDEALES Y DE LAS RUIDOSAS
pathD = velocidadL*tStep*ones(nPasos,1); % Incremento en la posicion lineal
pathB = velocidadA*tStep*ones(nPasos,1); % Incremento en la posicion angular
noiseD = velocidadL*tStep*ones(nPasos,1) + sqrt(Q(1,1))*randn(nPasos,1); % Incremento lineal con ruido
noiseB = velocidadA*tStep*ones(nPasos,1) + sqrt(Q(2,2))*randn(nPasos,1); % Incremento angular con ruido

%% Parte 2: Filtro recursivo de Kalman
for k = 2:nPasos+1,
    %   A) OBTENEMOS EL ESTADO REAL DEL ROBOT 
    X(1,k) = X(1,k-1) + pathD(k-1)*cos(X(3,k-1)+pathB(k-1)/2);
    X(2,k) = X(2,k-1) + pathD(k-1)*sin(X(3,k-1)+pathB(k-1)/2);
    X(3,k) = X(3,k-1) + pathB(k-1);
    %   B) OBTENCION DE LAS MEDIDAS DESDE LAS BALIZAS
    Z = atan2(balizas(:,2)-X(2,k),balizas(:,1)-X(1,k)) - X(3,k) + sqrt(diag(R)).*randn(3,1);
    %   C) DEFINICION DE LA ENTRADA COMO LA TRAYECTORIA CON RUIDO
    U = [noiseD(k-1);noiseB(k-1)];
    %   D) PREDICCION DEL ESTADO (ODOMETRIA)
    % X(k) = A*X(k-1)+B*U(k)+ ruido(k-1)
    Xest(:,k) = Xest(:,k-1)+[U(1)*cos(Xest(3,k-1)+U(2)/2);
                            U(1)*sin(Xest(3,k-1)+U(2)/2);
                            U(2)];
    A = [1 0 -U(1)*sin(Xest(3,k-1)+U(2)/2);
        0 1 U(1)*cos(Xest(3,k-1)+U(2)/2);
        0 0 1]; % A es la Jacobiana del sistema
    B = [cos(Xest(3,k-1)+U(2)/2) (-0.5*U(1)*sin(Xest(3,k-1)+U(2)/2));
         sin(Xest(3,k-1)+U(2)/2) (0.5*U(1)*cos(Xest(3,k-1)+U(2)/2));
         0                      1];
    P(:,:,k) = A*P(:,:,k-1)*((A)') + B*Q*((B)');
    %   E) PREDICCION DE LA MEDIDA
    % Z(k) = H(X(k))
    Zest = atan2(balizas(:,2)-Xest(2,k),balizas(:,1)-Xest(1,k)) - Xest(3,k);
    H = [(balizas(:,2)-Xest(2))./((balizas(:,1)-Xest(1)).^2+(balizas(:,2)-Xest(2)).^2),...
        -(balizas(:,1)-Xest(1))./((balizas(:,1)-Xest(1)).^2+(balizas(:,2)-Xest(2)).^2),...
        -1*ones(3,1)];
    %   F) COMPARACION DE LA MEDIDA CON LO DESEADO
    Y = Z-Zest; % Innovacion en la medida
    S = H*P(:,:,k)*H'+R;
    K = P(:,:,k)*H'*inv(S);
    %   G) CORRECCION (ODOMETRIA + CORRECION)
    Xest(:,k) = Xest(:,k)+K*Y;
    P(:,:,k) = (eye(3)-K*H)*P(:,:,k);
end

%% Representaciones gráficas
subplot(2,2,1)
hold on
plot(balizas(:,1),balizas(:,2),'ko','MarkerFaceColor','k')
plot(X(1,:),X(2,:),'b.')
plot(Xest(1,:),Xest(2,:),'r.')
axis([0 12 0 12])
legend('Balizas','Real','Estimada')

subplot(2,2,2)
hold on
plot(1:nPasos+1,X(1,:),'k.')
plot(1:nPasos+1,Xest(1,:),'g.')

subplot(2,2,3)
hold on
plot(1:nPasos+1,X(2,:),'k.')
plot(1:nPasos+1,Xest(2,:),'g.')

subplot(2,2,4)
hold on
plot(1:nPasos+1,X(3,:),'k.')
plot(1:nPasos+1,Xest(3,:),'g.')

toc
