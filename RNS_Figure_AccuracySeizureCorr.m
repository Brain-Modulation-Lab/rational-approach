conn = database('RNS','USERNAME','PASSWORD', 'Vendor', 'Microsoft SQL Server', 'Server', 'IP ADDRESS', 'AuthType', 'Server', 'PortNumber', 1433);
sqlQuery = 'select wa.*, es.electrographic_seizures_calc_total, es.electrographic_seizures_calc_per_wk from rns_dm.sm_pe_nshd_weighted_accuracies wa join rns_dm.sm_pe_nshd_weighted_electrographic_seizures es on wa.rns_deid_id = es.rns_deid_id and wa.programming_dt = es.programming_dt';
curs = exec(conn,sqlQuery);
curs = fetch(curs);

sData = cell2struct(curs.Data, columnnames(curs, true)', 2);

pt_id = extractfield(sData, 'rns_deid_id');
x = extractfield(sData, 'electrographic_seizures_calc_per_wk');
r = extractfield(sData, 'eac');

plot(x,r,'.', 'MarkerSize', 20);
lsline;

[rho,p]=corr(reshape(x,[],1),reshape(r,[],1));

xlabel('Electrographic Seizures per Week');
ylabel('Detector Accuracy');