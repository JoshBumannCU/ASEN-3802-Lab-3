function [L, Di, D, LD] = LiftDragFunction(cd,Cl,Cdi,AoA_values,doPlot)

% givens
V = 100 * 1.688; % ft/s
h = 10000; % ft
rho = 0.001756; % slugs/ft^3
b = 33 + 4/12; %ft
cr = 5 + 4/12; %ft
ct = 3 + 8.5/12; %ft
S = b/2 * (cr + ct);

% Calculate L, Di, D and L/D
L = Cl .* 0.5 * rho * V^2 * S;
Di = 0.5 * rho * V^2 * S .* Cdi;

Cd = cd' + Cdi;
D =  0.5 * rho * V^2 * S .* Cd;

LD = L ./ D;

% Plot (deliverables 4&5)

if doPlot

figure()
hold on;
plot(AoA_values,Cd)
plot(AoA_values,cd)
plot(AoA_values,Cdi)
xlabel('Angle of Attack (deg)')
ylabel('Cd')
title('Cd vs AoA')
legend('Cd','cd','Cdi')

figure()
plot(AoA_values,LD)
title('L/D vs AoA')
xlabel('Angle of Attack (deg)')
ylabel('L/D')

end

end