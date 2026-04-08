% Summary: calculates cl with thin airfoil theory
%   Uses given equations to calculate the cl using thin airfoil theory.
%   Inputs: 
%   m: max camber
%   c: chord length (m)
%   p: postition of max camber
%   AoA: Angle of attack (alpha) - NEED INPUT IN DEG
%   Outputs: 
%   cl_ThinAirfoilTheory: lift coeffiecent from thin airfoil theory
%   ZeroLiftAoA: Zero lift angle of attack for airfoil
%   Author: Clara Eide
%   Collaborators: Josh Bumann, Colton Firster, Lane Hollis
%   Date: 4/7/2026

function [cl_ThinAirfoilTheory,ZeroLiftAoA] = ThinAirfoilTheory(c, m, p, AoA)
%calculating cl with Thin Airfoil Theory

AoA = deg2rad(AoA); % convert AoA to rad!!

fun = @(theta) dydx(theta, c, m, p) .* (cos(theta) - 1); % creates the function we need to integrate

ZeroLiftAoA = (-1 / pi) * integral(fun,0,pi); % numberically integrates the function

cl_ThinAirfoilTheory = 2*pi * (AoA - ZeroLiftAoA); % calculates cl using the AoA0 we just found

end

function dydx = dydx(theta,c,m,p)
% creating the dydx fucntion based on bounds given in doc

bound = acos(1-2*p); % in terms of theta
x = (c/2) .* (1-cos(theta)); % x from theta

dydx = zeros(size(theta)); % initalize

for i = 1:length(theta) % creates piecewise from doc
    if theta(i) < bound
        dydx(i) = ( (2*m / p) * (1 - (x(i)./(p*c)) ) );
    else
        dydx(i) = ( (2*m/(1-p)^2) * (p - x(i) / c) );
    end
end 

end