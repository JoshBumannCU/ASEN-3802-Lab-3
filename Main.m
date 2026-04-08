%% ASEN 3802 - Part 1 - Main
% Has user input a 4-digit NACA airfoil converts each digit to its appropriate value and plots the provided airfoil, adding a camber line if necessary.
%
% Collaborators: Josh Bumann, Clara Eide, Colton Firster, Lane Hollis
% Date: 4/7/2026

clc;
clear;
close all; 
 
N_surface = 50; % number of panels per surface
c = 1; % meters

% NACA code follows the following format
% m is the maximum camber and the first digit
% p is the location of maxium camber and the second digit
% t is the thickness and the third and fourth digit
% Ex: NACA 1234,
% m = 1% camber relative to chord length
% p = 20% is the location of maximum camber relative to chord length
% t = 34% is the maximum thickness relative to chord length

% NACA 0021
m_0021 = 0.00; p_0021 = 0.00; t_0021 = 0.21;
[x_b_0021, y_b_0021, x_0021, y_c_0021] = NACA_Airfoils(m_0021, p_0021, t_0021, c, N_surface);

% Plot the airfoil shape
figure;
plot(x_b_0021, y_b_0021, 'b-', 'LineWidth', 2);
hold on;
plot(x_b_0021, y_b_0021, 'r.', 'MarkerSize', 15);
if m_0021 > 0
    plot(x_0021, y_c_0021, 'g-', 'LineWidth', 2);
end
axis equal;
xlabel('x/c');
ylabel('y/c');
title('NACA 0021 Airfoil Shape');
grid on;
hold off;

% NACA 2421
m_2421 = 0.02; p_2421 = 0.40; t_2421 = 0.21;
[x_b_2421, y_b_2421, x_2421, y_c_2421] = NACA_Airfoils(m_2421, p_2421, t_2421, c, N_surface);

% Plot the airfoil shape
figure;
plot(x_b_2421, y_b_2421, 'b-', 'LineWidth', 2);
hold on;
plot(x_b_2421, y_b_2421, 'r.', 'MarkerSize', 15);
if m_2421 > 0
    plot(x_2421, y_c_2421, 'g-', 'LineWidth', 2);
end
axis equal;
xlabel('x/c');
ylabel('y/c');
title('NACA 2421 Airfoil Shape');
grid on;
hold off;


%% Task 2: Convergence Study on Number of Panels Required

% NACA 0012
m_0012 = 0.00; p_0012 = 0.00; t_0012 = 0.12;
[x_b_0012, y_b_0012, x_0012, y_c_0012] = NACA_Airfoils(m_0012, p_0012, t_0012, c, N_surface);

% The AoA of 12deg is hardcoded intentionally to compute cl for Task 2 Q1
cl_12 = Vortex_Panel(x_b_0012,y_b_0012,[],12); % Note: VINF is blank as it is unused in Vortex Panel
fprintf('Coefficient of Lift for NACA 0012 at an AoA of 12 degrees with 50 panels per surface: %.4f\n\n', cl_12)


N_exact = 1500; % 1500 panels per surface
[x_b_0012_exact, y_b_0012_exact, x_0012_exact, y_c_0012_exact] = NACA_Airfoils(m_0012, p_0012, t_0012, c, N_exact);
% Compute the coefficient of lift for the exact case with 1500 panels
cl_exact = Vortex_Panel(x_b_0012_exact, y_b_0012_exact, [], 12);
fprintf('Coefficient of Lift for NACA 0012 with 1500 panels per surface at an AoA of 12 degrees: %.8f\n', cl_exact);

% Generates an array of panels to test and initializes storage for the cl
% and error values calculated with that number of panels
N_test = 5:1:200;
cl_values = zeros(size(N_test));
error_values = zeros(size(N_test));

for i = 1:length(N_test)
    N_curr = N_test(i);

    % Generates the airfoil with the current number of panels
    [x_b_curr, y_b_curr, x_curr, y_c_curr] = NACA_Airfoils(m_0012,p_0012,t_0012,c,N_curr);

    % Calculates our current cl and stores it in an array
    cl_values(i) = Vortex_Panel(x_b_curr, y_b_curr, [], 12);

    % Calculates error as a positive percentage relative to our exact value
    error_values(i) = abs((cl_values(i) - cl_exact)/cl_exact) * 100;
end

% Finds the first index that matches our condition
N_index = find(error_values <= 1, 1, 'first');

N_1percent = N_test(N_index); % Locates the N value of said index
N_tot_1percent = 2*N_1percent; % Total panels includes upper and lower surface
cl_1percent = cl_values(N_index); % Cl at 1 percent error
error_1percent = error_values(N_index); % For redundancy

% Print results to command window
fprintf('Minimum number of panels per surface: %d\n', N_1percent);
fprintf('Minimum total number of panels: %d\n', N_tot_1percent);
fprintf('Coefficient of Lift for NACA 0012 within 1 percent error: %.8f\n', cl_1percent);
fprintf('Associated error as a percentage: %.8f%%\n', error_1percent);