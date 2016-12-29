function crash = collision(varargin)
% Detector de colisiones para un entorno conpuesto por esferas
    % varargin{1} = Archivo con info sobre los obstáculos (X,Y,Z,r)
    % varargin{2} = Posicion del quadrotor
    % varargin{3} = Radio de las esferas obstáculo default

quad_rad = 0.3;             % Radio del quadrotor
if length(varargin) > 2,
    sph_rad = varargin{3};
else
    sph_rad = varargin{1}(:,size(varargin{1},2));
end
crash = false;
for i=1:size(varargin{1},1),
    dist_lim = quad_rad + sph_rad(i);
    pos_obs = varargin{1}(i,1:3);
    if dist(varargin{2},pos_obs') < dist_lim,
        crash = true;
        break
    end
end

