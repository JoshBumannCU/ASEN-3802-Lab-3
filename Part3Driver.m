%% Part 3 Driver
clc; clear; close all;
% workflow
% hardcode inputs into thin airfoil theory
% m, c, p, AoA
% outputs
% cl, ZeroLiftAoA
% PLLT
% inputs
% b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r

b = 33 + 4/12; % 33' 4"
c_r = 5 + 4/12; % 5' 4"
c_t = 3 + 8.5/12; % 3' 8.5"
AoA = 4; % deg

% NACA code follows the following format
% m is the maximum camber and the first digit
% p is the location of maxium camber and the second digit
% t is the thickness and the third and fourth digit
% Ex: NACA 1234,
% m = 1% camber relative to chord length
% p = 20% is the location of maximum camber relative to chord length
% t = 34% is the maximum thickness relative to chord length

% NACA 2412 (root)
m_2412 = 2/100; p_2412 = 40/100; t_2412 = 12/100;
[cl_2412, aero_r] = ThinAirfoilTheory(c_r, m_2412, p_2412, AoA);

% NACA 0012 (tip)
m_0012 = 0/100; p_0012 = 0/100; t_0012 = 12/100;
[cl_0012, aero_t] = ThinAirfoilTheory(c_t, m_0012, p_0012, AoA);


% Define additional parameters for PLLT
a0_t = 2 * pi; % lift curve slope for tip airfoil
a0_r = 2 * pi; % lift curve slope for root airfoil
geo_t = 0; % deg
geo_r = 1; % deg
N = 1000; % number of fourier terms for "exact" solution
[e, c_L_exact, c_Di_exact] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);

% Generates an array of terms to test and initializes storage for the cL, 
% c_Di, and error values calculated with that number of Fourier terms
N_test = 1:1:200;
c_L_values = zeros(size(N_test));
c_Di_values = zeros(size(N_test));
c_L_error_values = zeros(size(N_test));
c_Di_error_values = zeros(size(N_test));

for i = 1:length(N_test)
    N_curr = N_test(i);

    % Calculates c_L and c_Di for the current number of Fourier terms
    [~, c_L_curr, c_Di_curr] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N_curr);

    c_L_values(i) = c_L_curr;
    c_Di_values(i) = c_Di_curr;

    % Calculates error as a positive percentage relative to our exact value
    c_L_error_values(i) = abs((c_L_values(i) - c_L_exact)/c_L_exact) * 100;
    c_Di_error_values(i) = abs((c_Di_values(i) - c_Di_exact)/c_Di_exact) * 100;
end

% Finds the first index that matches our condition for cL
c_L_N_index_10 = find(c_L_error_values <= 10, 1, 'first'); % 10 percent
c_L_N_index_1 = find(c_L_error_values <= 1, 1, 'first'); % 1 percent
c_L_N_index_tenth = find(c_L_error_values <= 0.1, 1, 'first'); % 0.1 percent

% Finds the first index that matches our condition for cDi
c_Di_N_index_10 = find(c_Di_error_values <= 10, 1, 'first'); % 10 percent
c_Di_N_index_1 = find(c_Di_error_values <= 1, 1, 'first'); % 1 percent
c_Di_N_index_tenth = find(c_Di_error_values <= 0.1, 1, 'first'); % 0.1 percent

% Locates the N value of said index
c_L_N_10percent = N_test(c_L_N_index_10); 
c_L_N_1percent = N_test(c_L_N_index_1); 
c_L_N_tenthpercent = N_test(c_L_N_index_tenth); 

% Locates the N value of said index
c_Di_N_10percent = N_test(c_Di_N_index_10); 
c_Di_N_1percent = N_test(c_Di_N_index_1); 
c_Di_N_tenthpercent = N_test(c_Di_N_index_tenth); 

% cL values at said index
c_L_10percent = c_L_values(c_L_N_10percent);
c_L_1percent = c_L_values(c_L_N_1percent);
c_L_tenthpercent = c_L_values(c_L_N_tenthpercent);

% cDi values at said index
c_Di_10percent = c_Di_values(c_Di_N_10percent);
c_Di_1percent = c_Di_values(c_Di_N_1percent);
c_Di_tenthpercent = c_Di_values(c_Di_N_tenthpercent);

% Error values for cL
c_L_error_10percent = c_L_error_values(c_L_N_10percent);
c_L_error_1percent = c_L_error_values(c_L_N_1percent);
c_L_error_tenthpercent = c_L_error_values(c_L_N_tenthpercent);

% Error values for cDi
c_Di_error_10percent = c_Di_error_values(c_Di_N_10percent);
c_Di_error_1percent = c_Di_error_values(c_Di_N_1percent);
c_Di_error_tenthpercent = c_Di_error_values(c_Di_N_tenthpercent);

% Print results to command window
fprintf('Exact Coefficient of Lift: %.8f\n', c_L_exact);
fprintf('Coefficient of Lift within 10 percent error: %.8f\n', c_L_10percent);
fprintf('N value for 10 percent error: %d\n', c_L_N_10percent);
fprintf('Coefficient of Lift within 1 percent error: %.8f\n', c_L_1percent);
fprintf('N value for 1 percent error: %d\n', c_L_N_1percent);
fprintf('Coefficient of Lift within 0.1 percent error: %.8f\n', c_L_tenthpercent);
fprintf('N value for 0.1 percent error: %d\n\n', c_L_N_tenthpercent);

fprintf('Exact Coefficient of Induced Drag: %.8f\n', c_Di_exact);
fprintf('Coefficient of Induced Drag within 10 percent error: %.8f\n', c_Di_10percent);
fprintf('N value for 10 percent error: %d\n', c_Di_N_10percent);
fprintf('Coefficient of Induced Drag within 1 percent error: %.8f\n', c_Di_1percent);
fprintf('N value for 1 percent error: %d\n', c_Di_N_1percent);
fprintf('Coefficient of Induced Drag within 0.1 percent error: %.8f\n', c_Di_tenthpercent);
fprintf('N value for 0.1 percent error: %d\n', c_Di_N_tenthpercent);