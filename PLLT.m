% Lab 3 Part 2
% Contributors: Josh Bumann, Clara Eide, Colton Firster, Lane Hollis

% Outputs:
% e - span efficiency factor
% C_L - coefficient of lift
% C_Di - induced coefficient of drag

% Inputs:
% b - span (ft)
% a0_t - cross-sectional lift slope at the tips (per radian)
% a0_r - cross-sectional lift slope at the root (per radian)
% c_t - chord at the tips (ft)
% c_r - chord at the root (ft)
% aero_t - zero-lift angle of attack at the tips (degrees)
% aero_r - zero-lift angle of attack at the root (degrees)
% geo_t - geometric angle of attack at the tips (degrees)
% geo_r - geometric angle of attack at the root (degrees)
% N - number of odd terms to include in the series expansion for
% circulation

function [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N)
    
    % Transforming into theta
    theta = (1:N)' * pi/(2*N); % Directly from lab doc
    y = -(b/2)*cos(theta);

    % Generate odd fourier term numbers
    n = (2*(1:N) - 1)';

    % Linear Distribution Derivation Example
    %
    % Linear variation from root to tip using the two poins:
    % (|y|, c) = (0, c_r) at the root
    % (|y|, c) = (b/2, c_t) at the tip
    %
    % Slope:
    % m = (c_t - c_r) / ((b/2) - 0)
    %
    % Point Slope form starting from the root point
    % c(y) - c_r = m*(|y| - 0)
    %
    % So:
    % c(y) = c_r + m*|y|
    % 
    % Equivalently:
    % c(y) = c_r + (c_t - c_r) * |y| / (b/2)

    % y: spanwise position
    % b/2: half span
    halfSpanFraction = abs(y) / (b/2);
    
    a0 = a0_r + (a0_t - a0_r) .* halfSpanFraction;
    c = c_r + (c_t - c_r) .* halfSpanFraction;
    aero = aero_r + (aero_t - aero_r) .* halfSpanFraction;
    geo = geo_r + (geo_t - geo_r) .* halfSpanFraction;

    % Convert aero and geo to rad since they are given in degrees
    aeroRad = deg2rad(aero);
    geoRad = deg2rad(geo);

    % Start with the provided eq
    % geo(theta) = 4b/(a0(theta)*c(theta)) sum n=1 -> N An sin(ntheta) +
    % aero(theta) + sum n=1 -> N nAn sin(ntheta)/sin(theta)
    %
    % Rearrange the summations and move over aero(theta) 
    % geo(theta) - aero(theta) = sum n=1 -> N of...
    % An sin(ntheta) [2b/(pic(theta) + n/sin(theta)
    %
    % The left side of the equation is now know.
    % 
    % Truncating the series expansion yields,
    % geo(theta) - aero(theta) = sum j=1 -> N of...
    % A_2j-1 sin((2j-1)theta)[4b/(a0(theta)c(theta) + (2j-1)/sin(theta)]
    %
    % Matrix form: Mx = rightSide
    % Mirroring the above equation gives us this standard matrix form
    % sum j=1 -> N A_2j-1 sin((2j-1)theta)[4b/(a0(theta)c(theta) +
    % (2j-1)/sin(theta)] = geo(theta) - aero(theta)
    %
    % M = coefficient matrix
    % Each entry M(i,j) is the coefficient multiplying the j-th Fourier
    % coefficient in the i-th control point equation
    %
    % x = unknown column vector of Fourier coefficients
    % x = [A1; A3; ...; A_(2N-1)]
    % 
    % rightSide = right hand side column vector
    % rightSide = geo - aero across the wing

    
    M = zeros(N,N); % Preallocate memory for our matrix

    % Nested for loops to compute all angles and use all Fourier coefficients
    for i = 1:N
        for j = 1:N
            M(i,j) = sin(n(j) * theta(i)) * (((4*b) / (a0(i) * c(i)))...
                + (n(j) / sin(theta(i))));
        end
    end

    rightSide = geoRad - aeroRad; % Solving the right hand side of known variables

    % MATLAB prefers x = a\b rather than x = b^-1 * a
    x = M \ rightSide;

    % Area of a trapezoid using c_r, c_t, and b to find S
    S = ((c_r + c_t) / 2) * b;

    AR = (b^2) / S; % L17 p9

    c_L = pi * AR * x(1); % L17 p16
    c_Di = pi * AR * sum (n .* (x.^2)); % L17 p16
    delta = sum(n(2:end) .* (x(2:end) / x(1)).^2); % L17 p16
    e = 1 / (1 + delta); % L17 p16
end