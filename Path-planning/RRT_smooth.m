function [path_smooth,path_raw,tree] = RRT_smooth(qinit,qgoal,tol)
% Generates a RRT to find the path between two points in 3-d space
% Inputs:
%   % qinit = 1x3 vector. Initial position
%   % qgoal = 1x3 vector. Destination
%   % tol = Scalar. Minimal distance to reach destination
% Outputs:
%   % path_smooth = Nx3 matrix. Smoothed path from qinit to qgoal
%   % path_raw = Nx3 matrix. Original path
%   % tree = Nx3 matrix. Unordered nodes of the tree. Useful only for
%   visualization.
% NOTE: The obstacles of the environment must be loaded from an external
% file which name shall be 'obstacles.txt',which can be empty. Moreover, 
% this script is built under the assumption of a 3-dimensional space. 
% Thus, is has to be modified if the number of degrees of freedom is
% smaller.

close all;  % Close all previous plots
% Initialization of the tree =======================
nodes = [];         % Empty array for nodes
nodes(1,:) = qinit;     % Set the first node at the origin
error = dist(qinit,qgoal');     % Distance between tree and goal
prevNode = []; prevNode(1) = 0;     % Variable used for node's tracking
c = 2;      % Auxiliar variable used to grow the tree

% Load the obstacles from external file ============
load 'obstacles.txt';

% Body of the algorithm ============================
while error > tol,          % While distance tree-goal is bigger than desired,
    qrand = 10*rand(1,3)-5;     % Generate a random point
    d = dist(nodes,qrand');     % Compute the distances nodes-random point
    [~, index] = min(d);        % Find the closest node
    qnear = nodes(index,:);     % Set provisionally that node as closest
    direccion = qrand - qnear;  % Compute the direction to grow
    qnew = qnear + direccion/(5*norm(direccion));   % Compute the possible new node
    if (collision(obstacles,qnew) == false),    % If there's not collision 
        nodes(size(nodes,1)+1,:) = qnew;    % Grow the tree
        error = dist(qnew,qgoal');      % Update the distance tree-goal
        prevNode(c) = index;            % Store which node qnew comes from
        c = c + 1;              % Get ready for next successful node
    end
end

% Obtain the final path ============================
L = size(nodes,1);      % Number of nodes
temp = prevNode(L);     % Temporal variable to record the path
path = [];              % Initialize the path
c = 1;                  % Re-initialize for node's tracking

while temp ~= 0,        % While the origin has not been reached,
   path(c,:) = nodes(temp,:);   % Path is walked backwards
   c = c+1;
   temp = prevNode(temp);
end

tree = nodes;   % Save the tree's nodes
path_raw = flipud(path);    % Raw path, no smoothing, just the nodes in the right order

% Path smoothing ===================================

path(:,1) = smooth(path(:,1));  % Matlab does it for us
path(:,2) = smooth(path(:,2));
path_smooth = path;
