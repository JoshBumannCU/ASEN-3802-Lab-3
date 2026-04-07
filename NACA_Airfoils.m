function [x_b, y_b, x, y_c] = NACA_Airfoils(m,p,t,c,N)
%% ASEN 3802 - Part 1 - NACA Airfoils
% Take user inputs from main function and calculates the appropriate
% positions of points to plot the airfoil then returns them to the main function. 
%
% Authors: Josh Bumann, Lane Hollis
% Collaborators: Colton Firster, Clara Eide
% Date: 4/7/2026
    % x_b is a vector containing the x-location of the boundary points
    % y_b is a vector containing the y-location of the boundary points
    % m is the maximum camber
    % p is the location of maximum camber
    % t is the thickness
    % c is the chord length
    % N is the number of employed panels

    % Placeholder for the equiangular method
    x = Equiangular_Rays(c, N);

    % Thickness distribution
    yt = ((t/0.2) * c) * (0.2969 * sqrt(x/c) - 0.1260 * (x/c) - 0.3516 * ...
        (x/c).^2 + 0.2843 * (x/c).^3 - 0.1036 * (x/c).^4);

    % Mean camber line
    y_c = zeros(size(x)); 
    
    % Check each x value against our y_c condition
    for i = 1:length(x)
        if x(i) < p*c
            y_c(i) = m * x(i) / p^2 * (2*p - x(i)/c);
        else
            y_c(i) = m * (c - x(i)) / (1 - p)^2 * (1 + x(i)/c - 2*p);
        end
    end

    % Derivative of mean camber line
    dy_c = zeros(size(x));

    for i = 1:length(x)
        if x(i) < p*c
            dy_c(i) = (2*m/p^2) * (p - x(i)/c);
        else
            dy_c(i) = (2*m/(1-p)^2) * (p - x(i)/c);
        end
    end
    
    % Local angle
    zeta = atan(dy_c);

    % Upper surfaces
    xu = x - yt .* sin(zeta);
    yu =y_c + yt .* cos(zeta);

    % Lower surfaces
    xl = x + yt .* sin(zeta);
    yl = y_c - yt .* cos(zeta);

    % Still to do: add the TE clockwise order

    % Combine upper and lower surface coordinates
    x_b = [flip(xl), xu(2:end)];
    y_b = [flip(yl), yu(2:end)];


end
