-- '2017-11-12 12:46:30.000' is the cutoff!
--select max(max_reviewed_files_dts) from rns_dm.sm_programming_epochs

/*
The total number of therapies in a given 24 hour window are also limited by a programmable amount (1,000–4,000 at UPMC).
*/

select min(therapy_limit_per_day), max(therapy_limit_per_day)
from rns_ods.programming_epoch_responsive_therapies pert
join rns_dm.programming_epochs pe
	on pe.programming_epoch_id = pert.programming_epoch_id
join rns_dm.sm_programming_epochs spe
	on pe.programming_dts = spe.programming_dts
		and pe.rns_deid_id = spe.rns_deid_id

/*
Saturation events occur when neural signal amplitude exceeds a programmable threshold of a recording channel (1–16 at UPMC).
*/

select min(d_int), max(d_int)
from
(
	select sat_detector1, cast(substring(sat_detector1, 0, charindex('/', sat_detector1)) as int) as d_int
	from rns_dm.programming_epoch_summaries pes
	join rns_dm.sm_programming_epochs spe
		on pes.programming_dts = spe.programming_dts
	union all
	select sat_detector2, cast(substring(sat_detector2, charindex('/', sat_detector1) + 1, len(sat_detector2) - charindex('/', sat_detector1)) as int) as d_int
	from rns_dm.programming_epoch_summaries pes
	join rns_dm.sm_programming_epochs spe
		on pes.programming_dts = spe.programming_dts
			and pes.rns_deid_id = spe.rns_deid_id
) d

/*
Detection events that last less than a configurable amount of time (15–30s at UPMC) are called episodes and are considered to be aberrant interictal activity or subclinical discharges.
*/

select min(cast(replace(replace(long_episode_threshold, '(>', ''), 's)', '') as int)), max(cast(replace(replace(long_episode_threshold, '(>', ''), 's)', '') as int))
from rns_dm.programming_epoch_summaries pes
	join rns_dm.sm_programming_epochs spe
		on pes.programming_dts = spe.programming_dts
			and pes.rns_deid_id = spe.rns_deid_id

/*
See logging figure calcs for the "at UPMC" queries
*/

/*
average duration of 21.5 months (±10.4 months) 
*/

select avg(cast(datediff(month, implant_dt, '2017-11-12 12:46:30.000') as decimal(10,2))) as average,
	stdev(datediff(month, implant_dt, '2017-11-12 12:46:30.000')) as std_dev  
from rns_abstractions_ods.implants

/*
average age at implantation was 35.6 years (±11.9 years)
*/

select avg(cast(datediff(year, birth_dt, implant_dt) as decimal(10,2))) as average,
	stdev(datediff(year, birth_dt, implant_dt)) as std_dev  
from rns_abstractions_ods.implants

/*
mean history of 18.5 years (±10.4 years) of seizures before intervention 
*/

select avg(cast(datediff(year, epilepsy_dx_dt, implant_dt) as decimal(10,2))) as average,
	stdev(datediff(year, epilepsy_dx_dt, implant_dt)) as std_dev  
from rns_abstractions_ods.implants

/*
Five out of 12 patients had epilepsy of structural etiology
*/

select count(*)
from rns_abstractions_ods.implants
where epilepsy_etiology_ilae = 'structural'

/*
mean seizure frequency was 59.5 (±109.7) per month, with a mean of 10.1 (±17.1) per month for disabling seizures prior to RNS implantation 
*/

select
	avg(s.seizure1_freq_per_month + s.seizure2_freq_per_month + s.seizure3_freq_per_month + s.seizure4_freq_per_month + s.seizure5_freq_per_month) as avg_overall_seizure_freq_per_month,
	stdev(s.seizure1_freq_per_month + s.seizure2_freq_per_month + s.seizure3_freq_per_month + s.seizure4_freq_per_month + s.seizure5_freq_per_month) as st_dev_overall_seizure_freq_per_month
from rns_dm.seizure_surveys_normalized s
join rns_abstractions_ods.implants i
	on s.rns_deid_id = i.rns_deid_id
where s.survey_dt <= i.implant_dt
	and s.earliest_survey_rnk = 1

--

select
	avg(
		case when ss.seizure_type1_loss_of_consciousness = 1 then s.seizure1_freq_per_month else 0.00 end + 
		case when ss.seizure_type2_loss_of_consciousness = 1 then s.seizure2_freq_per_month else 0.00 end + 
		case when ss.seizure_type3_loss_of_consciousness = 1 then s.seizure3_freq_per_month else 0.00 end + 
		case when ss.seizure_type4_loss_of_consciousness = 1 then s.seizure4_freq_per_month else 0.00 end +  
		case when ss.seizure_type5_loss_of_consciousness = 1 then s.seizure5_freq_per_month else 0.00 end
	) as avg_disabling_seizure_freq_per_month,
	stdev(
		case when ss.seizure_type1_loss_of_consciousness = 1 then s.seizure1_freq_per_month else 0.00 end + 
		case when ss.seizure_type2_loss_of_consciousness = 1 then s.seizure2_freq_per_month else 0.00 end + 
		case when ss.seizure_type3_loss_of_consciousness = 1 then s.seizure3_freq_per_month else 0.00 end + 
		case when ss.seizure_type4_loss_of_consciousness = 1 then s.seizure4_freq_per_month else 0.00 end +  
		case when ss.seizure_type5_loss_of_consciousness = 1 then s.seizure5_freq_per_month else 0.00 end
	) as st_dev_disabling_seizure_freq_per_month
from rns_dm.seizure_surveys_normalized s
join rns_ods.seizure_surveys ss
	on ss.rns_deid_id = s.rns_deid_id
		and ss.survey_dt = s.survey_dt
join rns_abstractions_ods.implants i
	on s.rns_deid_id = i.rns_deid_id
where s.survey_dt <= i.implant_dt
	and s.earliest_survey_rnk = 1

/*
The mean patient reported seizure frequency was 59.5 ± 109.7 per month and 10.1 ± 17.1 per month for disabling seizures, prior to RNS implantation. The mean reduction in patient reported seizure frequency was 40.1% ± 50.0% (absolute reduction of 10.9 ± 18.3 seizures per month), with a 246.3 ± 631.1 second reduction in duration and 31.6% ± 44.6% reduction in severity score (absolute reduction of 1.9 ± 2.3 points) 
*/

select
	avg((pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) - (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month)) as avg_abs_freq_reduction,
	stdev((pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) - (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month)) as st_dev_abs_freq_reduction,
	avg(
		case		
			when not (pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) + (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month) = 0
			then ((pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) - (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month)) / ((pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) + (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month))
			else 0.00
		end
	) * 100.00 as avg_prcnt_freq_reduction,
	stdev(
		case		
			when not (pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) + (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month) = 0
			then ((pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) - (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month)) / ((pre.seizure1_freq_per_month + pre.seizure2_freq_per_month + pre.seizure3_freq_per_month + pre.seizure4_freq_per_month + pre.seizure5_freq_per_month) + (post.seizure1_freq_per_month + post.seizure2_freq_per_month + post.seizure3_freq_per_month + post.seizure4_freq_per_month + post.seizure5_freq_per_month))
			else 0.00
		end
	) * 100.00 as std_dev_prcnt_freq_reduction,
	--
	avg((pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) - (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds)) as avg_abs_duration_reduction,
	stdev((pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) - (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds)) as st_dev_abs_duration_reduction,
	avg(
		case 
			when not (pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) + (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds) = 0
			then ((pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) - (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds)) / ((pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) + (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds))
			else 0.00
		end
	) * 100.00 as avg_prcnt_duration_reduction,
	stdev(
		case 
			when not (pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) + (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds) = 0
			then ((pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) - (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds)) / ((pre.seizure1_duration_seconds + pre.seizure2_duration_seconds + pre.seizure3_duration_seconds + pre.seizure4_duration_seconds + pre.seizure5_duration_seconds) + (post.seizure1_duration_seconds + post.seizure2_duration_seconds + post.seizure3_duration_seconds + post.seizure4_duration_seconds + post.seizure5_duration_seconds))
			else 0.00
		end
	) * 100.00 as std_dev_prcnt_duration_reduction,
	--
	avg((pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) - (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity)) as avg_abs_severity_reduction,
	stdev((pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) - (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity)) as st_dev_abs_severity_reduction,
	avg(
		case
			when not (pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) + (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity) = 0
			then ((pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) - (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity)) / ((pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) + (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity))
			else 0.00
		end
	) * 100.00 as avg_prcnt_severity_reduction,
	stdev(
		case
			when not (pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) + (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity) = 0
			then ((pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) - (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity)) / ((pre.seizure_type1_severity + pre.seizure_type2_severity + pre.seizure_type3_severity + pre.seizure_type4_severity + pre.seizure_type5_severity) + (post.seizure_type1_severity + post.seizure_type2_severity + post.seizure_type3_severity + post.seizure_type4_severity + post.seizure_type5_severity))
			else 0.00
		end	
	) * 100.00 as std_dev_prcnt_severity_reduction
from 
(
	select s.*,
		coalesce(cast(ss.seizure_type1_severity as decimal(10,2)), 0.00) as seizure_type1_severity,
		coalesce(cast(ss.seizure_type2_severity as decimal(10,2)), 0.00) as seizure_type2_severity,
		coalesce(cast(ss.seizure_type3_severity as decimal(10,2)), 0.00) as seizure_type3_severity,
		coalesce(cast(ss.seizure_type4_severity as decimal(10,2)), 0.00) as seizure_type4_severity,
		coalesce(cast(ss.seizure_type5_severity as decimal(10,2)), 0.00) as seizure_type5_severity
	from rns_dm.seizure_surveys_normalized s
	join rns_ods.seizure_surveys ss
		on ss.rns_deid_id = s.rns_deid_id
			and ss.survey_dt = s.survey_dt
	join rns_abstractions_ods.implants i
		on s.rns_deid_id = i.rns_deid_id
	where s.survey_dt <= i.implant_dt
		and s.earliest_survey_rnk = 1
) pre
left join
(
	select s.*,
		coalesce(cast(ss.seizure_type1_severity as decimal(10,2)), 0.00) as seizure_type1_severity,
		coalesce(cast(ss.seizure_type2_severity as decimal(10,2)), 0.00) as seizure_type2_severity,
		coalesce(cast(ss.seizure_type3_severity as decimal(10,2)), 0.00) as seizure_type3_severity,
		coalesce(cast(ss.seizure_type4_severity as decimal(10,2)), 0.00) as seizure_type4_severity,
		coalesce(cast(ss.seizure_type5_severity as decimal(10,2)), 0.00) as seizure_type5_severity
	from rns_dm.seizure_surveys_normalized s
	join rns_ods.seizure_surveys ss
		on ss.rns_deid_id = s.rns_deid_id
			and ss.survey_dt = s.survey_dt
	join rns_abstractions_ods.implants i
		on s.rns_deid_id = i.rns_deid_id
	where s.survey_dt > i.implant_dt
		and s.latest_survey_rnk = 1
) post
	on pre.rns_deid_id = post.rns_deid_id


/*
The mean percentage of triggered ECoG recording files uploaded to the PDMS per interrogation out of all pattern detection, saturation, and magnet swipe events was 1.6% (±10.0%).
USE THE FIGURE CALC INSTEAD

select 
	avg(case when total_possible_ecog_files_per_interrogation = 0 then 0.00 else total_actual_ecog_files_per_interrogation / total_possible_ecog_files_per_interrogation end) * 100 as avg_files_available_prcnt,
	stdev(case when total_possible_ecog_files_per_interrogation = 0 then 0.00 else total_actual_ecog_files_per_interrogation / total_possible_ecog_files_per_interrogation end) * 100 as stdev_files_available_prcnt
from 
(
	select
		al.rns_deid_id,
		al.interrogation_dts,
		cast(sum(al.saturation_outside_episode + al.detections_pattern_a + al.detections_pattern_b) as decimal(10,2)) as total_possible_ecog_files_per_interrogation,
		cast(sum(ecog.total_ecog_files_per_interrogation) as decimal(10,2)) as total_actual_ecog_files_per_interrogation
	from rns_dm.activity_logs al
	join rns_dm.sm_programming_epochs pe
		on al.interrogation_dts >= pe.programming_dts and al.interrogation_dts < coalesce(pe.next_programming_dts, pe.max_reviewed_files_dts)
			and al.rns_deid_id = pe.rns_deid_id
	outer apply
	(
		select count(*) as total_ecog_files_per_interrogation
		from rns_ods.files f
		join rns_ods.pdms_file_dates pfd
			on f.name = pfd.file_nm
		join rns_dm.np_parameters p
			on p.[dat_file_id] = f.[file_id]
		where f.extension = '.dat'
			and pfd.file_dts > al.last_interrogation_dts and pfd.file_dts <= al.interrogation_dts
			and p.rns_deid_id = al.rns_deid_id
			and not p.trigger_reason = 'ECOG_SCHEDULED_CATEGORY'
	) ecog
	group by 
		al.rns_deid_id,
		al.interrogation_dts
)x*/

/*
The mean number of hours between interrogations was 30.3 (±64.7)
*/

select
	avg(cast(datediff(hour, al.last_interrogation_dts, al.interrogation_dts) as decimal(10,2))) as avg_hours_between_interrogations,
	stdev(cast(datediff(hour, al.last_interrogation_dts, al.interrogation_dts) as decimal(10,2))) as stdev_hours_between_interrogations
from rns_dm.activity_logs al
	join rns_dm.sm_programming_epochs pe
		on al.interrogation_dts >= pe.programming_dts and al.interrogation_dts < coalesce(pe.next_programming_dts, pe.max_reviewed_files_dts)
			and al.rns_deid_id = pe.rns_deid_id
where not al.last_interrogation_dts is null

/*
Then mean percentage of triggered events for which event list logging was retained (and not lost to device storage capacity constraints; not including saturation, magnet swipe, etc.) was 72.0% ((±32.2%).
USE THE FIGURE CALC INSTEAD

select 
	avg(case when total_possible_events_per_interrogation = 0 then 0.00 else total_actual_events_per_interrogation / total_possible_events_per_interrogation end) * 100 as avg_events_available_prcnt,
	stdev(case when total_possible_events_per_interrogation = 0 then 0.00 else total_actual_events_per_interrogation / total_possible_events_per_interrogation end) * 100 as stdev_events_available_prcnt
from 
(
	select
		al.rns_deid_id,
		al.interrogation_dts,
		cast(sum(al.detections_pattern_a + al.detections_pattern_b) as decimal(10,2)) as total_possible_events_per_interrogation,
		cast(sum(elist.total_events_listed_per_interrogation) as decimal(10,2)) as total_actual_events_per_interrogation
	from rns_dm.activity_logs al
	join rns_dm.sm_programming_epochs pe
		on al.interrogation_dts >= pe.programming_dts and al.interrogation_dts < coalesce(pe.next_programming_dts, pe.max_reviewed_files_dts)
			and al.rns_deid_id = pe.rns_deid_id
	outer apply
	(
		select count(*) as total_events_listed_per_interrogation
		from rns_dm.event_lists el
		where el.interrogation_dts = al.interrogation_dts
			and el.rns_deid_id = al.rns_deid_id
			and el.event_type like 'Pattern%'
	) elist
	group by 
		al.rns_deid_id,
		al.interrogation_dts
)x*/

/*
The weighted mean accuracy per programming epochs (Figure 8),
WA, NWA, SEN, SPE
This is accuracy as opposed to latency
**add marking for what was changed (at least at detector and stim level)?
**will also need to add med change markings here (but of course need to get them first...)
*/

select 
	avg(eac) as avg_eac,
	stdev(eac) as stdev_eac,
	avg(ecog_accuracy) as avg_ecog_accuracy,
	stdev(ecog_accuracy) as stdev_ecog_accuracy,
	avg(sen) as avg_sen,
	stdev(sen) as stdev_sen,
	avg(spe) as avg_spe,
	stdev(spe) as stdev_spe
from rns_dm.sm_pe_nshd_weighted_accuracies

/*
the weight mean number of electrographic seizures was 833.4 1,697.3 (Figure 8).
Calculation for reporting electrographic seizures, by using the percent of confirmed LE's per PE to extrapolate the number of true electrographic seizures
*/

select
	avg(electrographic_seizures_calc_per_wk) as avg_electrographic_seizures_calc_per_wk,
	stdev(electrographic_seizures_calc_per_wk) as stdev_electrographic_seizures_calc_per_wk
from rns_dm.sm_pe_nshd_weighted_electrographic_seizures

/*
The weighted mean latency per programming epoch was 1.89s ± 1.48s (Table 4).
*/

select
	avg(weighted_latency_s) as avg_weighted_latency_s,
	stdev(weighted_latency_s) as stdev_weighted_latency_s
from rns_dm.sm_pe_nshd_weighted_latencies

/*
mean of 39.5 ± 43.6 events per hour per patient.
*/

select 
	avg(cast(ndh.episodes_cnt + ndh.magnets_cnt + ndh.saturations_cnt as decimal(10,2))) / 24.00 as mean_events_per_hour,
	stdev(cast(ndh.episodes_cnt + ndh.magnets_cnt + ndh.saturations_cnt as decimal(10,2))) / 24.00 as stdev_events_per_hour
from rns_ods.neurostimulator_daily_histories ndh
join rns_dm.sm_programming_epochs pe
	on ndh.neurostimulator_daily_dt >= pe.programming_dts and ndh.neurostimulator_daily_dt < coalesce(pe.next_programming_dts, pe.max_reviewed_files_dts)
where not coalesce(ndh.missing_histogram_data_flg, 0) = 1

/*
The mean number of stimulations per episode per patient was calculated to be 0.8 ± 0.4, and 
*/

select 
	avg(case when ndh.episodes_cnt = 0 then 0.00 else cast(ndh.therapies_cnt as decimal(10,2)) / cast(ndh.episodes_cnt as decimal(10,2)) end) as mean_stims_per_episode,
	stdev(case when ndh.episodes_cnt = 0 then 0.00 else cast(ndh.therapies_cnt as decimal(10,2)) / cast(ndh.episodes_cnt as decimal(10,2)) end)  as stdev_stims_per_episode
from rns_ods.neurostimulator_daily_histories ndh
join rns_dm.sm_programming_epochs pe
	on ndh.neurostimulator_daily_dt >= pe.programming_dts and ndh.neurostimulator_daily_dt < coalesce(pe.next_programming_dts, pe.max_reviewed_files_dts)
where not coalesce(ndh.missing_histogram_data_flg, 0) = 1

/*
the daily therapy limit (mean per programming epoch = 2,039.2 +- 823.7; 1,000–4,000) was calculated to be reached for 5.6% of days. 
*/

select
	avg(cast(therapy_limit_per_day as decimal(10,2))) as mean_therapy_limit_per_day_pe,
	stdev(cast(therapy_limit_per_day as decimal(10,2))) as stdev_therapy_limit_per_day_pe,
	min(therapy_limit_per_day) as min_therapy_limit_per_day,
	max(therapy_limit_per_day) as max_therapy_limit_per_day
from rns_ods.programming_epoch_responsive_therapies pert
join rns_ods.programming_epochs pe
	on pe.programming_epoch_id = pert.programming_epoch_id
join rns_dm.sm_programming_epochs spe
	on pe.programming_dts = spe.programming_dts

--

select
	avg(days_limit_hits_prcnt) as avg_days_limit_hits_prcnt,
	stdev(days_limit_hits_prcnt) as stdev_days_limit_hits_prcnt
from
(
	select
		rns_deid_id,
		cast(sum(limit_hit) as decimal(10,2)) / cast(count(*) as decimal(10,2)) as days_limit_hits_prcnt
	from
	(
		select
			spe.rns_deid_id,
			case when ndh.therapies_cnt > mt.max_therapy_limit_per_day then 1 else 0 end as limit_hit
		from rns_dm.sm_programming_epochs spe
		join rns_ods.neurostimulator_daily_histories ndh
			on ndh.rns_deid_id = spe.rns_deid_id
				and ndh.neurostimulator_daily_dt >= spe.programming_dts and ndh.neurostimulator_daily_dt < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
		join
		(
			select
				pe.rns_deid_id,
				pe.programming_dts,
				avg(cast(therapy_limit_per_day as decimal(10,2))) as mean_therapy_limit_per_day_pe,
				stdev(cast(therapy_limit_per_day as decimal(10,2))) as stdev_therapy_limit_per_day_pe,
				min(therapy_limit_per_day) as min_therapy_limit_per_day,
				max(therapy_limit_per_day) as max_therapy_limit_per_day
			from rns_dm.programming_epochs pe
			join rns_ods.programming_epoch_responsive_therapies pert
				on pe.programming_epoch_id = pert.programming_epoch_id
			where pert.responsive_therapies = 'enabled'
			group by 
				pe.rns_deid_id,
				pe.programming_dts
		) mt
			on ndh.rns_deid_id = mt.rns_deid_id
				and mt.programming_dts >= spe.programming_dts and mt.programming_dts < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
	) x
	group by rns_deid_id
) y

/*
Meant time to follow-up for PROs
*/

select
	avg(weeks_to_fu) as avg_weeks_to_fu,
	stdev(weeks_to_fu) as stdev_weeks_to_fu
from
(
select
	rns_deid_id,
	cast(datediff(month, min(survey_dt), max(survey_dt)) as decimal(10,2)) as weeks_to_fu
from rns_ods.seizure_surveys
group by rns_deid_id
)x


select
	avg(weeks_to_fu) / 4 as avg_weeks_to_fu,
	stdev(weeks_to_fu) / 4 as stdev_weeks_to_fu
from
(
select
	rns_deid_id,
	cast(datediff(day, min(survey_dt), max(survey_dt)) / 7.0 as decimal(10,2)) as weeks_to_fu
from rns_ods.seizure_surveys
group by rns_deid_id
)x

/*
The mean patient compliance to using the RNS magnet to mark a seizure event was X, and compliance with maintaining a seizure diary was 
*/

select
	avg(cast(magnet_swipe_compliance_int as ) as magnet_swipe_compliance,
	stdev(magnet_swipe_compliance_int) as magnet_swipe_compliance,
	avg(seizure_diary_compliance_int) as seizure_diary_compliance,
	stdev(seizure_diary_compliance_int) as seizure_diary_compliance
from rns_ods.seizure_surveys


/*
The mean number of programming events was 3.7 per year per patient +/- 1.2. 
*/

select
	avg(avg_pe_per_year) as avg_pe_per_year,
	stdev(avg_pe_per_year) as stdev_pe_per_year
from
(
	select 
		pe.rns_deid_id,
		cast(count(pe.programming_dts) as decimal(10,2)) / cast(datediff(month, i.implant_dt, '2017-11-15 00:17:45.000') as decimal(10,2)) * 12.00 as avg_pe_per_year
	from rns_dm.sm_programming_epochs pe
	join rns_abstractions_ods.implants i
		on pe.rns_deid_id = i.rns_deid_id
	group by
		pe.rns_deid_id,
		i.implant_dt
) x

/*
The mean time to enabled neural stimulation therapy was 45.9 days (+/- 25.4)
*/

select
	avg(days_to_therapy_enabled) as avg_days_to_therapy_enabled,
	stdev(days_to_therapy_enabled) as stdev_days_to_therapy_enabled
from
(
	select
		i.rns_deid_id,
		cast(datediff(day, i.implant_dt, min(pe.programming_dts)) as decimal(10,2)) as days_to_therapy_enabled
	from rns_abstractions_ods.implants i
	join rns_dm.sm_programming_epochs spe
		on spe.rns_deid_id = i.rns_deid_id
	join rns_dm.programming_epochs pe
		on spe.programming_dts = pe.programming_dts
			and spe.rns_deid_id = pe.rns_deid_id
	join rns_ods.programming_epoch_responsive_therapies pert
		on pe.programming_epoch_id = pert.programming_epoch_id
	where pert.responsive_therapies = 'enabled'
	group by
		i.rns_deid_id,
		i.implant_dt
) x


/*
resulting in a mean cumulative therapy of 619,622.0 ± 390,446.8 μC/cm2 at 12 months 
wrong: of 1,920,874.7 ± 1,256,022.7 μC/cm2 at 12 months 
-- this needs to be extrapolated as well... and is pretty complicated...
*/

--this query shows that everyone has the same settings for all bursts, which makes the calculation much less complicated than it could otherwise be...
--select programming_epoch_responsive_therapy_id, case when response_nm = 'Pattern A Therapy' then 'Burst #1' when response_nm = 'Pattern B Therapy' then 'Burst #2' else response_nm end
--from rns_ods.programming_epoch_responsive_therapy_settings
--group by programming_epoch_responsive_therapy_id, case when response_nm = 'Pattern A Therapy' then 'Burst #1' when response_nm = 'Pattern B Therapy' then 'Burst #2' else response_nm end
--having count(distinct estimated_charge_density_uc_cm_sq) > 1

-- this works same as LE except we're divvying up RX instead; then multiplying by the corresponding burst amount for that therapy...
-- except it's a little more complicated be LE and EAC involve only the FIRST detection; that's our limitation with those calcs; with this calc, we need to go a step further and account for REDETECTIONS... so how to do?
	-- answer (maybe?): don't overengineer; rather, just look at the avg number of therapies per episode by a1_e, a1_le, etc.!
		-- which, of course, we actually CAN do because therapy burst 1 vs 2 will have different amount of stim, but are dependent on 1st detection only, and all subsequent detections do the same thing (so we just need the number, not the type!)


select 
	avg(rt_total) as avg_rt_total,
	stdev(rt_total) as stdev_rt_total
from
(
	select
		z.rns_deid_id,
		sum(z.rt_total) as rt_total
	from
	(
		select
			wrt.rns_deid_id,
			sum(wrt.rt_total) as rt_total
		from rns_dm.sm_pe_nshd_weighted_responsive_therapies wrt
		where wrt.rns_deid_id in
			(
				select rns_deid_id
				from rns_dm.sm_pe_nshd_weighted_responsive_therapies
				where (days_post_implant + pe_days_int_calc) >= 365
			)
			and (wrt.days_post_implant + wrt.pe_days_int_calc) <= 365
		group by wrt.rns_deid_id
		union all
		select
			y.rns_deid_id,
			y.rt_total
		from
		(
			select
				wrt.rns_deid_id,			
				wrt.rt_total * (1 - (wrt.days_post_implant + wrt.pe_days_int_calc - 365) / (wrt.days_post_implant + wrt.pe_days_int_calc)) as rt_total,
				rank() over (partition by wrt.rns_deid_id order by days_post_implant asc) as last_pe_rnk
			from rns_dm.sm_pe_nshd_weighted_responsive_therapies wrt
			where wrt.rns_deid_id in
				(
					select rns_deid_id
					from rns_dm.sm_pe_nshd_weighted_responsive_therapies
					where (wrt.days_post_implant + wrt.pe_days_int_calc) >= 365
				)
				and (wrt.days_post_implant + wrt.pe_days_int_calc) > 365
		) y
		where y.last_pe_rnk = 1
	) z
	group by z.rns_deid_id
) x


-- bilateral therapies 184,674.7 +/- 304,934.5
select 
	avg(l1_l2_diff) as avg_l1_l2_diff,
	stdev(l1_l2_diff) as stdev_l1_l2_diff
from
(
	select
		b.rns_deid_id,	
		max(coalesce(last_pe_rt_l1_total, 0) + coalesce(prev_pe_rt_l1_total, 0)) as running_l1_total,
		max(coalesce(last_pe_rt_l2_total, 0) + coalesce(prev_pe_rt_l2_total, 0)) as running_l2_total,
		abs(max(coalesce(last_pe_rt_l1_total, 0) + coalesce(prev_pe_rt_l1_total, 0)) - max(coalesce(last_pe_rt_l2_total, 0) + coalesce(prev_pe_rt_l2_total, 0))) as l1_l2_diff
	from
	(
		select *
		from
		(
			select top 973
				fl.file_line_id as day_post_implant
			from rns_ods.file_lines fl
			order by fl.file_line_id asc
		) d,
		(
			select
				w.rns_deid_id,
				max(days_post_implant) as max_days_post_implant,
				max(days_post_implant + pe_days_int_calc) as max_data_day
			from rns_dm.sm_pe_nshd_weighted_responsive_therapies w
			group by w.rns_deid_id
		) p
		where p.max_data_day >= d.day_post_implant
	) b
	outer apply
	(
		select top 1
			cast(b.day_post_implant - w.days_post_implant as decimal(10,2)) / cast(w.pe_days_int_calc as decimal(10,2)) as percent_days,
			case when cast(b.day_post_implant - w.days_post_implant as decimal(10,2)) / cast(w.pe_days_int_calc as decimal(10,2)) >= 1 then 0 else w.rt_l1 * cast(b.day_post_implant - w.days_post_implant as decimal(10,2)) / cast(w.pe_days_int_calc as decimal(10,2)) end as last_pe_rt_l1_total,
			case when cast(b.day_post_implant - w.days_post_implant as decimal(10,2)) / cast(w.pe_days_int_calc as decimal(10,2)) >= 1 then 0 else w.rt_l2 * cast(b.day_post_implant - w.days_post_implant as decimal(10,2)) / cast(w.pe_days_int_calc as decimal(10,2)) end as last_pe_rt_l2_total,
			case when w.days_post_implant = b.day_post_implant then 1 else 0 end as pe_flg
		from rns_dm.sm_pe_nshd_weighted_responsive_therapies w
		where w.rns_deid_id = b.rns_deid_id
			and w.days_post_implant <= b.day_post_implant		
		order by w.days_post_implant desc
	) last_pe
	outer apply
	(
		select
			sum(w.rt_l1) as prev_pe_rt_l1_total,
			sum(w.rt_l2) as prev_pe_rt_l2_total
		from rns_dm.sm_pe_nshd_weighted_responsive_therapies w
		where w.rns_deid_id = b.rns_deid_id
			and w.days_post_implant + w.pe_days_int_calc <= b.day_post_implant	
	) prev_pe
	where b.rns_deid_id in
	(
		select rns_deid_id
		from rns_abstractions_ods.implants
		where lead1_laterality = 'L' and lead2_laterality = 'R'
	)
	group by b.rns_deid_id
) x


/*
THE FOLLOWING IS SQL FOR THE FIGURES AND TABLES
*/

/*
Table 1. For other metrics see above queries
*/

/*Mean age of seizure onset*/

select 
	avg(cast(datediff(year, birth_dt, epilepsy_dx_dt) as decimal(10,2))) as mean_age_sz_onset,
	stdev(cast(datediff(year, birth_dt, epilepsy_dx_dt) as decimal(10,2))) as stdev_age_sz_onset
from rns_abstractions_ods.implants

/*Mean number of months implants with RNS*/

--select max(file_dts) from rns_ods.pdms_file_dates pfd join rns_ods.files f on f.name = pfd.file_nm

select
	avg(cast(datediff(month, implant_dt, '2017-11-15 00:17:45.000') as decimal(10,2))) as mean_months_implanted,
	stdev(cast(datediff(month, implant_dt, '2017-11-15 00:17:45.000') as decimal(10,2))) as stdev_months_implanted
from rns_abstractions_ods.implants

/*Mean number of failed anti-epileptic drugs*/

select 
	avg(aeds_failed) as mean_aeds_failed,
	stdev(aeds_failed) as stdev_aeds_failed
from
(
	select
		pm.rns_deid_id, 
		cast(count(distinct pm.medication_nm) as decimal(10,2)) as aeds_failed		
	from epic_dm.patient_medications pm
	join rns_abstractions_ods.implants i
		on pm.rns_deid_id = i.rns_deid_id
	where pm.epilepsy_drg_flg = 1
		and pm.med_start_dt < i.implant_dt
	group by pm.rns_deid_id
)x

/*Mean Seizure Tracking Compliance - Seizure Diary, Magnet*/

select
	avg(cast(magnet_swipe_compliance_int as decimal(10,2))) as avg_mag_cmply,
	stdev(magnet_swipe_compliance_int) as stdev_mag_cmply,
	avg(cast(seizure_diary_compliance_int as decimal(10,2))) as avg_szdry_cmply,
	stdev(seizure_diary_compliance_int) as stdev_szdry_cmply
from rns_ods.seizure_surveys

/*
Table 3. Clinical outcomes for each patient
*/

select
	pre_ss.rns_deid_id,
	cast(datediff(day, i.implant_dt, post_ss.survey_dt) as decimal(10,2)) / 365.00 * 12.00 as months_implanted,
	(pre_ss.seizure1_freq_per_month + pre_ss.seizure2_freq_per_month + pre_ss.seizure3_freq_per_month + pre_ss.seizure4_freq_per_month + pre_ss.seizure5_freq_per_month) - (post_ss.seizure1_freq_per_month + post_ss.seizure2_freq_per_month + post_ss.seizure3_freq_per_month + post_ss.seizure4_freq_per_month + post_ss.seizure5_freq_per_month) as abs_freq_reduction,	 
	case when not (pre_ss.seizure1_freq_per_month + pre_ss.seizure2_freq_per_month + pre_ss.seizure3_freq_per_month + pre_ss.seizure4_freq_per_month + pre_ss.seizure5_freq_per_month) + (post_ss.seizure1_freq_per_month + post_ss.seizure2_freq_per_month + post_ss.seizure3_freq_per_month + post_ss.seizure4_freq_per_month + post_ss.seizure5_freq_per_month) = 0 
		then ((pre_ss.seizure1_freq_per_month + pre_ss.seizure2_freq_per_month + pre_ss.seizure3_freq_per_month + pre_ss.seizure4_freq_per_month + pre_ss.seizure5_freq_per_month) - (post_ss.seizure1_freq_per_month + post_ss.seizure2_freq_per_month + post_ss.seizure3_freq_per_month + post_ss.seizure4_freq_per_month + post_ss.seizure5_freq_per_month)) / 
			((pre_ss.seizure1_freq_per_month + pre_ss.seizure2_freq_per_month + pre_ss.seizure3_freq_per_month + pre_ss.seizure4_freq_per_month + pre_ss.seizure5_freq_per_month) + (post_ss.seizure1_freq_per_month + post_ss.seizure2_freq_per_month + post_ss.seizure3_freq_per_month + post_ss.seizure4_freq_per_month + post_ss.seizure5_freq_per_month))
		else 0.00 
	end * 100.00 as prcnt_freq_reduction,	
	--
	(pre_ss.seizure1_duration_seconds + pre_ss.seizure2_duration_seconds + pre_ss.seizure3_duration_seconds + pre_ss.seizure4_duration_seconds + pre_ss.seizure5_duration_seconds) - (post_ss.seizure1_duration_seconds + post_ss.seizure2_duration_seconds + post_ss.seizure3_duration_seconds + post_ss.seizure4_duration_seconds + post_ss.seizure5_duration_seconds) as abs_duration_reduction,	 
	case when not (pre_ss.seizure1_duration_seconds + pre_ss.seizure2_duration_seconds + pre_ss.seizure3_duration_seconds + pre_ss.seizure4_duration_seconds + pre_ss.seizure5_duration_seconds) + (post_ss.seizure1_duration_seconds + post_ss.seizure2_duration_seconds + post_ss.seizure3_duration_seconds + post_ss.seizure4_duration_seconds + post_ss.seizure5_duration_seconds) = 0 
		then ((pre_ss.seizure1_duration_seconds + pre_ss.seizure2_duration_seconds + pre_ss.seizure3_duration_seconds + pre_ss.seizure4_duration_seconds + pre_ss.seizure5_duration_seconds) - (post_ss.seizure1_duration_seconds + post_ss.seizure2_duration_seconds + post_ss.seizure3_duration_seconds + post_ss.seizure4_duration_seconds + post_ss.seizure5_duration_seconds)) / 
			((pre_ss.seizure1_duration_seconds + pre_ss.seizure2_duration_seconds + pre_ss.seizure3_duration_seconds + pre_ss.seizure4_duration_seconds + pre_ss.seizure5_duration_seconds) + (post_ss.seizure1_duration_seconds + post_ss.seizure2_duration_seconds + post_ss.seizure3_duration_seconds + post_ss.seizure4_duration_seconds + post_ss.seizure5_duration_seconds))
		else 0.00 
	end * 100.00 as prcnt_duration_reduction,
	--
	(pre_ss.seizure_type1_severity + pre_ss.seizure_type2_severity + pre_ss.seizure_type3_severity + pre_ss.seizure_type4_severity + pre_ss.seizure_type5_severity) - (post_ss.seizure_type1_severity + post_ss.seizure_type2_severity + post_ss.seizure_type3_severity + post_ss.seizure_type4_severity + post_ss.seizure_type5_severity) as abs_severity_reduction,
	case when not (pre_ss.seizure_type1_severity + pre_ss.seizure_type2_severity + pre_ss.seizure_type3_severity + pre_ss.seizure_type4_severity + pre_ss.seizure_type5_severity) + (post_ss.seizure_type1_severity + post_ss.seizure_type2_severity + post_ss.seizure_type3_severity + post_ss.seizure_type4_severity + post_ss.seizure_type5_severity) = 0 
		then ((pre_ss.seizure_type1_severity + pre_ss.seizure_type2_severity + pre_ss.seizure_type3_severity + pre_ss.seizure_type4_severity + pre_ss.seizure_type5_severity) - (post_ss.seizure_type1_severity + post_ss.seizure_type2_severity + post_ss.seizure_type3_severity + post_ss.seizure_type4_severity + post_ss.seizure_type5_severity)) /  
			((pre_ss.seizure_type1_severity + pre_ss.seizure_type2_severity + pre_ss.seizure_type3_severity + pre_ss.seizure_type4_severity + pre_ss.seizure_type5_severity) + (post_ss.seizure_type1_severity + post_ss.seizure_type2_severity + post_ss.seizure_type3_severity + post_ss.seizure_type4_severity + post_ss.seizure_type5_severity))
		else 0.00
	end * 100.00 as prcnt_severity_reduction,
	--
	(post_pies.section_a - pre_pies.section_a) as abs_incr_pies_a,
	cast((post_pies.section_a - pre_pies.section_a) as decimal(10,2)) / cast((pre_pies.section_a + post_pies.section_a) as decimal(10,2)) * 100.00 as prcnt_incr_pies_a,
	--
	(post_pies.section_b - pre_pies.section_b) as abs_incr_pies_b,
	cast((post_pies.section_b - pre_pies.section_b) as decimal(10,2)) / cast((pre_pies.section_b + post_pies.section_b) as decimal(10,2)) * 100.00 as prcnt_incr_pies_b,
	--
	(post_pies.section_c - pre_pies.section_c) as abs_incr_pies_a,
	cast((post_pies.section_c - pre_pies.section_c) as decimal(10,2)) / cast((pre_pies.section_c + post_pies.section_c) as decimal(10,2)) * 100.00 as prcnt_incr_pies_c,
	--
	(post_pies.qol - pre_pies.qol) as abs_incr_pies_a,
	cast((post_pies.qol - pre_pies.qol) as decimal(10,2)) / cast((pre_pies.qol + post_pies.qol) as decimal(10,2)) * 100.00 as prcnt_incr_pies_qol,
	--
	(post_pies.section_a + post_pies.section_b + post_pies.section_c) - (pre_pies.section_a + pre_pies.section_b + pre_pies.section_c) as abs_incr_pies_overall,
	cast((post_pies.section_a + post_pies.section_b + post_pies.section_c) - (pre_pies.section_a + pre_pies.section_b + pre_pies.section_c) as decimal(10,2)) / cast((post_pies.section_a + post_pies.section_b + post_pies.section_c) + (pre_pies.section_a + pre_pies.section_b + pre_pies.section_c) as decimal(10,2)) * 100.00 as prcnt_incr_pies_overall
from 
(
	select s.*,
		coalesce(cast(ss.seizure_type1_severity as decimal(10,2)), 0.00) as seizure_type1_severity,
		coalesce(cast(ss.seizure_type2_severity as decimal(10,2)), 0.00) as seizure_type2_severity,
		coalesce(cast(ss.seizure_type3_severity as decimal(10,2)), 0.00) as seizure_type3_severity,
		coalesce(cast(ss.seizure_type4_severity as decimal(10,2)), 0.00) as seizure_type4_severity,
		coalesce(cast(ss.seizure_type5_severity as decimal(10,2)), 0.00) as seizure_type5_severity
	from rns_dm.seizure_surveys_normalized s
	join rns_ods.seizure_surveys ss
		on ss.rns_deid_id = s.rns_deid_id
			and ss.survey_dt = s.survey_dt
	join rns_abstractions_ods.implants i
		on s.rns_deid_id = i.rns_deid_id
	where s.survey_dt <= i.implant_dt
		and s.earliest_survey_rnk = 1
) pre_ss
left join
(
	select s.*,
		coalesce(cast(ss.seizure_type1_severity as decimal(10,2)), 0.00) as seizure_type1_severity,
		coalesce(cast(ss.seizure_type2_severity as decimal(10,2)), 0.00) as seizure_type2_severity,
		coalesce(cast(ss.seizure_type3_severity as decimal(10,2)), 0.00) as seizure_type3_severity,
		coalesce(cast(ss.seizure_type4_severity as decimal(10,2)), 0.00) as seizure_type4_severity,
		coalesce(cast(ss.seizure_type5_severity as decimal(10,2)), 0.00) as seizure_type5_severity
	from rns_dm.seizure_surveys_normalized s
	join rns_ods.seizure_surveys ss
		on ss.rns_deid_id = s.rns_deid_id
			and ss.survey_dt = s.survey_dt
	join rns_abstractions_ods.implants i
		on s.rns_deid_id = i.rns_deid_id
	where s.survey_dt > i.implant_dt
		and s.latest_survey_rnk = 1
) post_ss
	on pre_ss.rns_deid_id = post_ss.rns_deid_id
left join 
(
	select
		ps.rns_deid_id,
		ps.a1 + ps.a2 + ps.a3 + ps.a4 + ps.a5 + ps.a6 + ps.a7 + ps.a8 + ps.a9 as section_a,
		ps.b10 + ps.b11 + ps.b12 + ps.b13 + ps.b14 + ps.b15 + ps.b16 as section_b,
		ps.c17 + ps.c18 + ps.c19 + ps.c20 + ps.c21 + ps.c22 + ps.c23 + ps.c24 + ps.c25 as section_c,
		ps.c25 as qol
	from rns_ods.pies2014_surveys ps
	join rns_abstractions_ods.implants i
		on ps.rns_deid_id = i.rns_deid_id
	where ps.survey_dt <= i.implant_dt
) pre_pies
	on pre_pies.rns_deid_id = pre_ss.rns_deid_id
left join
(
	select
		ps.rns_deid_id,
		ps.a1 + ps.a2 + ps.a3 + ps.a4 + ps.a5 + ps.a6 + ps.a7 + ps.a8 + ps.a9 as section_a,
		ps.b10 + ps.b11 + ps.b12 + ps.b13 + ps.b14 + ps.b15 + ps.b16 as section_b,
		ps.c17 + ps.c18 + ps.c19 + ps.c20 + ps.c21 + ps.c22 + ps.c23 + ps.c24 + ps.c25 as section_c,
		ps.c25 as qol
	from rns_ods.pies2014_surveys ps
	join rns_abstractions_ods.implants i
		on ps.rns_deid_id = i.rns_deid_id
	where ps.survey_dt > i.implant_dt
) post_pies
	on post_pies.rns_deid_id = pre_ss.rns_deid_id
left join rns_abstractions_ods.implants i
	on i.rns_deid_id = pre_ss.rns_deid_id
order by pre_ss.rns_deid_id asc

/*
Table 4. Extrapolated accuracy calculation (EAC), non-weighted accuracy (NWA), latency (LAT), sensitivity (SEN), and specificity (SPE) per programming epoch per patient. 
*/

select
	spe.rns_deid_id,
	spe.pe_nmbr,
	a.missing_entire_pattern_data_flg,
	a.eac * 100.0 as eac,
	a.ecog_accuracy * 100.0 as nwa,	
	l.weighted_latency_s,
	a.sen * 100.0 as sen,
	a.spe * 100.0 as spe
from rns_dm.sm_pe_nshd_weighted_accuracies a
left join rns_dm.sm_pe_nshd_weighted_latencies l
	on a.rns_deid_id = l.rns_deid_id
		and a.programming_dt = l.programming_dt
join rns_dm.sm_programming_epochs spe
	on a.rns_deid_id = spe.rns_deid_id
		and a.programming_dt = spe.programming_dt
order by spe.rns_deid_id, spe.pe_nmbr asc

/*
Figure 3 Levels of RNS system detailed and summary logging.
--I don't think i was considering my units previously; as of now, I'd say the unit should be an episode... or rather "loggable event"
*/

select
	avg(el_percent_complete) as avg_el_percent_complete,
	stdev(el_percent_complete) as stdev_el_percent_complete,
	avg(rmr_percent_complete) as avg_rmr_percent_complete,
	stdev(rmr_percent_complete) as stdev_rmr_percent_complete
from
(
	select
		al_pe.rns_deid_id,
		al_pe.programming_dt,
		al_pe.total_logs_al,
		el_pe.total_logs_el,
		rmr_pe.total_logs_rmr,
		cast(el_pe.total_logs_el as decimal(10,2)) / cast(al_pe.total_logs_al as decimal(10,2)) as el_percent_complete,
		cast(rmr_pe.total_logs_rmr as decimal(10,2)) / cast(al_pe.total_logs_al as decimal(10,2)) as rmr_percent_complete
	from
	(
		select
			spe.rns_deid_id,
			spe.programming_dt,
			sum(al.detections_pattern_a + al.detections_pattern_b + al.saturation_outside_episode + al.saturation_within_episode + al.magnet_placements) as total_logs_al -- so this would have to be everything that could potentially be "of interest" i.e. used to save an ECoG recording... it may be a problem that these numbers are not necessarily mutually exclusive, but can be... so how to count episodes? -- double count everything?
		from rns_dm.sm_programming_epochs spe
		left join rns_dm.activity_logs al
			on al.rns_deid_id = spe.rns_deid_id
				and al.interrogation_dts >= spe.programming_dts and al.interrogation_dts < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
		group by 
			spe.rns_deid_id,
			spe.programming_dt
	) al_pe
	join
	(
		select
			spe.rns_deid_id,
			spe.programming_dt,
			sum(el.a1_fd + el.a2_fd + el.b1_fd + el.b2_fd + el.saturation_cnt + el.magnet_cnt) total_logs_el
		from rns_dm.sm_programming_epochs spe
		left join rns_dm.event_lists el
		on el.rns_deid_id = spe.rns_deid_id
			and el.interrogation_dts >= spe.programming_dts and el.interrogation_dts < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
		group by 
			spe.rns_deid_id,
			spe.programming_dt
	) el_pe
		on al_pe.rns_deid_id = el_pe.rns_deid_id
			and al_pe.programming_dt = el_pe.programming_dt
	join
	(
		select
			spe.rns_deid_id,
			spe.programming_dt,
			sum(case when rmr.name in ('Episode Start, Pattern A', 'Episode Start, Pattern B', 'Magnet', 'Saturation') then 1 else 0 end) as total_logs_rmr
		from rns_dm.sm_programming_epochs spe
		left join rns_dm.remote_monitor_reports rmr
			on rmr.rns_deid_id = spe.rns_deid_id
				and rmr.file_dts >= spe.programming_dts and rmr.file_dts < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
		group by 
			spe.rns_deid_id,
			spe.programming_dt
	) rmr_pe
		on al_pe.rns_deid_id = rmr_pe.rns_deid_id
			and al_pe.programming_dt = rmr_pe.programming_dt
) x

--

select
	avg(percent_days_complete) as avg_percent_days_complete,
	stdev(percent_days_complete) as stdev_percent_days_complete
from
(
	select
		spe.rns_deid_id,
		count(*) as total_days,
		sum(coalesce(missing_histogram_data_flg, missing_diagnostics_data_flg, 0)) as total_days_missing_data,
		1.0 - cast(sum(coalesce(missing_histogram_data_flg, missing_diagnostics_data_flg, 0)) as decimal(10,2)) / cast(count(*) as decimal(10,2)) as percent_days_complete
	from rns_ods.neurostimulator_daily_histories ndh
	join rns_dm.sm_programming_epochs spe
		on ndh.rns_deid_id = spe.rns_deid_id
			and ndh.neurostimulator_daily_dt >= spe.programming_dts and ndh.neurostimulator_daily_dt < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
	group by spe.rns_deid_id
) x

select
	avg(percent_hours_complete) as avg_percent_hours_complete,
	stdev(percent_hours_complete) as stdev_percent_hours_complete
from
(
	select
		spe.rns_deid_id,
		count(*) as total_hours,
		sum(coalesce(missing_histogram_data_flg, missing_diagnostics_data_flg, 0)) as total_hours_missing_data,
		1.0 - cast(sum(coalesce(missing_histogram_data_flg, missing_diagnostics_data_flg, 0)) as decimal(10,2)) / cast(count(*) as decimal(10,2)) as percent_hours_complete
	from rns_ods.neurostimulator_hourly_histories ndh
	join rns_dm.sm_programming_epochs spe
		on ndh.rns_deid_id = spe.rns_deid_id
			and ndh.neurostimulator_hourly_dts >= spe.programming_dts and ndh.neurostimulator_hourly_dts < coalesce(spe.next_programming_dts, spe.max_reviewed_files_dts)
	group by spe.rns_deid_id
) x


--
-- Figure 8. Weighted accuracy of each programming epoch. 
--

-- electrographic seizure reduction. For PRO, see PRO table queries

select
	sz_1.rns_deid_id,
	sz_2.electrographic_seizures_calc_per_wk / (sz_1.electrographic_seizures_calc_per_wk + sz_2.electrographic_seizures_calc_per_wk) as prcnt_reduction
from
(
	select
		sz_1.*,
		rank() over (partition by sz_1.rns_deid_id order by sz_1.programming_dt asc) as pe_order
	from rns_dm.sm_pe_nshd_weighted_electrographic_seizures sz_1
	join rns_dm.sm_programming_epochs pe
		on pe.rns_deid_id = sz_1.rns_deid_id
			and pe.programming_dt = sz_1.programming_dt
	where pe.pe_days_dec >= 20
) sz_1
left join
(
	select
		sz_2.*,
		rank() over (partition by sz_2.rns_deid_id order by sz_2.programming_dt desc) as pe_rev_order
	from rns_dm.sm_pe_nshd_weighted_electrographic_seizures sz_2
	join rns_dm.sm_programming_epochs pe
		on pe.rns_deid_id = sz_2.rns_deid_id
			and pe.programming_dt = sz_2.programming_dt
	where pe.pe_days_dec >= 20
) sz_2
	on sz_1.rns_deid_id = sz_2.rns_deid_id
where sz_1.pe_order = 2
	and sz_2.pe_rev_order = 1

-- graph query for SSRS (EAC Heat Points)

select *
from
(
	select top 11 fl.file_line_id as total_pe_nmbr
	from rns_ods.file_lines fl
	order by fl.file_line_id asc
) pe
left join
(
	select *, rank() over (partition by rns_deid_id order by programming_dt asc) as pe_nmbr
	from [rns_dm].[sm_pe_nshd_weighted_accuracies]
	where rns_deid_id = @rns_deid_id
) eac
	on eac.pe_nmbr = pe.total_pe_nmbr