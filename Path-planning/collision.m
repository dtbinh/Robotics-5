function crash = collision(varargin)
% Collision detector for obstacles made up by spheres
% Inputs:
%   % varargin{1} = File with obstacles as (X,Y,Z,r) - (center,radius)
%   % varargin{2} = Coordinates to be tested
%   % varargin{3} = Default radius of the spheres if not set
% Output:
%   % crash = Boolean indicating whether or not there's a collision.
% Computes the distance of an object or point in the space to the different
% obstacles present in the environment. If the chosen point collides or is
% inside any of the obstacles, the point is refused and thus considered not
% possible for the system.

if length(varargin) > 2,    % If radius is provided explicitly
    sph_rad = varargin{3};
else
    sph_rad = varargin{1}(:,size(varargin{1},2));   % if radius is provided within the file
end
crash = false;          % Initially we consider there's no crush
for i=1:size(varargin{1},1),        % For every obstacle
    pos_obs = varargin{1}(i,1:3);   % Save the position of the obstacle
    if dist(varargin{2},pos_obs') < sph_rad(i), % Compute distance node-obstacle
        crash = true;   % If it smaller than the radius of the obstacle, then the node is not valid
        break
    end
end

