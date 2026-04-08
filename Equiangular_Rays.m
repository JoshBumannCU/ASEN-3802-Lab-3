function [x] = Equiangular_Rays(c,N)
% Summary: creates x-coordinate vector through equiangular lines
%   Creates x-coordinate vector using equiangular rays of radius half-chord
%   about a center at half chord. This creates a x vector that is denser
%   around areas where the airfoil would have more curvature (i.e. the
%   leading edge and trialing edge), starting at the leading edge and
%   ending and the trailing edge.
%   Inputs: 
%   N: Number of panels
%   c: chord length (m)
%   Outputs:
%   x: x-coordinate vector created via equiangular rays (m)
%   
%   Author: Colton Firster
%   Collaborators: Josh Bumann, Clara Eide, Lane Hollis
%   Date: 3/31/2026
theta = linspace(0,180,N+1); % angle vector from 0 to 180 deg equally spaced
x = c/2 - c/2 * cosd(theta); % x vector from equiangular rays
end
