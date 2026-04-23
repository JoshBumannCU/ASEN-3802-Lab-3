
function [] = Part3Plots(Cl,Cd_i,OddTerms,N1cdi,N10cdi,N01cdi,N1cl,N10cl,N01cl)

% OddTerms: number of odd terms used (n)
% Cl: coefficent of lift
% Cl_actual: the actual Cl value
% Cd_i: Coefficent of Induced Drag
% Cd_i_actual: the actual Cdi value
% N1cdi,N10cdi,N01cdi,N1cl,N10cl,N01cl = N values for 1, 10 and 0.1 % error for Cdi and cl

% Plots for 2
figure()
hold on;
plot(OddTerms, Cl)
xline(N10cl, 'r--')
xline(N1cl, 'b--')
xline(N01cl, 'g--')
title('Cl vs Number of Odd Terms')
ylabel('Cl')
xlabel('Number of Odd Terms')
legend('','10% Error','1% Error','0.1% Error','Location','northeast')

figure()
hold on;
plot(OddTerms,Cd_i)
xline(N10cdi, 'r--')
xline(N1cdi, 'b--')
xline(N01cdi, 'g--')
title('Cdi vs Number of Odd Terms')
ylabel('Cdi')
xlabel('Number of Odd Terms')
legend('','10% Error','1% Error','0.1% Error','Location','northeast')

% Plots for 3


end
