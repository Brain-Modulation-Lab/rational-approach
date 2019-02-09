%
% Bland-Altman plots (Fig 4B) for each of the below weighted measurements
% These plots visualize the difference between weighted and non-weighted (standard) calculations for RNS data
%

% accuracy
% cumulative_therapy
% electrographic_seizure % note that this has been renamed to ictal-like discharge (ILD) hence the "manual override" of title
% latency
% sensitivity
% specificity
graph = 'electrographic_seizure';

% connect to SQL database
conn = database('RNS','USERNAME','PASSWORD', 'Vendor', 'Microsoft SQL Server', 'Server', 'IP ADDRESS', 'AuthType', 'Server', 'PortNumber', 1433);
sqlQuery = strcat('select * from rns_dm.sm_bland_altman_plots where msrmnt_nm = ''', graph, '''');
curs = exec(conn,sqlQuery);
curs = fetch(curs);

% convert SQL query to MATLAB struct with column names
sData = cell2struct(curs.Data, columnnames(curs, true)', 2);

% extract the values of interest from the struct
bias = curs.Data(1, 6);
ci95_top = curs.Data(1, 8);
ci95_bottom = curs.Data(1, 9);
sd = curs.Data(1, 7);

% manually construct Bland-Altman using scatter and reference lines
D = extractfield(sData, 'msrmnts_difference');
M = extractfield(sData, 'msrmnts_mean');
scatter(M, D, [], [0,118,192] / 255); 
hline(1) = refline([0 bias{1}]);
hline(1).Color = 'black';
hline(1).LineStyle = '-';
hline(2) = refline([0 ci95_top{1}]);
hline(2).Color = [163, 2, 52] / 255;
hline(2).LineStyle = '--';
hline(3) = refline([0 ci95_bottom{1}]);
hline(3).Color = [163, 2, 52] / 255;
hline(3).LineStyle = '--';
xlabel('Mean ($\frac{WA + NWA}{2}$)','Interpreter','latex');
ylabel('Difference (${WA - NWA}$)','Interpreter','latex');
%title(strrep(graph, '_', ' '));
title('Ictal-like Discharge');

% each plot has a different Limit of Agreement (LOA) and bias (these are reference lines) which are manually coded, based on values already calculated in the SQL pre-processing

% accuracy
%text(0.9,ci95_top{1}-0.015,strcat('LOA = ±',num2str(round(sd{1}, 2))));
%text(0.9,bias{1}-0.015,strcat('Bias =', {' '},num2str(round(bias{1}, 2))));

% cumulative_therapy
%text(710000,ci95_top{1}-45000,strcat('LOA = ±',num2str(round(sd{1}, 2))));
%text(710000,bias{1}-45000,strcat('Bias =', {' '},num2str(round(bias{1}, 2))));

% electrographic_seizure
text(4400,ci95_top{1}-750,strcat('LOA = ±',num2str(round(sd{1}, 2))));
text(4400,bias{1}-750,strcat('Bias =', {' '},num2str(round(bias{1}, 2))));

% latency
%text(4.6,ci95_top{1}+0.3,strcat('LOA = ±',num2str(round(sd{1}, 2))));
%text(4.6,bias{1}-0.3,strcat('Bias =', {' '},num2str(round(bias{1}, 2))));

% sensitivity
%text(0.88,ci95_top{1}-0.06,strcat('LOA = ±',num2str(round(sd{1}, 2))));
%text(0.88,bias{1}+0.06,strcat('Bias =', {' '},num2str(round(bias{1}, 2))));

% specificity
%text(0.9,ci95_top{1}-0.02,strcat('LOA = ±',num2str(round(sd{1}, 2))));
%text(0.9,bias{1}-0.02,strcat('Bias =', {' '},num2str(round(bias{1}, 2))));

hFig = figure(1);
set(hFig, 'Position', [500 500 500 300])
set(gca, 'FontName', 'Calibri');