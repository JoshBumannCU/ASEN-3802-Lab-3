clc
clear
close all
%% Lab 3 Part 2

% Set variables for PLLT function
a0_t = 2*pi; % cross-section lift slope at tip (/rad)
a0_r = 2*pi; % cross-section lift slope at root (/rad)
aero_t = 0; % zero lift AoA at tip
aero_r = 0; % zero lift AoA at root
geo_t = 1; % geo AoA at tip
geo_r = 1; % geo AoA at root
AR = [4,6,8,10]; % Aspect Ratios displayed in Anderson 5.20
L = length(AR); % Length of AR vector, set for processing efficiency
N = 50; % # of prescribed locations/odd terms in expanded circulation series (50 used in Anderson)
P = 1000; % # of plot points
taper_ratio = 0:1/(P-1):1; % equally spaced taper ratio vector of length P from 0 to 1
c_r = 1; % root chord
c_t = c_r * taper_ratio; % tip chord at every taper ratio

% Preallocate output matrices for FOR loop efficiency
e = zeros(L,P); % Oswalds efficiency
c_L = zeros(L, P); % coeff of lift
c_Di = zeros(L, P); % coeff of induced drag
D_i_fact = zeros(L, P); % induced drag factor

% Set b and run PLLT to find Induced Drag Factor via FOR loop
for i = 1:L % run for each AR
    b = AR(i) * (c_r + c_t)/2; % calculate span from AR, c_r, and c_t
    for j = 1:P % run for each plot point
        [e(i,j),c_L(i,j),c_Di(i,j)] = PLLT(b(j),a0_t,a0_r,c_t(j),c_r,aero_t,aero_r,geo_t,geo_r,N); % call PLLT
        D_i_fact(i,j) = (1/e(i,j))-1; % calculate induced drag factor from e
    end
end

% Plot Results to Reflect 5.20
figure
hold on
for i = 1:L % run for each value of AR
    plot(taper_ratio, D_i_fact(i,:),"LineWidth",1); % plot induced drag factor as a funct. of taper ratio
end
xlabel('Taper Ratio c_t/c_r') % x axis label
ylabel('\delta') % y axis label
title('Induced Drag Factor as a Function of Taper Ratio for Aspect Ratios 4, 6, 8, & 10') % title
legend('AR = 4','AR = 6','AR = 8','AR = 10', 'Location', 'northeast') % legend
grid on % grid
hold off
