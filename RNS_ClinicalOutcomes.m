%
% Pearson correlation Fig 4C (RT = cumulative responsive therapy; ACC = weighted accuracy)
% 
%

% connect to SQL database and retrieve data (comment out whatever you're not running; code for both is in this file
conn = database('RNS','USERNAME','PASSWORD', 'Vendor', 'Microsoft SQL Server', 'Server', 'IP ADDRESS', 'AuthType', 'Server', 'PortNumber', 1433);
sqlQuery = 'select * from rns_dm.sm_rt_sz_tmp where sz_prcnt_change_from_previous > -100';
%sqlQuery = 'select * from rns_dm.sm_acc_sz_tmp where sz_prcnt_change_from_previous > -10';
curs = exec(conn,sqlQuery);
curs = fetch(curs);

% convert query outcome into MATLAB struct
sData = cell2struct(curs.Data, columnnames(curs, true)', 2);

% extract fields of interest from struct
pt_id = extractfield(sData, 'rns_deid_id');
rsp = extractfield(sData, 'responder_flg');
r = extractfield(sData, 'sz_prcnt_change_from_previous') * -1;
x = extractfield(sData, 'rt_per_day');
%x = extractfield(sData, 'eac');

% scatter plot values
plot(x,r,'o', 'color', [0, 118, 192] / 255);
% add regression
l=lsline;
set(l(1),'color',[163, 2, 52] / 255')
% calculate Pearson correlation
[rho,p]=corr(reshape(x,[],1),reshape(r,[],1));

% add labels
xlabel('Cumulative Therapy (\muC/cm^2)');
%xlabel('Weighted Accuracy (%)');
ylabel('Ictal-like Discharge Change (%)');

title('Cumulative Therapy versus ILD Change');
%title('Weighted Accuracy versus ILD Change');

set(gca, 'FontName', 'Calibri');