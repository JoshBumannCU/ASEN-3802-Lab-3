clc;
clear;
close all;

drag_as_funct_of_cl = readmatrix("12_24_drag.xlsx");

% Drag polar file 
drag_0012 = [drag_as_funct_of_cl(:,1), drag_as_funct_of_cl(:,2)];  % [CL, Cd]
drag_2412_raw = [drag_as_funct_of_cl(:,3), drag_as_funct_of_cl(:,4)]; % [CL, Cd]

% Remove rows with any NaN
nanRows = any(isnan(drag_2412_raw), 2);
drag_2412_raw(nanRows, :) = [];


% Read digitized data
cl_as_funct_of_AoA_0012 = readmatrix("NACA_0012_digitized.xlsx");
cl_as_funct_of_AoA_2412 = readmatrix("NACA_2412_digitized.xlsx");

% NACA 0012
cl_0012 = drag_0012(:,1);
cd_0012 = drag_0012(:,2);
[cl_0012_u, ia1, ~] = unique(cl_0012, 'stable');
cd_0012_u = cd_0012(ia1);

% NACA 2412
cl_2412 = drag_2412_raw(:,1);
cd_2412 = drag_2412_raw(:,2);
[cl_2412_u, ia2, ~] = unique(cl_2412, 'stable');
cd_2412_u = cd_2412(ia2);

% Extract AoA and CL 
aoa_0012 = cl_as_funct_of_AoA_0012(:,1);
CL_vs_AoA_0012 = cl_as_funct_of_AoA_0012(:,2);

aoa_2412 = cl_as_funct_of_AoA_2412(:,1);
CL_vs_AoA_2412 = cl_as_funct_of_AoA_2412(:,2);

% common AoA range that covers both datasets
minAoA = min([aoa_0012(:); aoa_2412(:)]);
maxAoA = max([aoa_0012(:); aoa_2412(:)]);

% Choose AoA resolution
dAoA1 = median(diff(unique(aoa_0012)));
dAoA2 = median(diff(unique(aoa_2412)));
dAoA = min(max(min(dAoA1, dAoA2), 0.5), max(dAoA1, dAoA2)); % prefer finer of the two, but at least 0.5 deg
common_aoa = (minAoA : dAoA : maxAoA)';

% Replace NaNs
valid1 = isfinite(aoa_0012) & isfinite(CL_vs_AoA_0012);
% Clean and sort for interp1
[aoa1_s, idx1] = sort(aoa_0012(valid1));
cl1_s = CL_vs_AoA_0012(valid1);
cl1_s = cl1_s(idx1);

% extend using nearest valid value to avoid NaNs 
CL_on_common_0012 = interp1(aoa1_s, cl1_s, common_aoa, 'linear', 'extrap');
% Replace nonfinite results
if any(~isfinite(CL_on_common_0012))
    finiteIdx = find(isfinite(CL_on_common_0012));
    CL_on_common_0012(~isfinite(CL_on_common_0012)) = interp1(common_aoa(finiteIdx), CL_on_common_0012(finiteIdx), common_aoa(~isfinite(CL_on_common_0012)), 'nearest', 'extrap');
end

valid2 = isfinite(aoa_2412) & isfinite(CL_vs_AoA_2412);
[aoa2_s, idx2] = sort(aoa_2412(valid2));
cl2_s = CL_vs_AoA_2412(valid2);
cl2_s = cl2_s(idx2);

CL_on_common_2412 = interp1(aoa2_s, cl2_s, common_aoa, 'linear', 'extrap');
if any(~isfinite(CL_on_common_2412))
    finiteIdx = find(isfinite(CL_on_common_2412));
    CL_on_common_2412(~isfinite(CL_on_common_2412)) = interp1(common_aoa(finiteIdx), CL_on_common_2412(finiteIdx), common_aoa(~isfinite(CL_on_common_2412)), 'nearest', 'extrap');
end

% Interpolate Cd on common AoA grid
cd_vs_aoa_0012 = interp1(cl_0012_u, cd_0012_u, CL_on_common_0012, 'linear', 'extrap');
cd_vs_aoa_2412 = interp1(cl_2412_u, cd_2412_u, CL_on_common_2412, 'linear', 'extrap');

% Assemble output matrices
cd_as_funct_of_AoA_0012 = [common_aoa, cd_vs_aoa_0012];
cd_as_funct_of_AoA_2412 = [common_aoa, cd_vs_aoa_2412];

% Average matrix
cd_avg = [common_aoa,(cd_vs_aoa_0012+cd_vs_aoa_2412)/2];



figure;
plot(cd_as_funct_of_AoA_0012(:,1), cd_as_funct_of_AoA_0012(:,2), '-o', 'DisplayName','NACA 0012');
hold on;
plot(cd_as_funct_of_AoA_2412(:,1), cd_as_funct_of_AoA_2412(:,2), '-s', 'DisplayName','NACA 2412');
plot(cd_avg(:,1), cd_avg(:,2), '-o', 'DisplayName', 'Average');
hold off;
grid on;
xlabel('Angle of Attack (deg)');
ylabel('C_d');
title('Drag Coefficient vs Angle of Attack');
legend('Location','best');
% Prepare table and write to Excel with three sheets
outFile = "cd_vs_aoa_export.xlsx";

% Create tables with appropriate column names
T0012 = table(cd_as_funct_of_AoA_0012(:,1), cd_as_funct_of_AoA_0012(:,2), 'VariableNames', {'AoA_deg', 'Cd'});
T2412 = table(cd_as_funct_of_AoA_2412(:,1), cd_as_funct_of_AoA_2412(:,2), 'VariableNames', {'AoA_deg', 'Cd'});
Tavg  = table(cd_avg(:,1), cd_avg(:,2), 'VariableNames', {'AoA_deg', 'Cd'});

% Write each table to its own sheet 
writetable(T0012, outFile, 'Sheet', 'NACA_0012', 'WriteMode', 'overwrite');
writetable(T2412, outFile, 'Sheet', 'NACA_2412', 'WriteMode', 'append');
writetable(Tavg,  outFile, 'Sheet', 'Average',   'WriteMode', 'append');
