%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAVIGATION OF AN UAV IN AN UNKKNOWN ENVIRONMENT DEFINED IN

EXTERNAL FILE (SPANISH BELOW)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

1. Included files:

  - Datasheets with sensor's specifications (pdf's docs).
  - Simulink model of the quadrotor (GNC.slx).
  - Path planning script with smoothing (SMOOT_RRT.m)
  - External file with data relative to map's obstacles (obstacles.txt)
  - Automatic generation of path points (createFiles.m)
  - Collision detector function (collision.m).
  
  
2. How-to:

  With the file "createFiles.m" the selection of initial and final
  points in a path is made easier, either for spatial coordinates and
  the Yaw angle. The system will run automatically the path planning
  routine and will return a .mat file with the target points of the path.
  
  This path is a smoothed version of the original one.
  
  Afterwards, the file "GNC.slx" contains the whole model, clearly ordered.
  
 (SPANISH VERSION)
 
1. Archivos incluidos:

	- Datasheets de información de los sensores (documentos
		en .pdf).
	- Modelo de Simulink de control del quadrotor (GNC.slx).
	- Script planificador de trayectorias con función de sua-
		vizado (SMOOTH_RRT.m)
	- Fichero externo con los datos de los obstáculos del mapa.
		(obstacles.txt).
	- Script de automatización para la generación de puntos
		de la trayectoria (createFiles.m)
	- Función de detección de colisiones (collision.m)

2. Instrucciones:

	Con el archivo "createFiles.m" se puede facilitar la 
	elección de puntos de inicio y final de una trayectoria,
	tanto para las coordenadas espaciales como para el Yaw.
	El sistema ejecutará de forma automática la planificación
	de trayectorias y devolverá un fichero .mat con los puntos
	a alcanzar.

	Esta trayectoria supone un suavizado del camino inicial.

	Tras ello, el archivo "GNC.slx" contiene todo el modelo
	dinámico, ordenado de forma clara.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P.S: There are still some mistakes relating the sensors and the feedback from the Kalman Filter Cascade. Please keep that in mind if you are to use these files.
