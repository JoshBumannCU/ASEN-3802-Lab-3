function [x_b, y_b] = NACA_Airfoils(m,p,t,c,N)
    % x_b is a vector containing the x-location of the boundary points
    % y_b is a vector containing the y-location of the boundary points
    % m is the maximum camber
    % p is the location of maximum camber
    % t is the thickness
    % c is the chord length
    % N is the number of employed panels

    % Placeholder for the equiangular method
    x = linspace(0,c,N/2 + 1);

    % Thickness distribution
    yt = ((t/0.2) * c) * (0.2969 * sqrt(x/c) - 0.1260 * (x/c) - 0.3516 * ...
        (x/c).^2 + 0.2843 * (x/c).^3 - 0.1036 * (x/c).^4);

    % Mean camber line
    yc = zeros(size(x)); 
    
    % Check each x value against our yc condition
    for i = 1:length(x)
        if x(i) < p*c
            yc(i) = m * x(i) / p^2 * (2*p - x(i)/c);
        else
            yc(i) = m * (c - x(i)) / (1 - p)^2 * (1 + x(i)/c - 2*p);
        end
    end

    % Derivative of mean camber line
    dyc = zeros(size(x));

    for i = 1:length(x)
        if x(i) < p*c
            dyc(i) = (2*m/p^2) * (p - x(i)/c);
        else
            dyc(i) = (2*m/(1-p)^2) * (p - x(i)/c);
        end
    end
    
    % Local angle
    zeta = atan(dyc);

    % Upper surfaces
    xu = x - yt .* sin(zeta);
    yu = x - yt .* cos(zeta);

    % Lower surfaces
    xl = x + yt .* sin(zeta);
    yl = x + yt .* cos(zeta);

    % Still to do: add the TE clockwise order
end