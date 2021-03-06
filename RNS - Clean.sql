USE [RNS]
GO
/****** Object:  Schema [mrd]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [mrd]
GO
/****** Object:  Schema [rns_abstractions_dm]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [rns_abstractions_dm]
GO
/****** Object:  Schema [rns_abstractions_ods]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [rns_abstractions_ods]
GO
/****** Object:  Schema [rns_dm]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [rns_dm]
GO
/****** Object:  Schema [rns_ods]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [rns_ods]
GO
/****** Object:  Schema [rns_sql2matlab]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [rns_sql2matlab]
GO
/****** Object:  Schema [xref]    Script Date: 10/25/2018 12:53:39 PM ******/
CREATE SCHEMA [xref]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[SplitString] (@stringToSplit VARCHAR(MAX), @separator varchar(50))
RETURNS
	@returnList TABLE ([Name] [varchar] (1000))
AS
BEGIN

 DECLARE @name VARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(@separator, @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(@separator, @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END


GO
/****** Object:  Table [dbo].[dates]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dates](
	[DateKey] [int] NOT NULL,
	[Date] [datetime] NULL,
	[FullDateUK] [char](10) NULL,
	[FullDateUSA] [char](10) NULL,
	[DayOfMonth] [varchar](2) NULL,
	[DaySuffix] [varchar](4) NULL,
	[DayName] [varchar](9) NULL,
	[DayOfWeekUSA] [char](1) NULL,
	[DayOfWeekUK] [char](1) NULL,
	[DayOfWeekInMonth] [varchar](2) NULL,
	[DayOfWeekInYear] [varchar](2) NULL,
	[DayOfQuarter] [varchar](3) NULL,
	[DayOfYear] [varchar](3) NULL,
	[WeekOfMonth] [varchar](1) NULL,
	[WeekOfQuarter] [varchar](2) NULL,
	[WeekOfYear] [varchar](2) NULL,
	[Month] [varchar](2) NULL,
	[MonthName] [varchar](9) NULL,
	[MonthOfQuarter] [varchar](2) NULL,
	[Quarter] [char](1) NULL,
	[QuarterName] [varchar](9) NULL,
	[Year] [char](4) NULL,
	[YearName] [char](7) NULL,
	[MonthYear] [char](10) NULL,
	[MMYYYY] [char](6) NULL,
	[FirstDayOfMonth] [date] NULL,
	[LastDayOfMonth] [date] NULL,
	[FirstDayOfQuarter] [date] NULL,
	[LastDayOfQuarter] [date] NULL,
	[FirstDayOfYear] [date] NULL,
	[LastDayOfYear] [date] NULL,
	[IsHolidayUSA] [bit] NULL,
	[IsWeekday] [bit] NULL,
	[HolidayUSA] [varchar](50) NULL,
	[IsHolidayUK] [bit] NULL,
	[HolidayUK] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [mrd].[patients]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [mrd].[patients](
	[mrd_patient_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NULL,
	[initials_short] [varchar](2) NOT NULL,
	[intitials_long] [varchar](10) NULL,
	[first_nm] [varchar](1000) NULL,
	[last_nm] [varchar](1000) NULL,
	[birth_dt] [date] NULL,
	[load_dts] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[engel_classifications]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[engel_classifications](
	[rns_deid_id] [varchar](100) NOT NULL,
	[engel_classification] [varchar](50) NOT NULL,
	[load_dts] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[ieeg_annotations]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[ieeg_annotations](
	[ieeg_annotation_id] [int] IDENTITY(1,1) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[short_nm] [varchar](5) NULL,
	[full_nm] [varchar](1000) NULL,
	[channel_nmbr] [int] NOT NULL,
	[sample_nmbr] [int] NOT NULL,
	[annotated_x] [varchar](1000) NULL,
	[annotated_y] [varchar](1000) NULL,
	[annotated_by] [varchar](1000) NULL,
	[annotated_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_ieeg_annotations] PRIMARY KEY CLUSTERED 
(
	[ieeg_annotation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[implants]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[implants](
	[patient_id] [int] NOT NULL,
	[rns_deid_id] [varchar](100) NULL,
	[birth_dt] [date] NULL,
	[gender] [varchar](50) NULL,
	[dominant_hand] [varchar](50) NULL,
	[implant_dt] [date] NULL,
	[epilepsy_dx_dt] [date] NULL,
	[epilepsy_type_ilae] [varchar](50) NULL,
	[epilepsy_etiology_ilae] [varchar](50) NULL,
	[lead1_type] [varchar](50) NULL,
	[lead1_location] [varchar](1000) NULL,
	[lead1_orientation] [varchar](50) NULL,
	[lead1_laterality] [varchar](50) NULL,
	[lead2_type] [varchar](50) NULL,
	[lead2_location] [varchar](1000) NULL,
	[lead2_orientation] [varchar](50) NULL,
	[lead2_laterality] [varchar](50) NULL,
	[placement_notes] [varchar](5000) NULL,
	[load_dts] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[medical_histories]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[medical_histories](
	[medical_history_id] [int] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[diagnosis_dsc] [varchar](1000) NULL,
	[diagnosis_dt] [date] NULL,
	[comment] [varchar](1000) NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_medical_histories] PRIMARY KEY CLUSTERED 
(
	[medical_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[programming_epoch_changes]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[programming_epoch_changes](
	[programming_epoch_change_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[detector_chng] [varchar](100) NOT NULL,
	[stimulation_chng] [varchar](100) NOT NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_programming_epoch_changes] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_change_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[seizure_classifications]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[seizure_classifications](
	[seizure_classification_id] [int] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NULL,
	[seizure_classification1_ilae] [varchar](50) NULL,
	[seizure_classification2_ilae] [varchar](50) NULL,
	[seizure_classification3_ilae] [varchar](50) NULL,
	[seizure_classification4_ilae] [varchar](50) NULL,
	[seizure_classification5_ilae] [varchar](50) NULL,
	[seizure_dsc] [varchar](5000) NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_seizure_classifications] PRIMARY KEY CLUSTERED 
(
	[seizure_classification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[seizure_onsets]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[seizure_onsets](
	[seizure_onset_id] [int] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[location_dsc] [varchar](1000) NULL,
	[location_laterality] [varchar](50) NULL,
	[noted_dt] [date] NULL,
	[notes] [varchar](5000) NULL,
	[load_dts] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_abstractions_ods].[surgical_histories]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_abstractions_ods].[surgical_histories](
	[surgical_history_id] [int] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[procedure_dsc] [varchar](1000) NULL,
	[laterality] [varchar](50) NULL,
	[procedure_dt] [date] NULL,
	[comment] [varchar](1000) NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_surgical_histories] PRIMARY KEY CLUSTERED 
(
	[surgical_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[event_lists_components]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[event_lists_components](
	[event_lists_component_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](50) NOT NULL,
	[patient_id] [int] NOT NULL,
	[interrogation_dts] [datetime] NOT NULL,
	[episode_sequence] [varchar](50) NOT NULL,
	[event_dts] [datetime] NOT NULL,
	[episode_trigger] [varchar](50) NOT NULL,
	[a1_fd] [int] NULL,
	[a2_fd] [int] NULL,
	[b1_fd] [int] NULL,
	[b2_fd] [int] NULL,
	[a1_rd] [int] NULL,
	[a2_rd] [int] NULL,
	[b1_rd] [int] NULL,
	[b2_rd] [int] NULL,
	[a1_total] [int] NULL,
	[a2_total] [int] NULL,
	[b1_total] [int] NULL,
	[b2_total] [int] NULL,
	[a_total] [int] NULL,
	[b_total] [int] NULL,
	[responsive_therapy_cnt] [int] NULL,
	[magnet_cnt] [int] NULL,
	[saturation_cnt] [int] NULL,
	[noise_cnt] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_event_lists_components] PRIMARY KEY CLUSTERED 
(
	[event_lists_component_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[file_ids]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[file_ids](
	[file_id_id] [bigint] IDENTITY(1,1) NOT NULL,
	[datfile_nm] [varchar](8000) NOT NULL,
	[file_id_at_time] [bigint] NOT NULL,
	[load_dts] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[ieeg_file_data_compiled_for_seizure_markings]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[ieeg_file_data_compiled_for_seizure_markings](
	[ieeg_file_data_compiled_for_seizure_markings_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[datfile_nm] [varchar](8000) NOT NULL,
	[compiled_file_nm] [varchar](8000) NOT NULL,
	[compiled_sample_nmbr] [bigint] NOT NULL,
	[file_id] [bigint] NOT NULL,
	[sample_nmbr] [int] NOT NULL,
	[channel1] [int] NULL,
	[channel2] [int] NULL,
	[channel3] [int] NULL,
	[channel4] [int] NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_ieeg_file_data_compiled_for_seizure_markings] PRIMARY KEY CLUSTERED 
(
	[ieeg_file_data_compiled_for_seizure_markings_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[ltnd_fft]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[ltnd_fft](
	[ltnd_fft_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[dat_file_nm] [varchar](1000) NOT NULL,
	[file_dts] [datetime] NOT NULL,
	[c1_delta_pwr] [decimal](10, 3) NULL,
	[c1_theta_pwr] [decimal](10, 3) NULL,
	[c1_alpha_pwr] [decimal](10, 3) NULL,
	[c1_beta_pwr] [decimal](10, 3) NULL,
	[c1_gamma_pwr] [decimal](10, 3) NULL,
	[c1_lo_gamma_pwr] [decimal](10, 3) NULL,
	[c1_hi_gamma_pwr] [decimal](10, 3) NULL,
	[c2_delta_pwr] [decimal](10, 3) NULL,
	[c2_theta_pwr] [decimal](10, 3) NULL,
	[c2_alpha_pwr] [decimal](10, 3) NULL,
	[c2_beta_pwr] [decimal](10, 3) NULL,
	[c2_gamma_pwr] [decimal](10, 3) NULL,
	[c2_lo_gamma_pwr] [decimal](10, 3) NULL,
	[c2_hi_gamma_pwr] [decimal](10, 3) NULL,
	[c3_delta_pwr] [decimal](10, 3) NULL,
	[c3_theta_pwr] [decimal](10, 3) NULL,
	[c3_alpha_pwr] [decimal](10, 3) NULL,
	[c3_beta_pwr] [decimal](10, 3) NULL,
	[c3_gamma_pwr] [decimal](10, 3) NULL,
	[c3_lo_gamma_pwr] [decimal](10, 3) NULL,
	[c3_hi_gamma_pwr] [decimal](10, 3) NULL,
	[c4_delta_pwr] [decimal](10, 3) NULL,
	[c4_theta_pwr] [decimal](10, 3) NULL,
	[c4_alpha_pwr] [decimal](10, 3) NULL,
	[c4_beta_pwr] [decimal](10, 3) NULL,
	[c4_gamma_pwr] [decimal](10, 3) NULL,
	[c4_lo_gamma_pwr] [decimal](10, 3) NULL,
	[c4_hi_gamma_pwr] [decimal](10, 3) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_ltnd_fft] PRIMARY KEY CLUSTERED 
(
	[ltnd_fft_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[ltnd_files]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[ltnd_files](
	[ltnd_file_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[dat_file_path] [varchar](2501) NOT NULL,
	[dat_file_nm] [varchar](1000) NOT NULL,
	[file_dts] [datetime] NOT NULL,
	[file_size_samples] [int] NOT NULL,
	[trigger_reason] [varchar](1000) NOT NULL,
	[any_detections_flg] [bit] NOT NULL,
	[any_sz_flg] [bit] NOT NULL,
	[any_interictal_calc_flg] [bit] NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_ltnd_files] PRIMARY KEY CLUSTERED 
(
	[ltnd_file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[ltnd_fooof_peaks]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[ltnd_fooof_peaks](
	[ltnd_fooof_peak_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[dat_file_nm] [varchar](1000) NOT NULL,
	[channel] [int] NOT NULL,
	[peak_nmbr] [int] NOT NULL,
	[peak_cf] [decimal](10, 2) NOT NULL,
	[peak_amp] [decimal](10, 3) NOT NULL,
	[peak_bw] [decimal](10, 2) NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_ltnd_fooof_peaks] PRIMARY KEY CLUSTERED 
(
	[ltnd_fooof_peak_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[ltnd_fooofs]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[ltnd_fooofs](
	[ltnd_fooof_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[dat_file_nm] [varchar](1000) NOT NULL,
	[file_dts] [datetime] NOT NULL,
	[channel] [int] NOT NULL,
	[freq_rng_lo] [decimal](10, 2) NOT NULL,
	[freq_rng_hi] [decimal](10, 2) NOT NULL,
	[freq_res] [decimal](10, 2) NOT NULL,
	[background_offset] [decimal](10, 4) NULL,
	[background_slope] [decimal](10, 4) NULL,
	[gof_r2] [decimal](10, 4) NULL,
	[gof_rms_error] [decimal](10, 4) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_ltnd_fooofs] PRIMARY KEY CLUSTERED 
(
	[ltnd_fooof_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[rns_seizure_markings]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[rns_seizure_markings](
	[rns_seizure_markings_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[compiled_file_nm] [varchar](1000) NOT NULL,
	[datfile_nm] [varchar](1000) NULL,
	[sample_nmbr] [int] NULL,
	[compiled_sample_nmbr] [bigint] NULL,
	[csv_file_line] [bigint] NOT NULL,
	[time_dec] [decimal](29, 10) NOT NULL,
	[orig_channel1] [int] NULL,
	[edf_channel1] [decimal](29, 10) NULL,
	[orig_channel2] [int] NULL,
	[edf_channel2] [decimal](29, 10) NULL,
	[orig_channel3] [int] NULL,
	[edf_channel3] [decimal](29, 10) NULL,
	[orig_channel4] [int] NULL,
	[edf_channel4] [decimal](29, 10) NULL,
	[annotation] [varchar](1000) NULL,
	[onset_dec] [decimal](29, 10) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_rns_seizure_markings] PRIMARY KEY CLUSTERED 
(
	[rns_seizure_markings_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[rns_seizure_markings_edf_csv_files]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[rns_seizure_markings_edf_csv_files](
	[rns_seizure_markings_edf_csv_file_id] [int] IDENTITY(1,1) NOT NULL,
	[csv_file_nm] [varchar](1000) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_rns_seizure_markings_edf_csv_files] PRIMARY KEY CLUSTERED 
(
	[rns_seizure_markings_edf_csv_file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[rns_seizure_markings_edf_edited_data_stims]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[rns_seizure_markings_edf_edited_data_stims](
	[rns_seizure_markings_edf_edited_data_stim_id] [bigint] IDENTITY(1,1) NOT NULL,
	[csv_file_nm] [varchar](1000) NOT NULL,
	[stim_start_csv_file_line] [bigint] NOT NULL,
	[stim_start_time_dec] [decimal](10, 3) NOT NULL,
	[stim_stop_csv_file_line] [bigint] NOT NULL,
	[stim_stop_time_dec] [decimal](10, 3) NOT NULL,
	[ecog_begins_mid_stim_flg] [bit] NOT NULL,
	[ecog_ends_mid_stim_flg] [bit] NOT NULL,
	[first_stim_of_episode_flg] [bit] NULL,
	[stim_annotation_calc] [varchar](10) NULL,
	[ch1_blnk_val] [decimal](10, 3) NOT NULL,
	[ch2_blnk_val] [decimal](10, 3) NOT NULL,
	[ch3_blnk_val] [decimal](10, 3) NOT NULL,
	[ch4_blnk_val] [decimal](10, 3) NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_rns_seizure_markings_edf_edited_data_stims] PRIMARY KEY CLUSTERED 
(
	[rns_seizure_markings_edf_edited_data_stim_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_al_nde_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_al_nde_summaries](
	[sm_al_nde_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[interrogation_dts] [datetime] NOT NULL,
	[el_total_duration_s] [decimal](10, 2) NULL,
	[el_total_episode_duration_s_calc] [decimal](10, 2) NULL,
	[avg_el_episode_duration_s] [decimal](10, 2) NULL,
	[nde_cnt] [int] NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_al_nde_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_al_nde_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_al_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_al_summaries](
	[sm_al_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[a] [int] NULL,
	[b] [int] NULL,
	[le] [int] NULL,
	[a_e] [decimal](10, 2) NULL,
	[a_le] [decimal](10, 2) NULL,
	[b_e] [decimal](10, 2) NULL,
	[b_le] [decimal](10, 2) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_al_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_al_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_ecog_episode_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_ecog_episode_summaries](
	[sm_ecog_episode_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NULL,
	[file_nm] [varchar](1000) NOT NULL,
	[file_dts] [datetime] NOT NULL,
	[episode_nmbr] [int] NOT NULL,
	[episode_file_start_s] [decimal](10, 2) NULL,
	[episode_file_end_s] [decimal](10, 2) NULL,
	[episode_calc_start_dts] [datetime] NULL,
	[episode_calc_end_dts] [datetime] NULL,
	[first_detector] [varchar](1000) NULL,
	[first_detector_trigger_s] [decimal](10, 2) NULL,
	[first_detector_trigger_smpl] [int] NULL,
	[episode_type] [varchar](50) NULL,
	[a1_cnt] [int] NULL,
	[a2_cnt] [int] NULL,
	[b1_cnt] [int] NULL,
	[b2_cnt] [int] NULL,
	[sz_annotation] [varchar](50) NULL,
	[sz_marked_onset_s] [decimal](10, 2) NULL,
	[sz_relative_onset_smpl] [decimal](10, 2) NULL,
	[sz_relative_onset_s] [decimal](10, 2) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_ecog_episode_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_ecog_episode_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_ecog_nde_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_ecog_nde_summaries](
	[sm_ecog_nde_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[file_nm] [varchar](1000) NOT NULL,
	[file_dts] [datetime] NOT NULL,
	[nde_cnt] [decimal](10, 2) NOT NULL,
	[sz_flg] [bit] NOT NULL,
	[sz_annotation] [varchar](10) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_ecog_nde_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_ecog_nde_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_ecog_pe_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_ecog_pe_summaries](
	[sm_ecog_pe_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[a1_eg_e_tp] [int] NULL,
	[a1_eg_e_fp] [int] NULL,
	[a1_eg_e_tn] [int] NULL,
	[a1_eg_e_fn] [int] NULL,
	[a1_eg_e_sen] [decimal](10, 2) NULL,
	[a1_eg_e_spe] [decimal](10, 2) NULL,
	[a1_eg_e_acc] [decimal](10, 2) NULL,
	[a1_eg_le_tp] [int] NULL,
	[a1_eg_le_fp] [int] NULL,
	[a1_eg_le_tn] [int] NULL,
	[a1_eg_le_fn] [int] NULL,
	[a1_eg_le_sen] [decimal](10, 2) NULL,
	[a1_eg_le_spe] [decimal](10, 2) NULL,
	[a1_eg_le_acc] [decimal](10, 2) NULL,
	[a2_eg_e_tp] [int] NULL,
	[a2_eg_e_fp] [int] NULL,
	[a2_eg_e_tn] [int] NULL,
	[a2_eg_e_fn] [int] NULL,
	[a2_eg_e_sen] [decimal](10, 2) NULL,
	[a2_eg_e_spe] [decimal](10, 2) NULL,
	[a2_eg_e_acc] [decimal](10, 2) NULL,
	[a2_eg_le_tp] [int] NULL,
	[a2_eg_le_fp] [int] NULL,
	[a2_eg_le_tn] [int] NULL,
	[a2_eg_le_fn] [int] NULL,
	[a2_eg_le_sen] [decimal](10, 2) NULL,
	[a2_eg_le_spe] [decimal](10, 2) NULL,
	[a2_eg_le_acc] [decimal](10, 2) NULL,
	[b1_eg_e_tp] [int] NULL,
	[b1_eg_e_fp] [int] NULL,
	[b1_eg_e_tn] [int] NULL,
	[b1_eg_e_fn] [int] NULL,
	[b1_eg_e_sen] [decimal](10, 2) NULL,
	[b1_eg_e_spe] [decimal](10, 2) NULL,
	[b1_eg_e_acc] [decimal](10, 2) NULL,
	[b1_eg_le_tp] [int] NULL,
	[b1_eg_le_fp] [int] NULL,
	[b1_eg_le_tn] [int] NULL,
	[b1_eg_le_fn] [int] NULL,
	[b1_eg_le_sen] [decimal](10, 2) NULL,
	[b1_eg_le_spe] [decimal](10, 2) NULL,
	[b1_eg_le_acc] [decimal](10, 2) NULL,
	[b2_eg_e_tp] [int] NULL,
	[b2_eg_e_fp] [int] NULL,
	[b2_eg_e_tn] [int] NULL,
	[b2_eg_e_fn] [int] NULL,
	[b2_eg_e_sen] [decimal](10, 2) NULL,
	[b2_eg_e_spe] [decimal](10, 2) NULL,
	[b2_eg_e_acc] [decimal](10, 2) NULL,
	[b2_eg_le_tp] [int] NULL,
	[b2_eg_le_fp] [int] NULL,
	[b2_eg_le_tn] [int] NULL,
	[b2_eg_le_fn] [int] NULL,
	[b2_eg_le_sen] [decimal](10, 2) NULL,
	[b2_eg_le_spe] [decimal](10, 2) NULL,
	[b2_eg_le_acc] [decimal](10, 2) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_ecog_pe_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_ecog_pe_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_el_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_el_summaries](
	[sm_el_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[a1_e] [int] NULL,
	[a1_le] [int] NULL,
	[a2_e] [int] NULL,
	[a2_le] [int] NULL,
	[b1_e] [int] NULL,
	[b1_le] [int] NULL,
	[b2_e] [int] NULL,
	[b2_le] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_el_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_el_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_files]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_files](
	[sm_file_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[compiled_file_nm] [varchar](1000) NOT NULL,
	[datfile_order] [int] NULL,
	[datfile_nm] [varchar](1000) NULL,
	[file_dts] [datetime] NULL,
	[min_sample_nmbr] [int] NULL,
	[max_sample_nmbr] [int] NULL,
	[min_compiled_sample_nmbr] [bigint] NULL,
	[max_compiled_sample_nmbr] [bigint] NULL,
	[min_csv_file_line] [bigint] NULL,
	[max_csv_file_line] [bigint] NULL,
	[total_samples] [bigint] NULL,
	[sz_flg] [int] NULL,
	[sz_annotation] [varchar](1000) NULL,
	[sz_marked_onset_s] [decimal](10, 2) NULL,
	[sz_marked_onset_smpl] [bigint] NULL,
	[sz_relative_onset_s] [decimal](10, 2) NULL,
	[sz_relative_onset_smpl] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_files] PRIMARY KEY CLUSTERED 
(
	[sm_file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_nshd_summaries]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_nshd_summaries](
	[sm_nshd_summary_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[a1_e] [int] NULL,
	[a1_le] [int] NULL,
	[a2_e] [int] NULL,
	[a2_le] [int] NULL,
	[b1_e] [int] NULL,
	[b1_le] [int] NULL,
	[b2_e] [int] NULL,
	[b2_le] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_nshd_summaries] PRIMARY KEY CLUSTERED 
(
	[sm_nshd_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_pe_el_responsive_therapies]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_pe_el_responsive_therapies](
	[sm_pe_el_responsive_therapy_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[programming_dt] [date] NOT NULL,
	[a1_rt_e] [decimal](38, 6) NULL,
	[a1_rt_le] [decimal](38, 6) NULL,
	[a2_rt_e] [decimal](38, 6) NULL,
	[a2_rt_le] [decimal](38, 6) NULL,
	[b1_rt_e] [decimal](38, 6) NULL,
	[b1_rt_le] [decimal](38, 6) NULL,
	[b2_rt_e] [decimal](38, 6) NULL,
	[b2_rt_le] [decimal](38, 6) NULL,
	[a_rt_e] [decimal](38, 6) NULL,
	[a_rt_le] [decimal](38, 6) NULL,
	[b_rt_e] [decimal](38, 6) NULL,
	[b_rt_le] [decimal](38, 6) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_pe_el_responsive_therapies] PRIMARY KEY CLUSTERED 
(
	[sm_pe_el_responsive_therapy_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_dm].[sm_programming_epochs]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_dm].[sm_programming_epochs](
	[sm_programming_epoch_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NULL,
	[compiled_file_nm] [varchar](1000) NOT NULL,
	[implant_dt] [date] NOT NULL,
	[pe_nmbr] [int] NOT NULL,
	[pe_rt_nmbr] [int] NULL,
	[pe_dt_nmbr] [int] NULL,
	[rt_chng_flg] [bit] NULL,
	[dt_chng_flg] [bit] NULL,
	[programming_dt] [date] NOT NULL,
	[programming_dts] [datetime] NULL,
	[prev_programming_dt] [date] NULL,
	[prev_programming_dts] [datetime] NULL,
	[next_programming_dt] [date] NULL,
	[next_programming_dts] [datetime] NULL,
	[pe_days_dec] [numeric](6, 2) NULL,
	[min_reviewed_files_dts] [datetime] NULL,
	[max_reviewed_files_dts] [datetime] NULL,
	[total_samples_reviewed] [int] NULL,
	[total_files_reviewed] [int] NULL,
	[total_sz_annotations] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_sm_programming_epochs] PRIMARY KEY CLUSTERED 
(
	[sm_programming_epoch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[acmet_effect_onsets]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[acmet_effect_onsets](
	[acmet_effect_onset_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](50) NOT NULL,
	[compiled_file_nm] [varchar](1000) NOT NULL,
	[effect_nm] [varchar](50) NOT NULL,
	[onset_time] [time](7) NOT NULL,
	[onset_s] [bigint] NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_acmet_effect_onsets] PRIMARY KEY CLUSTERED 
(
	[acmet_effect_onset_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[acmet_outcomes_raw]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[acmet_outcomes_raw](
	[acmet_outcomes_raw_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](50) NULL,
	[age] [varchar](50) NULL,
	[sex] [varchar](50) NULL,
	[sites_and_pathology] [varchar](50) NULL,
	[months] [varchar](50) NULL,
	[acute_direct_inhibit] [varchar](50) NULL,
	[acute_freq_mod] [varchar](50) NULL,
	[chronic_spont_indirect_inhibit] [varchar](50) NULL,
	[chronic_freq_mod] [varchar](50) NULL,
	[chronic_frag] [varchar](50) NULL,
	[chronic_interval_mod] [varchar](50) NULL,
	[chronic_duration] [varchar](50) NULL,
	[outcome] [varchar](50) NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_acmet_outcomes_raw] PRIMARY KEY CLUSTERED 
(
	[acmet_outcomes_raw_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[activity_logs]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rns_ods].[activity_logs](
	[activity_log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[interrogation_dts] [datetime] NOT NULL,
	[last_interrogation_dts] [datetime] NULL,
	[last_programming_dts] [datetime] NULL,
	[noise_within_episode] [int] NULL,
	[noise_outside_episode] [int] NULL,
	[saturation_within_episode] [int] NULL,
	[saturation_outside_episode] [int] NULL,
	[detections_pattern_a] [int] NULL,
	[detections_pattern_b] [int] NULL,
	[detections_rx_exhausted] [int] NULL,
	[therapies_inhibited_by_postepisode_interval] [int] NULL,
	[magnet_placements] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_activity_log] PRIMARY KEY CLUSTERED 
(
	[activity_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [rns_ods].[battery_measurements]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[battery_measurements](
	[battery_measurement_id] [bigint] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[json_val] [varchar](1000) NOT NULL,
	[measurement_dts] [datetime] NOT NULL,
	[current_battery_voltage] [decimal](10, 2) NOT NULL,
	[elective_replacement_voltage] [decimal](10, 2) NOT NULL,
	[end_of_service_voltage] [decimal](10, 2) NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_battery_measurements] PRIMARY KEY CLUSTERED 
(
	[battery_measurement_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[channel_maps]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[channel_maps](
	[channel_map_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[channel1] [varchar](2000) NULL,
	[channel2] [varchar](2000) NULL,
	[channel3] [varchar](2000) NULL,
	[channel4] [varchar](2000) NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_channel_maps] PRIMARY KEY CLUSTERED 
(
	[channel_map_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[event_lists]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[event_lists](
	[event_list_id] [bigint] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[interrogation_dts] [datetime] NOT NULL,
	[episode_sequence] [varchar](50) NOT NULL,
	[event_dts] [datetime] NOT NULL,
	[duration] [varchar](100) NOT NULL,
	[event_type] [varchar](5000) NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_event_list] PRIMARY KEY CLUSTERED 
(
	[event_list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[file_info]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[file_info](
	[file_info_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[file] [varchar](2000) NULL,
	[file_type] [varchar](2000) NULL,
	[sampling_rate] [varchar](2000) NULL,
	[header_length] [varchar](2000) NULL,
	[calibration] [varchar](2000) NULL,
	[wave_form_count] [varchar](2000) NULL,
	[data_type] [varchar](2000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_file_info] PRIMARY KEY CLUSTERED 
(
	[file_info_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[file_lines]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[file_lines](
	[file_line_id] [bigint] IDENTITY(1,1) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[header] [varchar](1000) NOT NULL,
	[line_nmbr] [int] NOT NULL,
	[line_txt] [varchar](2000) NOT NULL,
	[column_nm] [varchar](2000) NULL,
	[column_val] [varchar](2000) NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_file_lines] PRIMARY KEY CLUSTERED 
(
	[file_line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[files]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[files](
	[file_id] [bigint] IDENTITY(1,1) NOT NULL,
	[path] [varchar](2000) NOT NULL,
	[name] [varchar](500) NOT NULL,
	[extension] [varchar](50) NOT NULL,
	[file_load_dts] [datetime] NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_files] PRIMARY KEY CLUSTERED 
(
	[file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[ieeg_data]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rns_ods].[ieeg_data](
	[ieeg_data_id] [bigint] IDENTITY(1,1) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[sample_nmbr] [int] NOT NULL,
	[channel1] [int] NULL,
	[channel2] [int] NULL,
	[channel3] [int] NULL,
	[channel4] [int] NULL,
	[load_dts] [datetime] NULL,
 CONSTRAINT [PK_ieeg_data] PRIMARY KEY CLUSTERED 
(
	[ieeg_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [rns_ods].[impedance_measurements]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[impedance_measurements](
	[impedance_measurement_id] [bigint] IDENTITY(1,1) NOT NULL,
	[patient_id] [int] NOT NULL,
	[json_val] [varchar](1000) NOT NULL,
	[measurement_dts] [datetime] NOT NULL,
	[lead_nm] [varchar](1000) NOT NULL,
	[lead_ohms] [decimal](10, 2) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_impedance_measurements] PRIMARY KEY CLUSTERED 
(
	[impedance_measurement_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[neurostimulator_daily_histories]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[neurostimulator_daily_histories](
	[neurostimulator_daily_history_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](50) NOT NULL,
	[url] [varchar](1000) NOT NULL,
	[patient_id] [int] NOT NULL,
	[neurostimulator_daily_dt] [date] NOT NULL,
	[episodes_cnt] [int] NULL,
	[a1_cnt] [int] NULL,
	[a2_cnt] [int] NULL,
	[b1_cnt] [int] NULL,
	[b2_cnt] [int] NULL,
	[long_episodes_cnt] [int] NULL,
	[saturations_cnt] [int] NULL,
	[magnets_cnt] [int] NULL,
	[therapies_cnt] [int] NULL,
	[programming_flg] [bit] NULL,
	[missing_histogram_data_flg] [bit] NULL,
	[missing_diagnostics_data_flg] [bit] NULL,
	[device_implant_flg] [bit] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_neurostimulator_daily_histories] PRIMARY KEY CLUSTERED 
(
	[neurostimulator_daily_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[neurostimulator_history_json]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[neurostimulator_history_json](
	[neurostimulator_history_json_id] [bigint] IDENTITY(1,1) NOT NULL,
	[url] [varchar](1000) NULL,
	[patient_id] [int] NOT NULL,
	[neurostimulator_history_type] [varchar](100) NOT NULL,
	[json_data_nm] [varchar](100) NOT NULL,
	[json_dts] [bigint] NOT NULL,
	[deserialized_dts] [datetime] NOT NULL,
	[json_val] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_neurostimulator_history_json] PRIMARY KEY CLUSTERED 
(
	[neurostimulator_history_json_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[neurostimulator_hourly_histories]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[neurostimulator_hourly_histories](
	[neurostimulator_hourly_history_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](50) NOT NULL,
	[url] [varchar](1000) NOT NULL,
	[patient_id] [int] NOT NULL,
	[neurostimulator_hourly_dts] [datetime] NOT NULL,
	[episodes_cnt] [int] NULL,
	[a1_cnt] [int] NULL,
	[a2_cnt] [int] NULL,
	[b1_cnt] [int] NULL,
	[b2_cnt] [int] NULL,
	[long_episodes_cnt] [int] NULL,
	[saturations_cnt] [int] NULL,
	[magnets_cnt] [int] NULL,
	[therapies_cnt] [int] NULL,
	[programming_flg] [bit] NULL,
	[missing_histogram_data_flg] [bit] NULL,
	[missing_diagnostics_data_flg] [bit] NULL,
	[device_implant_flg] [bit] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_neurostimulator_hourly_histories] PRIMARY KEY CLUSTERED 
(
	[neurostimulator_hourly_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[np_comments]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[np_comments](
	[np_comment_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[feature_labels] [varchar](1000) NULL,
	[trigger_reason] [varchar](1000) NULL,
	[annotations] [varchar](1000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_np_comments] PRIMARY KEY CLUSTERED 
(
	[np_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[np_configurations]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[np_configurations](
	[np_configuration_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[np_config_str] [varchar](1000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_np_configurations] PRIMARY KEY CLUSTERED 
(
	[np_configuration_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[np_fileinfo]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[np_fileinfo](
	[np_fileinfo_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[lay_file_version] [varchar](1000) NULL,
	[layout_file_timestamp_as_local_time] [text] NULL,
	[layout_file_timestamp_time_zone] [text] NULL,
	[layout_file_timestamp_offset_hours_from_gmt] [text] NULL,
	[layout_file_timestamp_offset_minutes_from_gmt] [text] NULL,
	[layout_file_timestamp_as_utc] [text] NULL,
	[ecog_timestamp_as_local_time] [text] NULL,
	[ecog_file_timestamp_time_zone] [text] NULL,
	[ecog_file_timestamp_offset_hours_from_gmt] [text] NULL,
	[ecog_file_timestamp_offset_minutes_from_gmt] [text] NULL,
	[ecog_file_timestamp_as_utc] [text] NULL,
	[programmer_serial_number] [varchar](1000) NULL,
	[programmer_software_revision] [varchar](1000) NULL,
	[annotated_programmer_serial_number] [varchar](1000) NULL,
	[annotated_programmer_software_revision] [varchar](1000) NULL,
	[device_serial_number] [varchar](1000) NULL,
	[device_model_number] [varchar](1000) NULL,
	[device_software_version] [varchar](1000) NULL,
	[device_hardware_version] [varchar](1000) NULL,
	[device_rom_version] [varchar](1000) NULL,
	[device_holly_dog_tag] [varchar](1000) NULL,
	[device_lister_dog_tag] [varchar](1000) NULL,
	[programming_parameter_file] [varchar](1000) NULL,
	[dat_file] [varchar](1000) NULL,
	[np_file_type] [varchar](1000) NULL,
	[device_records_used] [varchar](1000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_np_fileinfo] PRIMARY KEY CLUSTERED 
(
	[np_fileinfo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[np_parameters]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[np_parameters](
	[np_parameter_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[amplifier_channel_1_sample_rate] [varchar](1000) NULL,
	[amplifier_channel_2_sample_rate] [varchar](1000) NULL,
	[amplifier_channel_3_sample_rate] [varchar](1000) NULL,
	[amplifier_channel_4_sample_rate] [varchar](1000) NULL,
	[amplifier_channel_1_ecog_storage_enabled] [varchar](1000) NULL,
	[amplifier_channel_2_ecog_storage_enabled] [varchar](1000) NULL,
	[amplifier_channel_3_ecog_storage_enabled] [varchar](1000) NULL,
	[amplifier_channel_4_ecog_storage_enabled] [varchar](1000) NULL,
	[amplifier_channel_1_stored_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_2_stored_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_3_stored_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_4_stored_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_1_realtime_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_2_realtime_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_3_realtime_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_4_realtime_ecog_sampling_interval] [varchar](1000) NULL,
	[amplifier_channel_1_gain] [varchar](1000) NULL,
	[amplifier_channel_2_gain] [varchar](1000) NULL,
	[amplifier_channel_3_gain] [varchar](1000) NULL,
	[amplifier_channel_4_gain] [varchar](1000) NULL,
	[amplifier_channel_1_low_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_2_low_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_3_low_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_4_low_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_1_high_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_2_high_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_3_high_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_channel_4_high_pass_filter_frequency] [varchar](1000) NULL,
	[amplifier_1_line_length_trend_window_size] [varchar](1000) NULL,
	[amplifier_2_line_length_trend_window_size] [varchar](1000) NULL,
	[amplifier_1_line_length_trend_is_interval] [varchar](1000) NULL,
	[amplifier_2_line_length_trend_is_interval] [varchar](1000) NULL,
	[amplifier_1_line_length_trend_sample_count] [varchar](1000) NULL,
	[amplifier_2_line_length_trend_sample_count] [varchar](1000) NULL,
	[amplifier_1_area_trend_window_size] [varchar](1000) NULL,
	[amplifier_2_area_trend_window_size] [varchar](1000) NULL,
	[amplifier_1_area_trend_inter_sample_interval] [varchar](1000) NULL,
	[amplifier_2_area_trend_inter_sample_interval] [varchar](1000) NULL,
	[amplifier_1_area_trend_sample_count] [varchar](1000) NULL,
	[amplifier_2_area_trend_sample_count] [varchar](1000) NULL,
	[first_amplifier_channel] [varchar](1000) NULL,
	[second_amplifier_channel] [varchar](1000) NULL,
	[np_pre_triggerbuffer_length] [varchar](1000) NULL,
	[np_post_triggerbuffer_length] [varchar](1000) NULL,
	[pin_label_input_1] [varchar](1000) NULL,
	[pin_label_input_2] [varchar](1000) NULL,
	[pin_label_input_3] [varchar](1000) NULL,
	[pin_label_input_4] [varchar](1000) NULL,
	[pin_label_input_5] [varchar](1000) NULL,
	[pin_label_input_6] [varchar](1000) NULL,
	[pin_label_input_7] [varchar](1000) NULL,
	[pin_label_input_8] [varchar](1000) NULL,
	[detection_set_name] [varchar](1000) NULL,
	[responsive_therapy_enable] [varchar](1000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_np_parameters] PRIMARY KEY CLUSTERED 
(
	[np_parameter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[np_patients]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[np_patients](
	[np_patient_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[patient_initials] [varchar](1000) NULL,
	[patient_gender] [varchar](1000) NULL,
	[patient_identifier] [varchar](1000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_np_patients] PRIMARY KEY CLUSTERED 
(
	[np_patient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[np_trend_data]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[np_trend_data](
	[np_trend_data_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](100) NOT NULL,
	[file_id] [bigint] NOT NULL,
	[channel_1_ll] [varchar](2000) NULL,
	[channel_1_ll_sample_count] [varchar](2000) NULL,
	[channel_2_ll] [varchar](2000) NULL,
	[channel_2_ll_sample_count] [varchar](2000) NULL,
	[channel_1_area] [varchar](2000) NULL,
	[channel_1_area_sample_count] [varchar](2000) NULL,
	[channel_2_area] [varchar](2000) NULL,
	[channel_2_area_sample_count] [varchar](2000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_np_trend_data] PRIMARY KEY CLUSTERED 
(
	[np_trend_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[pdms_detector_clinical_parameter_settings]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[pdms_detector_clinical_parameter_settings](
	[pdms_detector_clinical_parameter_setting_id] [bigint] IDENTITY(1,1) NOT NULL,
	[detector_nm] [varchar](10) NOT NULL,
	[clinical_parameter_nm] [varchar](1000) NOT NULL,
	[clinical_parameter_val] [decimal](10, 3) NOT NULL,
	[technical_setting_nm1] [varchar](1000) NULL,
	[technical_setting_val1] [decimal](10, 3) NULL,
	[technical_setting_nm2] [varchar](1000) NULL,
	[technical_setting_val2] [decimal](10, 3) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_pdms_detector_clinical_parameter_settings] PRIMARY KEY CLUSTERED 
(
	[pdms_detector_clinical_parameter_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[pdms_detector_parameter_settings]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[pdms_detector_parameter_settings](
	[pdms_detector_parameter_setting_id] [bigint] IDENTITY(1,1) NOT NULL,
	[detector_nm] [varchar](10) NOT NULL,
	[parameter_nm] [varchar](1000) NOT NULL,
	[setting_nm] [varchar](1000) NOT NULL,
	[setting_val] [decimal](10, 3) NULL,
	[is_basic_parameter_flg] [bit] NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_pdms_detector_parameter_settings] PRIMARY KEY CLUSTERED 
(
	[pdms_detector_parameter_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[pdms_file_dates]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[pdms_file_dates](
	[pdms_file_date_id] [int] IDENTITY(1,1) NOT NULL,
	[pdms_patient_at_center_id] [int] NOT NULL,
	[file_nm] [varchar](1000) NOT NULL,
	[file_dts] [datetime] NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_pdms_file_dates] PRIMARY KEY CLUSTERED 
(
	[pdms_file_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[pdms_html_scrapes]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[pdms_html_scrapes](
	[pdms_html_scrape_id] [bigint] IDENTITY(1,1) NOT NULL,
	[load_nm] [varchar](100) NOT NULL,
	[url] [varchar](1000) NOT NULL,
	[html_txt] [varchar](max) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_pdms_html_scrapes] PRIMARY KEY CLUSTERED 
(
	[pdms_html_scrape_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[pies2014_survey_questions]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[pies2014_survey_questions](
	[pies2014_survey_question_id] [int] IDENTITY(1,1) NOT NULL,
	[section_part] [varchar](8) NOT NULL,
	[section_part_dsc] [varchar](5) NOT NULL,
	[question_nmbr] [varchar](5) NOT NULL,
	[section_question_id] [int] NOT NULL,
	[question_txt] [varchar](max) NULL,
	[key_txt] [varchar](1000) NULL,
	[scale_val] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_pies2014_survey_questions] PRIMARY KEY CLUSTERED 
(
	[pies2014_survey_question_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[pies2014_surveys]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[pies2014_surveys](
	[pies_survey_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[survey_administered_dt] [date] NOT NULL,
	[survey_dt] [date] NOT NULL,
	[a1] [int] NULL,
	[a2] [int] NULL,
	[a3] [int] NULL,
	[a4] [int] NULL,
	[a5] [int] NULL,
	[a6] [int] NULL,
	[a7] [int] NULL,
	[a8] [int] NULL,
	[a9] [int] NULL,
	[b10] [int] NULL,
	[b11] [int] NULL,
	[b12] [int] NULL,
	[b13] [int] NULL,
	[b14] [int] NULL,
	[b15] [int] NULL,
	[b16] [int] NULL,
	[c17] [int] NULL,
	[c18] [int] NULL,
	[c19] [int] NULL,
	[c20] [int] NULL,
	[c21] [int] NULL,
	[c22] [int] NULL,
	[c23] [int] NULL,
	[c24] [int] NULL,
	[c25] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_pies2014_surveys] PRIMARY KEY CLUSTERED 
(
	[pies_survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_detection_setting_bandpass_parameters]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_detection_setting_bandpass_parameters](
	[programming_epoch_detection_setting_bandpass_parameter_id] [bigint] IDENTITY(1,1) NOT NULL,
	[programming_epoch_detection_setting_id] [bigint] NOT NULL,
	[pattern] [varchar](1000) NULL,
	[detector] [varchar](1000) NULL,
	[inversion] [varchar](50) NULL,
	[cm_min_frequency_hz] [decimal](10, 2) NULL,
	[cm_min_frequency_shape] [varchar](100) NULL,
	[cm_max_frequency_hz] [decimal](10, 2) NULL,
	[cm_max_frequency_shape] [varchar](100) NULL,
	[cm_min_amplitude_prcnt] [decimal](10, 2) NULL,
	[cm_min_duration_secs] [decimal](10, 2) NULL,
	[min_frequency_window_ms] [int] NULL,
	[min_frequency_cnt_criterion] [int] NULL,
	[min_amplitude_bandpass_hysteresis] [int] NULL,
	[min_amplitude] [int] NULL,
	[max_frequency_min_width_ms] [int] NULL,
	[detection_analysis_window_ms] [int] NULL,
	[bandpass_threshold] [int] NULL,
	[detection_persistence_secs] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_programming_epoch_detection_setting_bandpass_parameters] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_detection_setting_bandpass_parameter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_detection_setting_linelength_parameters]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_detection_setting_linelength_parameters](
	[programming_epoch_detection_setting_linelength_parameter_id] [bigint] IDENTITY(1,1) NOT NULL,
	[programming_epoch_detection_setting_id] [bigint] NOT NULL,
	[pattern] [varchar](1000) NULL,
	[detector] [varchar](1000) NULL,
	[inversion] [varchar](50) NULL,
	[cm_detection_threshold_prcnt] [decimal](10, 1) NULL,
	[cm_short_term_trend_secs] [decimal](10, 3) NULL,
	[cm_long_term_trend_mins] [int] NULL,
	[short_term_window_ms] [int] NULL,
	[threshold_prcnt] [decimal](10, 1) NULL,
	[long_term_window_ms] [int] NULL,
	[sample_cnt] [int] NULL,
	[intersample_interval_ms] [int] NULL,
	[detection_peristence_secs] [int] NULL,
	[threshold_logic] [varchar](50) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_programming_epoch_detection_setting_linelength_parameters] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_detection_setting_linelength_parameter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_detection_settings]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_detection_settings](
	[programming_epoch_detection_setting_id] [bigint] IDENTITY(1,1) NOT NULL,
	[programming_epoch_id] [bigint] NOT NULL,
	[detection_status] [varchar](1000) NULL,
	[detection_set_name] [varchar](1000) NULL,
	[timestamp] [datetime] NULL,
	[first_detector] [varchar](1000) NULL,
	[second_detector] [varchar](1000) NULL,
	[pattern_a] [varchar](1000) NULL,
	[pattern_b] [varchar](1000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_programming_epoch_detection_settings] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_detection_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_montages]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_montages](
	[programming_epoch_montage_id] [bigint] IDENTITY(1,1) NOT NULL,
	[programming_epoch_id] [bigint] NOT NULL,
	[channel1_gain] [varchar](100) NULL,
	[channel1_pos] [varchar](100) NULL,
	[channel1_neg] [varchar](100) NULL,
	[channel2_gain] [varchar](100) NULL,
	[channel2_pos] [varchar](100) NULL,
	[channel2_neg] [varchar](100) NULL,
	[channel3_gain] [varchar](100) NULL,
	[channel3_pos] [varchar](100) NULL,
	[channel3_neg] [varchar](100) NULL,
	[channel4_gain] [varchar](100) NULL,
	[channel4_pos] [varchar](100) NULL,
	[channel4_neg] [varchar](100) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_programming_epoch_montages] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_montage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_responsive_therapies]    Script Date: 10/25/2018 12:53:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_responsive_therapies](
	[programming_epoch_responsive_therapy_id] [bigint] IDENTITY(1,1) NOT NULL,
	[programming_epoch_id] [bigint] NOT NULL,
	[responsive_therapies] [varchar](100) NULL,
	[behavior_therapy1] [varchar](1000) NULL,
	[battery_saver] [int] NULL,
	[therapy_limit_per_day] [int] NULL,
	[therapy_limit_reset_time] [time](7) NULL,
	[adapt_channel] [varchar](100) NULL,
	[synch_channel] [varchar](100) NULL,
	[time_out_secs] [decimal](10, 2) NULL,
	[post_episode_interval] [varchar](100) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_programming_epoch_responsive_therapies] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_responsive_therapy_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_responsive_therapy_settings]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_responsive_therapy_settings](
	[programming_epoch_responsive_therapy_setting_id] [bigint] IDENTITY(1,1) NOT NULL,
	[programming_epoch_responsive_therapy_id] [bigint] NOT NULL,
	[therapy] [varchar](1000) NULL,
	[response_nm] [varchar](1000) NULL,
	[channel1_pos] [varchar](10) NULL,
	[channel1_neg] [varchar](10) NULL,
	[channel2_pos] [varchar](10) NULL,
	[channel2_neg] [varchar](10) NULL,
	[channel3_pos] [varchar](10) NULL,
	[channel3_neg] [varchar](10) NULL,
	[channel4_pos] [varchar](10) NULL,
	[channel4_neg] [varchar](10) NULL,
	[can] [varchar](10) NULL,
	[current_ma] [decimal](10, 1) NULL,
	[frequency_hz] [decimal](10, 1) NULL,
	[frequency_ms] [int] NULL,
	[pw_per_phase_us] [int] NULL,
	[burst_duration_ms] [int] NULL,
	[adaptation] [varchar](100) NULL,
	[synchronization] [varchar](100) NULL,
	[estimated_charge_density_uc_cm_sq] [decimal](10, 1) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_programming_epoch_responsive_therapy_settings] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_responsive_therapy_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epoch_summaries]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epoch_summaries](
	[programming_epoch_summary_id] [bigint] IDENTITY(1,1) NOT NULL,
	[url] [varchar](1000) NOT NULL,
	[patient_id] [int] NOT NULL,
	[programming_dts] [datetime] NOT NULL,
	[epoch_length] [varchar](1000) NOT NULL,
	[electrodes_tx1_b1_changed_flg] [bit] NOT NULL,
	[electrodes_tx1_b1_l1] [varchar](1000) NOT NULL,
	[electrodes_tx1_b1_l2] [varchar](1000) NOT NULL,
	[electrodes_tx1_b1_c] [varchar](1000) NOT NULL,
	[electrodes_tx1_b2_changed_flg] [bit] NOT NULL,
	[electrodes_tx1_b2_l1] [varchar](1000) NOT NULL,
	[electrodes_tx1_b2_l2] [varchar](1000) NOT NULL,
	[electrodes_tx1_b2_c] [varchar](1000) NOT NULL,
	[electrodes_tx2_b1_changed_flg] [bit] NOT NULL,
	[electrodes_tx2_b1_l1] [varchar](1000) NOT NULL,
	[electrodes_tx2_b1_l2] [varchar](1000) NOT NULL,
	[electrodes_tx2_b1_c] [varchar](1000) NOT NULL,
	[electrodes_tx2_b2_changed_flg] [bit] NOT NULL,
	[electrodes_tx2_b2_l1] [varchar](1000) NOT NULL,
	[electrodes_tx2_b2_l2] [varchar](1000) NOT NULL,
	[electrodes_tx2_b2_c] [varchar](1000) NOT NULL,
	[electrodes_tx3_b1_changed_flg] [bit] NOT NULL,
	[electrodes_tx3_b1_l1] [varchar](1000) NOT NULL,
	[electrodes_tx3_b1_l2] [varchar](1000) NOT NULL,
	[electrodes_tx3_b1_c] [varchar](1000) NOT NULL,
	[electrodes_tx3_b2_changed_flg] [bit] NOT NULL,
	[electrodes_tx3_b2_l1] [varchar](1000) NOT NULL,
	[electrodes_tx3_b2_l2] [varchar](1000) NOT NULL,
	[electrodes_tx3_b2_c] [varchar](1000) NOT NULL,
	[electrodes_tx4_b1_changed_flg] [bit] NOT NULL,
	[electrodes_tx4_b1_l1] [varchar](1000) NOT NULL,
	[electrodes_tx4_b1_l2] [varchar](1000) NOT NULL,
	[electrodes_tx4_b1_c] [varchar](1000) NOT NULL,
	[electrodes_tx4_b2_changed_flg] [bit] NOT NULL,
	[electrodes_tx4_b2_l1] [varchar](1000) NOT NULL,
	[electrodes_tx4_b2_l2] [varchar](1000) NOT NULL,
	[electrodes_tx4_b2_c] [varchar](1000) NOT NULL,
	[electrodes_tx5_b1_changed_flg] [bit] NOT NULL,
	[electrodes_tx5_b1_l1] [varchar](1000) NOT NULL,
	[electrodes_tx5_b1_l2] [varchar](1000) NOT NULL,
	[electrodes_tx5_b1_c] [varchar](1000) NOT NULL,
	[electrodes_tx5_b2_changed_flg] [bit] NOT NULL,
	[electrodes_tx5_b2_l1] [varchar](1000) NOT NULL,
	[electrodes_tx5_b2_l2] [varchar](1000) NOT NULL,
	[electrodes_tx5_b2_c] [varchar](1000) NOT NULL,
	[current_tx1_b1_changed_flg] [bit] NOT NULL,
	[current_tx1_b1] [varchar](1000) NOT NULL,
	[current_tx1_b2_changed_flg] [bit] NOT NULL,
	[current_tx1_b2] [varchar](1000) NOT NULL,
	[current_tx2_b1_changed_flg] [bit] NOT NULL,
	[current_tx2_b1] [varchar](1000) NOT NULL,
	[current_tx2_b2_changed_flg] [bit] NOT NULL,
	[current_tx2_b2] [varchar](1000) NOT NULL,
	[current_tx3_b1_changed_flg] [bit] NOT NULL,
	[current_tx3_b1] [varchar](1000) NOT NULL,
	[current_tx3_b2_changed_flg] [bit] NOT NULL,
	[current_tx3_b2] [varchar](1000) NOT NULL,
	[current_tx4_b1_changed_flg] [bit] NOT NULL,
	[current_tx4_b1] [varchar](1000) NOT NULL,
	[current_tx4_b2_changed_flg] [bit] NOT NULL,
	[current_tx4_b2] [varchar](1000) NOT NULL,
	[current_tx5_b1_changed_flg] [bit] NOT NULL,
	[current_tx5_b1] [varchar](1000) NOT NULL,
	[current_tx5_b2_changed_flg] [bit] NOT NULL,
	[current_tx5_b2] [varchar](1000) NOT NULL,
	[frequency_tx1_b1_changed_flg] [bit] NOT NULL,
	[frequency_tx1_b1] [varchar](1000) NOT NULL,
	[frequency_tx1_b2_changed_flg] [bit] NOT NULL,
	[frequency_tx1_b2] [varchar](1000) NOT NULL,
	[frequency_tx2_b1_changed_flg] [bit] NOT NULL,
	[frequency_tx2_b1] [varchar](1000) NOT NULL,
	[frequency_tx2_b2_changed_flg] [bit] NOT NULL,
	[frequency_tx2_b2] [varchar](1000) NOT NULL,
	[frequency_tx3_b1_changed_flg] [bit] NOT NULL,
	[frequency_tx3_b1] [varchar](1000) NOT NULL,
	[frequency_tx3_b2_changed_flg] [bit] NOT NULL,
	[frequency_tx3_b2] [varchar](1000) NOT NULL,
	[frequency_tx4_b1_changed_flg] [bit] NOT NULL,
	[frequency_tx4_b1] [varchar](1000) NOT NULL,
	[frequency_tx4_b2_changed_flg] [bit] NOT NULL,
	[frequency_tx4_b2] [varchar](1000) NOT NULL,
	[frequency_tx5_b1_changed_flg] [bit] NOT NULL,
	[frequency_tx5_b1] [varchar](1000) NOT NULL,
	[frequency_tx5_b2_changed_flg] [bit] NOT NULL,
	[frequency_tx5_b2] [varchar](1000) NOT NULL,
	[pw_per_phase_tx1_b1_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx1_b1] [varchar](1000) NOT NULL,
	[pw_per_phase_tx1_b2_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx1_b2] [varchar](1000) NOT NULL,
	[pw_per_phase_tx2_b1_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx2_b1] [varchar](1000) NOT NULL,
	[pw_per_phase_tx2_b2_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx2_b2] [varchar](1000) NOT NULL,
	[pw_per_phase_tx3_b1_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx3_b1] [varchar](1000) NOT NULL,
	[pw_per_phase_tx3_b2_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx3_b2] [varchar](1000) NOT NULL,
	[pw_per_phase_tx4_b1_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx4_b1] [varchar](1000) NOT NULL,
	[pw_per_phase_tx4_b2_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx4_b2] [varchar](1000) NOT NULL,
	[pw_per_phase_tx5_b1_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx5_b1] [varchar](1000) NOT NULL,
	[pw_per_phase_tx5_b2_changed_flg] [bit] NOT NULL,
	[pw_per_phase_tx5_b2] [varchar](1000) NOT NULL,
	[burst_duration_tx1_b1_changed_flg] [bit] NOT NULL,
	[burst_duration_tx1_b1] [varchar](1000) NOT NULL,
	[burst_duration_tx1_b2_changed_flg] [bit] NOT NULL,
	[burst_duration_tx1_b2] [varchar](1000) NOT NULL,
	[burst_duration_tx2_b1_changed_flg] [bit] NOT NULL,
	[burst_duration_tx2_b1] [varchar](1000) NOT NULL,
	[burst_duration_tx2_b2_changed_flg] [bit] NOT NULL,
	[burst_duration_tx2_b2] [varchar](1000) NOT NULL,
	[burst_duration_tx3_b1_changed_flg] [bit] NOT NULL,
	[burst_duration_tx3_b1] [varchar](1000) NOT NULL,
	[burst_duration_tx3_b2_changed_flg] [bit] NOT NULL,
	[burst_duration_tx3_b2] [varchar](1000) NOT NULL,
	[burst_duration_tx4_b1_changed_flg] [bit] NOT NULL,
	[burst_duration_tx4_b1] [varchar](1000) NOT NULL,
	[burst_duration_tx4_b2_changed_flg] [bit] NOT NULL,
	[burst_duration_tx4_b2] [varchar](1000) NOT NULL,
	[burst_duration_tx5_b1_changed_flg] [bit] NOT NULL,
	[burst_duration_tx5_b1] [varchar](1000) NOT NULL,
	[burst_duration_tx5_b2_changed_flg] [bit] NOT NULL,
	[burst_duration_tx5_b2] [varchar](1000) NOT NULL,
	[charge_density_tx1_b1_changed_flg] [bit] NOT NULL,
	[charge_density_tx1_b1] [varchar](1000) NOT NULL,
	[charge_density_tx1_b2_changed_flg] [bit] NOT NULL,
	[charge_density_tx1_b2] [varchar](1000) NOT NULL,
	[charge_density_tx2_b1_changed_flg] [bit] NOT NULL,
	[charge_density_tx2_b1] [varchar](1000) NOT NULL,
	[charge_density_tx2_b2_changed_flg] [bit] NOT NULL,
	[charge_density_tx2_b2] [varchar](1000) NOT NULL,
	[charge_density_tx3_b1_changed_flg] [bit] NOT NULL,
	[charge_density_tx3_b1] [varchar](1000) NOT NULL,
	[charge_density_tx3_b2_changed_flg] [bit] NOT NULL,
	[charge_density_tx3_b2] [varchar](1000) NOT NULL,
	[charge_density_tx4_b1_changed_flg] [bit] NOT NULL,
	[charge_density_tx4_b1] [varchar](1000) NOT NULL,
	[charge_density_tx4_b2_changed_flg] [bit] NOT NULL,
	[charge_density_tx4_b2] [varchar](1000) NOT NULL,
	[charge_density_tx5_b1_changed_flg] [bit] NOT NULL,
	[charge_density_tx5_b1] [varchar](1000) NOT NULL,
	[charge_density_tx5_b2_changed_flg] [bit] NOT NULL,
	[charge_density_tx5_b2] [varchar](1000) NOT NULL,
	[pattern_a_changed_flg] [bit] NOT NULL,
	[pattern_a1] [varchar](1000) NOT NULL,
	[pattern_a2] [varchar](1000) NOT NULL,
	[pattern_a_logic] [varchar](1000) NOT NULL,
	[pattern_b_changed_flg] [bit] NOT NULL,
	[pattern_b1] [varchar](1000) NOT NULL,
	[pattern_b2] [varchar](1000) NOT NULL,
	[pattern_b_logic] [varchar](1000) NOT NULL,
	[magnets_per_month] [decimal](10, 1) NOT NULL,
	[magnets_total] [int] NOT NULL,
	[saturations_per_month] [decimal](10, 1) NOT NULL,
	[saturations_total] [int] NOT NULL,
	[sat_detector_changed_flg] [bit] NOT NULL,
	[sat_detector1] [varchar](1000) NOT NULL,
	[sat_detector2] [varchar](1000) NOT NULL,
	[long_episodes_per_month] [decimal](10, 1) NOT NULL,
	[long_episodes_total] [int] NOT NULL,
	[long_episode_threshold_changed_flg] [bit] NOT NULL,
	[long_episode_threshold] [varchar](1000) NOT NULL,
	[episodes_per_day] [int] NOT NULL,
	[therapies_per_day] [int] NOT NULL,
	[load_dts] [date] NOT NULL,
 CONSTRAINT [PK_programming_epoch_summaries] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_summary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[programming_epochs]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[programming_epochs](
	[programming_epoch_id] [bigint] IDENTITY(1,1) NOT NULL,
	[url] [varchar](1000) NOT NULL,
	[patient_id] [int] NOT NULL,
	[programmer] [varchar](1000) NULL,
	[programming_dts] [datetime] NULL,
	[report_type] [varchar](1000) NULL,
	[battery_voltage] [decimal](10, 2) NULL,
	[model_nmbr] [varchar](1000) NULL,
	[serial_nmbr] [varchar](1000) NULL,
	[hardware_vers] [varchar](1000) NULL,
	[software_vers] [varchar](1000) NULL,
	[rom_vers] [varchar](1000) NULL,
	[lead1] [varchar](1000) NULL,
	[lead2] [varchar](1000) NULL,
	[load_dts] [date] NOT NULL,
 CONSTRAINT [PK_programming_epochs] PRIMARY KEY CLUSTERED 
(
	[programming_epoch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[remote_monitor_reports]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[remote_monitor_reports](
	[remote_monitor_report_id] [bigint] IDENTITY(1,1) NOT NULL,
	[group_id] [bigint] NULL,
	[lay_nm] [varchar](8000) NULL,
	[dat_nm] [varchar](8000) NULL,
	[name] [varchar](8000) NULL,
	[start_time] [varchar](8000) NULL,
	[duration] [varchar](8000) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_remote_monitor_reports] PRIMARY KEY CLUSTERED 
(
	[remote_monitor_report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[rns_seizure_markings_csv]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[rns_seizure_markings_csv](
	[rns_seizure_markings_csv_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[csv_file_nm] [varchar](1000) NOT NULL,
	[csv_file_line] [bigint] NOT NULL,
	[ieeg_data_id] [bigint] NOT NULL,
	[dat_file_id] [bigint] NOT NULL,
	[sample_nmbr] [bigint] NOT NULL,
	[channel1] [int] NULL,
	[channel2] [int] NULL,
	[channel3] [int] NULL,
	[channel4] [int] NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_rns_seizure_markings_csv] PRIMARY KEY CLUSTERED 
(
	[rns_seizure_markings_csv_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[rns_seizure_markings_edf_edited_annotations]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[rns_seizure_markings_edf_edited_annotations](
	[rns_seizure_markings_edf_edited_annotation_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[csv_file_nm] [varchar](1000) NOT NULL,
	[onset_txt] [varchar](1000) NOT NULL,
	[onset_dec] [decimal](29, 10) NULL,
	[duration_txt] [varchar](1000) NULL,
	[duration_dec] [decimal](29, 10) NULL,
	[annotation] [varchar](1000) NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_rns_seizure_markings_edf_edited_annotations] PRIMARY KEY CLUSTERED 
(
	[rns_seizure_markings_edf_edited_annotation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[rns_seizure_markings_edf_edited_data]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[rns_seizure_markings_edf_edited_data](
	[rns_seizure_markings_edf_edited_data_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[csv_file_nm] [varchar](1000) NOT NULL,
	[csv_file_line] [bigint] NOT NULL,
	[time_txt] [varchar](1000) NOT NULL,
	[time_dec] [decimal](29, 10) NULL,
	[channel1_txt] [varchar](1000) NOT NULL,
	[channel1_dec] [decimal](29, 10) NULL,
	[channel2_txt] [varchar](1000) NOT NULL,
	[channel2_dec] [decimal](29, 10) NULL,
	[channel3_txt] [varchar](1000) NOT NULL,
	[channel3_dec] [decimal](29, 10) NULL,
	[channel4_txt] [varchar](1000) NOT NULL,
	[channel4_dec] [decimal](29, 10) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_rns_seizure_markings_edf_edited_data] PRIMARY KEY CLUSTERED 
(
	[rns_seizure_markings_edf_edited_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [rns_ods].[seizure_surveys]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [rns_ods].[seizure_surveys](
	[seizure_survey_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[survey_administered_dt] [date] NOT NULL,
	[survey_dt] [date] NOT NULL,
	[seizure_type1_dsc] [varchar](1000) NULL,
	[seizure_type1_frequency_dec] [decimal](10, 2) NULL,
	[seizure_type1_frequency_units] [varchar](100) NULL,
	[seizure_type1_duration_dec] [decimal](10, 2) NULL,
	[seizure_type1_duration_units] [varchar](100) NULL,
	[seizure_type1_severity] [int] NULL,
	[seizure_type1_severity_dsc] [varchar](100) NULL,
	[seizure_type1_loss_of_consciousness] [bit] NULL,
	[seizure_type2_dsc] [varchar](1000) NULL,
	[seizure_type2_frequency_dec] [decimal](10, 2) NULL,
	[seizure_type2_frequency_units] [varchar](100) NULL,
	[seizure_type2_duration_dec] [decimal](10, 2) NULL,
	[seizure_type2_duration_units] [varchar](100) NULL,
	[seizure_type2_severity] [int] NULL,
	[seizure_type2_severity_dsc] [varchar](100) NULL,
	[seizure_type2_loss_of_consciousness] [bit] NULL,
	[seizure_type3_dsc] [varchar](1000) NULL,
	[seizure_type3_frequency_dec] [decimal](10, 2) NULL,
	[seizure_type3_frequency_units] [varchar](100) NULL,
	[seizure_type3_duration_dec] [decimal](10, 2) NULL,
	[seizure_type3_duration_units] [varchar](100) NULL,
	[seizure_type3_severity] [int] NULL,
	[seizure_type3_severity_dsc] [varchar](100) NULL,
	[seizure_type3_loss_of_consciousness] [bit] NULL,
	[seizure_type4_dsc] [varchar](1000) NULL,
	[seizure_type4_frequency_dec] [decimal](10, 2) NULL,
	[seizure_type4_frequency_units] [varchar](100) NULL,
	[seizure_type4_duration_dec] [decimal](10, 2) NULL,
	[seizure_type4_duration_units] [varchar](100) NULL,
	[seizure_type4_severity] [int] NULL,
	[seizure_type4_severity_dsc] [varchar](100) NULL,
	[seizure_type4_loss_of_consciousness] [bit] NULL,
	[seizure_type5_dsc] [varchar](1000) NULL,
	[seizure_type5_frequency_dec] [decimal](10, 2) NULL,
	[seizure_type5_frequency_units] [varchar](100) NULL,
	[seizure_type5_duration_dec] [decimal](10, 2) NULL,
	[seizure_type5_duration_units] [varchar](100) NULL,
	[seizure_type5_severity] [int] NULL,
	[seizure_type5_severity_dsc] [varchar](100) NULL,
	[seizure_type5_loss_of_consciousness] [bit] NULL,
	[magnet_swipe_compliance_int] [int] NULL,
	[magnet_swipe_compliance_dsc] [varchar](100) NULL,
	[seizure_diary_compliance_int] [int] NULL,
	[seizure_diary_compliance_dsc] [varchar](100) NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_seizure_surveys] PRIMARY KEY CLUSTERED 
(
	[seizure_survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [xref].[patient_ids]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [xref].[patient_ids](
	[xref_patient_id] [int] IDENTITY(1,1) NOT NULL,
	[rns_deid_id] [varchar](8) NOT NULL,
	[xref_src] [varchar](50) NOT NULL,
	[xref_id] [varchar](1000) NOT NULL,
	[load_dts] [datetime] NOT NULL,
 CONSTRAINT [PK_patient_ids] PRIMARY KEY CLUSTERED 
(
	[xref_patient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [rns_dm].[file_dates]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [rns_dm].[file_dates] as 
select
	par.file_id,
	try_cast(replace(replace(replace(replace(replace(replace(replace(cast(info.layout_file_timestamp_as_local_time as varchar(1000)), 'Mon,', ''), 'Tue,', ''), 'Wed,', ''), 'Thu,', ''), 'Fri,', ''), 'Sat,', ''), 'Sun,','') as date) as file_dt,
	try_cast(replace(replace(replace(replace(replace(replace(replace(cast(info.layout_file_timestamp_as_local_time as varchar(1000)), 'Mon,', ''), 'Tue,', ''), 'Wed,', ''), 'Thu,', ''), 'Fri,', ''), 'Sat,', ''), 'Sun,','') as datetime) as file_dts
from rns_ods.np_parameters par 
join rns_ods.np_fileinfo info
	on par.file_id = info.file_id



GO
/****** Object:  View [rns_dm].[np_parameters]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [rns_dm].[np_parameters] as 
select
	c.[np_comment_id],
	np.rns_deid_id,
	np.[file_id] as lay_file_id,
	df.[file_id] as dat_file_id,
	fd.file_dts,
	f.[path] + '\' as patient_dir,
	replace(f.name, '.lay', '.dat') as datfile_nm, 	
	f.[path] + '\' + replace(f.name, '.lay', '.dat') as datfile_path,
	c.[trigger_reason],	
	np.detection_set_name,
	np.responsive_therapy_enable,
	cm.[channel1],
	cm.[channel2],
	cm.[channel3],
	cm.[channel4],
	cast(replace(replace(replace(cast(amplifier_channel_1_sample_rate as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel1_srate,
	cast(replace(replace(replace(cast(amplifier_channel_2_sample_rate as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel2_srate,
	cast(replace(replace(replace(cast(amplifier_channel_3_sample_rate as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel3_srate,
	cast(replace(replace(replace(cast(amplifier_channel_4_sample_rate as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel4_srate,
	cast(replace(replace(replace(cast(amplifier_channel_1_low_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel1_lp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_2_low_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel2_lp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_3_low_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel3_lp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_4_low_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel4_lp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_1_high_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel1_hp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_2_high_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel2_hp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_3_high_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel3_hp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_4_high_pass_filter_frequency as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel4_hp_frequency,
	cast(replace(replace(replace(cast(amplifier_channel_1_stored_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel1_stored_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_2_stored_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel2_stored_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_3_stored_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel3_stored_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_4_stored_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel4_stored_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_1_realtime_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel1_rt_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_2_realtime_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel2_rt_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_3_realtime_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel3_rt_sample_interval,
	cast(replace(replace(replace(cast(amplifier_channel_4_realtime_ecog_sampling_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as channel4_rt_sample_interval,
	np.first_amplifier_channel as amp1_channel,
	np.second_amplifier_channel as amp2_channel,
	cast(replace(replace(replace(cast(amplifier_1_line_length_trend_window_size as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp1_linelength_window,
	cast(replace(replace(replace(cast(amplifier_2_line_length_trend_window_size as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp2_linelength_window,
	cast(replace(replace(replace(cast(amplifier_1_line_length_trend_is_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp1_linelength_interval,
	cast(replace(replace(replace(cast(amplifier_2_line_length_trend_is_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp2_linelength_interval,
	cast(replace(replace(replace(cast(amplifier_1_area_trend_window_size as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp1_area_window_size,
	cast(replace(replace(replace(cast(amplifier_2_area_trend_window_size as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp2_area_window_size,
	cast(replace(replace(replace(cast(amplifier_1_area_trend_inter_sample_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp1_area_sample_interval,
	cast(replace(replace(replace(cast(amplifier_2_area_trend_inter_sample_interval as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp2_area_sample_interval,
	cast(replace(replace(replace(cast(amplifier_1_line_length_trend_sample_count as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp1_linelength_sample_count,
	cast(replace(replace(replace(cast(amplifier_2_line_length_trend_sample_count as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp2_linelength_sample_count,
	cast(replace(replace(replace(cast(amplifier_1_area_trend_sample_count as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp1_area_sample_count,
	cast(replace(replace(replace(cast(amplifier_2_area_trend_sample_count as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as int) as amp2_area_sample_count,
	cast(replace(replace(replace(cast(np_pre_triggerbuffer_length as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as decimal(10,3)) as pre_trigger_length,
	cast(replace(replace(replace(cast(np_post_triggerbuffer_length as varchar(1000)), 'Hz', ''), 'ms', ''), 'secs', '') as decimal(10,3)) as post_trigger_length,
	np.pin_label_input_1,
	np.pin_label_input_2,
	np.pin_label_input_3,
	np.pin_label_input_4,
	np.pin_label_input_5,
	np.pin_label_input_6,
	np.pin_label_input_7,
	np.pin_label_input_8
from rns_ods.np_parameters np
join rns_ods.file_info fi
	on np.file_id = fi.file_id
join rns_ods.files f
	on fi.file_id = f.file_id
join rns_ods.np_comments c
	on c.file_id = f.file_id
join rns_ods.channel_maps cm
	on cm.file_id = f.file_id
join rns_dm.file_dates fd
	on np.file_id = fd.file_id
join rns_ods.files df
	on replace(f.name, '.lay', '.dat') = df.name







GO
/****** Object:  View [rns_dm].[programming_epoch_responsive_therapy_settings]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[programming_epoch_responsive_therapy_settings] as
select 
	min(programming_epoch_responsive_therapy_setting_id) as programming_epoch_responsive_therapy_setting_id,
	programming_epoch_responsive_therapy_id,
	therapy,
	response_nm,
	channel1_pos,
	channel1_neg,
	channel2_pos,
	channel2_neg,
	channel3_pos,
	channel3_neg,
	channel4_pos,
	channel4_neg,
	can,
	current_ma,
	frequency_hz,
	frequency_ms,
	pw_per_phase_us,
	burst_duration_ms,
	adaptation,
	synchronization,
	estimated_charge_density_uc_cm_sq,
	load_dts
from rns_ods.programming_epoch_responsive_therapy_settings
group by 
	programming_epoch_responsive_therapy_id,
	therapy,
	response_nm,
	channel1_pos,
	channel1_neg,
	channel2_pos,
	channel2_neg,
	channel3_pos,
	channel3_neg,
	channel4_pos,
	channel4_neg,
	can,
	current_ma,
	frequency_hz,
	frequency_ms,
	pw_per_phase_us,
	burst_duration_ms,
	adaptation,
	synchronization,
	estimated_charge_density_uc_cm_sq,
	load_dts
GO
/****** Object:  View [rns_dm].[programming_epochs_flat]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [rns_dm].[programming_epochs_flat]

AS
select
	x.rns_deid_id,
	pe.battery_voltage,
	pe.hardware_vers,
	pe.lead1,
	pe.lead2,
	pe.model_nmbr,
	pe.programmer,
	pe.programming_dts,
	pe.report_type,
	pe.rom_vers,
	pe.serial_nmbr,
	pe.software_vers,
	m.channel1_gain,
	m.channel1_neg,
	m.channel1_pos,
	m.channel2_gain,
	m.channel2_neg,
	m.channel2_pos,
	m.channel3_gain,
	m.channel3_neg,
	m.channel3_pos,
	m.channel4_gain,
	m.channel4_neg,
	m.channel4_pos,
	peds.detection_set_name,
	peds.detection_status,
	peds.first_detector,
	peds.second_detector,
	peds.pattern_a,
	peds.pattern_b,
	--
	bp1.bandpass_threshold as pattern_a1_bp1_bandpass_threshold,
	bp1.cm_max_frequency_hz as pattern_a1_bp1_cm_max_frequency_hz,
	bp1.cm_max_frequency_shape as pattern_a1_bp1_cm_max_frequency_shape,
	bp1.cm_min_amplitude_prcnt as pattern_a1_bp1_cm_min_amplitude_prcnt,
	bp1.cm_min_duration_secs as pattern_a1_bp1_cm_min_duration_secs,
	bp1.cm_min_frequency_hz as pattern_a1_bp1_cm_min_frequency_hz,
	bp1.cm_min_frequency_shape as pattern_a1_bp1_cm_min_frequency_shape,
	bp1.detection_analysis_window_ms as pattern_a1_bp1_detection_analysis_window_ms,
	bp1.detection_persistence_secs as pattern_a1_bp1_detection_persistence_secs,
	bp1.inversion as pattern_a1_bp1_inversion,
	bp1.max_frequency_min_width_ms as pattern_a1_bp1_max_frequency_min_width_ms,
	bp1.min_amplitude as pattern_a1_bp1_min_amplitude,
	bp1.min_amplitude_bandpass_hysteresis as pattern_a1_bp1_min_amplitude_bandpass_hysteresis,
	bp1.min_frequency_cnt_criterion as pattern_a1_bp1_min_frequency_cnt_criterion,
	bp1.min_frequency_window_ms as pattern_a1_bp1_min_frequency_window_ms,
	--
	lp1.cm_detection_threshold_prcnt as pattern_a1_ll1_threshold_prcnt,
	lp1.cm_long_term_trend_mins as pattern_a1_ll1_cm_long_term_trend_mins,
	lp1.cm_short_term_trend_secs as pattern_a1_ll1_cm_short_term_trend_secs,
	lp1.detection_peristence_secs as pattern_a1_ll1_detection_peristence_secs,
	lp1.detector as pattern_a1_ll1_detector,
	--
	bp2.bandpass_threshold as pattern_a2_bp2_bandpass_threshold,
	bp2.cm_max_frequency_hz as pattern_a2_bp2_cm_max_frequency_hz,
	bp2.cm_max_frequency_shape as pattern_a2_bp2_cm_max_frequency_shape,
	bp2.cm_min_amplitude_prcnt as pattern_a2_bp2_cm_min_amplitude_prcnt,
	bp2.cm_min_duration_secs as pattern_a2_bp2_cm_min_duration_secs,
	bp2.cm_min_frequency_hz as pattern_a2_bp2_cm_min_frequency_hz,
	bp2.cm_min_frequency_shape as pattern_a2_bp2_cm_min_frequency_shape,
	bp2.detection_analysis_window_ms as pattern_a2_bp2_detection_analysis_window_ms,
	bp2.detection_persistence_secs as pattern_a2_bp2_detection_persistence_secs,
	bp2.inversion as pattern_a2_bp2_inversion,
	bp2.max_frequency_min_width_ms as pattern_a2_bp2_max_frequency_min_width_ms,
	bp2.min_amplitude as pattern_a2_bp2_min_amplitude,
	bp2.min_amplitude_bandpass_hysteresis as pattern_a2_bp2_min_amplitude_bandpass_hysteresis,
	bp2.min_frequency_cnt_criterion as pattern_a2_bp2_min_frequency_cnt_criterion,
	bp2.min_frequency_window_ms as pattern_a2_bp2_min_frequency_window_ms,
	--
	lp2.cm_detection_threshold_prcnt as pattern_a2_ll2_threshold_prcnt,
	lp2.cm_long_term_trend_mins as pattern_a2_ll2_cm_long_term_trend_mins,
	lp2.cm_short_term_trend_secs as pattern_a2_ll2_cm_short_term_trend_secs,
	lp2.detection_peristence_secs as pattern_a2_ll2_detection_peristence_secs,
	lp2.detector as pattern_a2_ll2_detector,
	--
	bp3.bandpass_threshold as pattern_b1_bp3_bandpass_threshold,
	bp3.cm_max_frequency_hz as pattern_b1_bp3_cm_max_frequency_hz,
	bp3.cm_max_frequency_shape as pattern_b1_bp3_cm_max_frequency_shape,
	bp3.cm_min_amplitude_prcnt as pattern_b1_bp3_cm_min_amplitude_prcnt,
	bp3.cm_min_duration_secs as pattern_b1_bp3_cm_min_duration_secs,
	bp3.cm_min_frequency_hz as pattern_b1_bp3_cm_min_frequency_hz,
	bp3.cm_min_frequency_shape as pattern_b1_bp3_cm_min_frequency_shape,
	bp3.detection_analysis_window_ms as pattern_b1_bp3_detection_analysis_window_ms,
	bp3.detection_persistence_secs as pattern_b1_bp3_detection_persistence_secs,
	bp3.inversion as pattern_b1_bp3_inversion,
	bp3.max_frequency_min_width_ms as pattern_b1_bp3_max_frequency_min_width_ms,
	bp3.min_amplitude as pattern_b1_bp3_min_amplitude,
	bp3.min_amplitude_bandpass_hysteresis as pattern_b1_bp3_min_amplitude_bandpass_hysteresis,
	bp3.min_frequency_cnt_criterion as pattern_b1_bp3_min_frequency_cnt_criterion,
	bp3.min_frequency_window_ms as pattern_b1_bp3_min_frequency_window_ms,
	--
	lp3.cm_detection_threshold_prcnt as pattern_b1_ll3_threshold_prcnt,
	lp3.cm_long_term_trend_mins as pattern_b1_ll3_cm_long_term_trend_mins,
	lp3.cm_short_term_trend_secs as pattern_b1_ll3_cm_short_term_trend_secs,
	lp3.detection_peristence_secs as pattern_b1_ll3_detection_peristence_secs,
	lp3.detector as pattern_b1_ll3_detector,
	--
	bp4.bandpass_threshold as pattern_b2_bp4_bandpass_threshold,
	bp4.cm_max_frequency_hz as pattern_b2_bp4_cm_max_frequency_hz,
	bp4.cm_max_frequency_shape as pattern_b2_bp4_cm_max_frequency_shape,
	bp4.cm_min_amplitude_prcnt as pattern_b2_bp4_cm_min_amplitude_prcnt,
	bp4.cm_min_duration_secs as pattern_b2_bp4_cm_min_duration_secs,
	bp4.cm_min_frequency_hz as pattern_b2_bp4_cm_min_frequency_hz,
	bp4.cm_min_frequency_shape as pattern_b2_bp4_cm_min_frequency_shape,
	bp4.detection_analysis_window_ms as pattern_b2_bp4_detection_analysis_window_ms,
	bp4.detection_persistence_secs as pattern_b2_bp4_detection_persistence_secs,
	bp4.inversion as pattern_b2_bp4_inversion,
	bp4.max_frequency_min_width_ms as pattern_b2_bp4_max_frequency_min_width_ms,
	bp4.min_amplitude as pattern_b2_bp4_min_amplitude,
	bp4.min_amplitude_bandpass_hysteresis as pattern_b2_bp4_min_amplitude_bandpass_hysteresis,
	bp4.min_frequency_cnt_criterion as pattern_b2_bp4_min_frequency_cnt_criterion,
	bp4.min_frequency_window_ms as pattern_b2_bp4_min_frequency_window_ms,
	--
	lp4.cm_detection_threshold_prcnt as pattern_b2_ll4_threshold_prcnt,
	lp4.cm_long_term_trend_mins as pattern_b2_ll4_cm_long_term_trend_mins,
	lp4.cm_short_term_trend_secs as pattern_b2_ll4_cm_short_term_trend_secs,
	lp4.detection_peristence_secs as pattern_b2_ll4_detection_peristence_secs,
	lp4.detector as pattern_b21_ll4_detector,
	--
	perts_t1b1.adaptation as t1b1_adaptation,
	perts_t1b1.burst_duration_ms as t1b1_burst_duration_ms,
	perts_t1b1.can as t1b1_can,
	perts_t1b1.channel1_neg as t1b1_channel1_neg,
	perts_t1b1.channel1_pos as t1b1_channel1_pos,
	perts_t1b1.channel2_neg as t1b1_channel2_neg,
	perts_t1b1.channel2_pos as t1b1_channel2_pos,
	perts_t1b1.channel3_neg as t1b1_channel3_neg,
	perts_t1b1.channel3_pos as t1b1_channel3_pos,
	perts_t1b1.channel4_neg as t1b1_channel4_neg,
	perts_t1b1.channel4_pos as t1b1_channel4_pos,
	perts_t1b1.current_ma as t1b1_current_ma,
	perts_t1b1.estimated_charge_density_uc_cm_sq as t1b1_estimated_charge_density_uc_cm_sq,
	perts_t1b1.frequency_hz as t1b1_frequency_hz,
	perts_t1b1.frequency_ms as t1b1_frequency_ms,
	perts_t1b1.pw_per_phase_us as t1b1_pw_per_phase_us,
	case when perts_t1b1.response_nm is null then 'Off' when perts_t1b1.response_nm in ('Pattern A', 'Pattern B') then perts_t1b1.response_nm else 'Any Detection' end as t1b1_response_nm,
	perts_t1b1.synchronization as t1b1_synchronization,
	--
	perts_t1b2.adaptation as t1b2_adaptation,
	perts_t1b2.burst_duration_ms as t1b2_burst_duration_ms,
	perts_t1b2.can as t1b2_can,
	perts_t1b2.channel1_neg as t1b2_channel1_neg,
	perts_t1b2.channel1_pos as t1b2_channel1_pos,
	perts_t1b2.channel2_neg as t1b2_channel2_neg,
	perts_t1b2.channel2_pos as t1b2_channel2_pos,
	perts_t1b2.channel3_neg as t1b2_channel3_neg,
	perts_t1b2.channel3_pos as t1b2_channel3_pos,
	perts_t1b2.channel4_neg as t1b2_channel4_neg,
	perts_t1b2.channel4_pos as t1b2_channel4_pos,
	perts_t1b2.current_ma as t1b2_current_ma,
	perts_t1b2.estimated_charge_density_uc_cm_sq as t1b2_estimated_charge_density_uc_cm_sq,
	perts_t1b2.frequency_hz as t1b2_frequency_hz,
	perts_t1b2.frequency_ms as t1b2_frequency_ms,
	perts_t1b2.pw_per_phase_us as t1b2_pw_per_phase_us,
	case when perts_t1b2.response_nm is null then 'Off' when perts_t1b2.response_nm in ('Pattern A', 'Pattern B') then perts_t1b2.response_nm else 'Any Detection' end as t1b2_response_nm,
	perts_t1b2.synchronization as t1b2_synchronization,
	--
	perts_t2b1.adaptation as t2b1_adaptation,
	perts_t2b1.burst_duration_ms as t2b1_burst_duration_ms,
	perts_t2b1.can as t2b1_can,
	perts_t2b1.channel1_neg as t2b1_channel1_neg,
	perts_t2b1.channel1_pos as t2b1_channel1_pos,
	perts_t2b1.channel2_neg as t2b1_channel2_neg,
	perts_t2b1.channel2_pos as t2b1_channel2_pos,
	perts_t2b1.channel3_neg as t2b1_channel3_neg,
	perts_t2b1.channel3_pos as t2b1_channel3_pos,
	perts_t2b1.channel4_neg as t2b1_channel4_neg,
	perts_t2b1.channel4_pos as t2b1_channel4_pos,
	perts_t2b1.current_ma as t2b1_current_ma,
	perts_t2b1.estimated_charge_density_uc_cm_sq as t2b1_estimated_charge_density_uc_cm_sq,
	perts_t2b1.frequency_hz as t2b1_frequency_hz,
	perts_t2b1.frequency_ms as t2b1_frequency_ms,
	perts_t2b1.pw_per_phase_us as t2b1_pw_per_phase_us,
	case when perts_t2b1.response_nm is null then 'Off' when perts_t2b1.response_nm in ('Pattern A', 'Pattern B') then perts_t2b1.response_nm else 'Any Detection' end as t2b1_response_nm,
	perts_t2b1.synchronization as t2b1_synchronization,
	--
	perts_t2b2.adaptation as t2b2_adaptation,
	perts_t2b2.burst_duration_ms as t2b2_burst_duration_ms,
	perts_t2b2.can as t2b2_can,
	perts_t2b2.channel1_neg as t2b2_channel1_neg,
	perts_t2b2.channel1_pos as t2b2_channel1_pos,
	perts_t2b2.channel2_neg as t2b2_channel2_neg,
	perts_t2b2.channel2_pos as t2b2_channel2_pos,
	perts_t2b2.channel3_neg as t2b2_channel3_neg,
	perts_t2b2.channel3_pos as t2b2_channel3_pos,
	perts_t2b2.channel4_neg as t2b2_channel4_neg,
	perts_t2b2.channel4_pos as t2b2_channel4_pos,
	perts_t2b2.current_ma as t2b2_current_ma,
	perts_t2b2.estimated_charge_density_uc_cm_sq as t2b2_estimated_charge_density_uc_cm_sq,
	perts_t2b2.frequency_hz as t2b2_frequency_hz,
	perts_t2b2.frequency_ms as t2b2_frequency_ms,
	perts_t2b2.pw_per_phase_us as t2b2_pw_per_phase_us,
	case when perts_t2b2.response_nm is null then 'Off' when perts_t2b2.response_nm in ('Pattern A', 'Pattern B') then perts_t2b2.response_nm else 'Any Detection' end as t2b2_response_nm,
	perts_t2b2.synchronization as t2b2_synchronization,
	--
	perts_t3b1.adaptation as t3b1_adaptation,
	perts_t3b1.burst_duration_ms as t3b1_burst_duration_ms,
	perts_t3b1.can as t3b1_can,
	perts_t3b1.channel1_neg as t3b1_channel1_neg,
	perts_t3b1.channel1_pos as t3b1_channel1_pos,
	perts_t3b1.channel2_neg as t3b1_channel2_neg,
	perts_t3b1.channel2_pos as t3b1_channel2_pos,
	perts_t3b1.channel3_neg as t3b1_channel3_neg,
	perts_t3b1.channel3_pos as t3b1_channel3_pos,
	perts_t3b1.channel4_neg as t3b1_channel4_neg,
	perts_t3b1.channel4_pos as t3b1_channel4_pos,
	perts_t3b1.current_ma as t3b1_current_ma,
	perts_t3b1.estimated_charge_density_uc_cm_sq as t3b1_estimated_charge_density_uc_cm_sq,
	perts_t3b1.frequency_hz as t3b1_frequency_hz,
	perts_t3b1.frequency_ms as t3b1_frequency_ms,
	perts_t3b1.pw_per_phase_us as t3b1_pw_per_phase_us,
	case when perts_t3b1.response_nm is null then 'Off' when perts_t3b1.response_nm in ('Pattern A', 'Pattern B') then perts_t3b1.response_nm else 'Any Detection' end as t3b1_response_nm,
	perts_t3b1.synchronization as t3b1_synchronization,
	--
	perts_t3b2.adaptation as t3b2_adaptation,
	perts_t3b2.burst_duration_ms as t3b2_burst_duration_ms,
	perts_t3b2.can as t3b2_can,
	perts_t3b2.channel1_neg as t3b2_channel1_neg,
	perts_t3b2.channel1_pos as t3b2_channel1_pos,
	perts_t3b2.channel2_neg as t3b2_channel2_neg,
	perts_t3b2.channel2_pos as t3b2_channel2_pos,
	perts_t3b2.channel3_neg as t3b2_channel3_neg,
	perts_t3b2.channel3_pos as t3b2_channel3_pos,
	perts_t3b2.channel4_neg as t3b2_channel4_neg,
	perts_t3b2.channel4_pos as t3b2_channel4_pos,
	perts_t3b2.current_ma as t3b2_current_ma,
	perts_t3b2.estimated_charge_density_uc_cm_sq as t3b2_estimated_charge_density_uc_cm_sq,
	perts_t3b2.frequency_hz as t3b2_frequency_hz,
	perts_t3b2.frequency_ms as t3b2_frequency_ms,
	perts_t3b2.pw_per_phase_us as t3b2_pw_per_phase_us,
	case when perts_t3b2.response_nm is null then 'Off' when perts_t3b2.response_nm in ('Pattern A', 'Pattern B') then perts_t3b2.response_nm else 'Any Detection' end as t3b2_response_nm,
	perts_t3b2.synchronization as t3b2_synchronization,
	--
	perts_t4b1.adaptation as t4b1_adaptation,
	perts_t4b1.burst_duration_ms as t4b1_burst_duration_ms,
	perts_t4b1.can as t4b1_can,
	perts_t4b1.channel1_neg as t4b1_channel1_neg,
	perts_t4b1.channel1_pos as t4b1_channel1_pos,
	perts_t4b1.channel2_neg as t4b1_channel2_neg,
	perts_t4b1.channel2_pos as t4b1_channel2_pos,
	perts_t4b1.channel3_neg as t4b1_channel3_neg,
	perts_t4b1.channel3_pos as t4b1_channel3_pos,
	perts_t4b1.channel4_neg as t4b1_channel4_neg,
	perts_t4b1.channel4_pos as t4b1_channel4_pos,
	perts_t4b1.current_ma as t4b1_current_ma,
	perts_t4b1.estimated_charge_density_uc_cm_sq as t4b1_estimated_charge_density_uc_cm_sq,
	perts_t4b1.frequency_hz as t4b1_frequency_hz,
	perts_t4b1.frequency_ms as t4b1_frequency_ms,
	perts_t4b1.pw_per_phase_us as t4b1_pw_per_phase_us,
	case when perts_t4b1.response_nm is null then 'Off' when perts_t4b1.response_nm in ('Pattern A', 'Pattern B') then perts_t4b1.response_nm else 'Any Detection' end as t4b1_response_nm,
	perts_t4b1.synchronization as t4b1_synchronization,
	--
	perts_t4b2.adaptation as t4b2_adaptation,
	perts_t4b2.burst_duration_ms as t4b2_burst_duration_ms,
	perts_t4b2.can as t4b2_can,
	perts_t4b2.channel1_neg as t4b2_channel1_neg,
	perts_t4b2.channel1_pos as t4b2_channel1_pos,
	perts_t4b2.channel2_neg as t4b2_channel2_neg,
	perts_t4b2.channel2_pos as t4b2_channel2_pos,
	perts_t4b2.channel3_neg as t4b2_channel3_neg,
	perts_t4b2.channel3_pos as t4b2_channel3_pos,
	perts_t4b2.channel4_neg as t4b2_channel4_neg,
	perts_t4b2.channel4_pos as t4b2_channel4_pos,
	perts_t4b2.current_ma as t4b2_current_ma,
	perts_t4b2.estimated_charge_density_uc_cm_sq as t4b2_estimated_charge_density_uc_cm_sq,
	perts_t4b2.frequency_hz as t4b2_frequency_hz,
	perts_t4b2.frequency_ms as t4b2_frequency_ms,
	perts_t4b2.pw_per_phase_us as t4b2_pw_per_phase_us,
	case when perts_t4b2.response_nm is null then 'Off' when perts_t4b2.response_nm in ('Pattern A', 'Pattern B') then perts_t4b2.response_nm else 'Any Detection' end as t4b2_response_nm,
	perts_t4b2.synchronization as t4b2_synchronization,
	--
	perts_t5b1.adaptation as t5b1_adaptation,
	perts_t5b1.burst_duration_ms as t5b1_burst_duration_ms,
	perts_t5b1.can as t5b1_can,
	perts_t5b1.channel1_neg as t5b1_channel1_neg,
	perts_t5b1.channel1_pos as t5b1_channel1_pos,
	perts_t5b1.channel2_neg as t5b1_channel2_neg,
	perts_t5b1.channel2_pos as t5b1_channel2_pos,
	perts_t5b1.channel3_neg as t5b1_channel3_neg,
	perts_t5b1.channel3_pos as t5b1_channel3_pos,
	perts_t5b1.channel4_neg as t5b1_channel4_neg,
	perts_t5b1.channel4_pos as t5b1_channel4_pos,
	perts_t5b1.current_ma as t5b1_current_ma,
	perts_t5b1.estimated_charge_density_uc_cm_sq as t5b1_estimated_charge_density_uc_cm_sq,
	perts_t5b1.frequency_hz as t5b1_frequency_hz,
	perts_t5b1.frequency_ms as t5b1_frequency_ms,
	perts_t5b1.pw_per_phase_us as t5b1_pw_per_phase_us,
	case when perts_t5b1.response_nm is null then 'Off' when perts_t5b1.response_nm in ('Pattern A', 'Pattern B') then perts_t5b1.response_nm else 'Any Detection' end as t5b1_response_nm,
	perts_t5b1.synchronization as t5b1_synchronization,
	--
	perts_t5b2.adaptation as t5b2_adaptation,
	perts_t5b2.burst_duration_ms as t5b2_burst_duration_ms,
	perts_t5b2.can as t5b2_can,
	perts_t5b2.channel1_neg as t5b2_channel1_neg,
	perts_t5b2.channel1_pos as t5b2_channel1_pos,
	perts_t5b2.channel2_neg as t5b2_channel2_neg,
	perts_t5b2.channel2_pos as t5b2_channel2_pos,
	perts_t5b2.channel3_neg as t5b2_channel3_neg,
	perts_t5b2.channel3_pos as t5b2_channel3_pos,
	perts_t5b2.channel4_neg as t5b2_channel4_neg,
	perts_t5b2.channel4_pos as t5b2_channel4_pos,
	perts_t5b2.current_ma as t5b2_current_ma,
	perts_t5b2.estimated_charge_density_uc_cm_sq as t5b2_estimated_charge_density_uc_cm_sq,
	perts_t5b2.frequency_hz as t5b2_frequency_hz,
	perts_t5b2.frequency_ms as t5b2_frequency_ms,
	perts_t5b2.pw_per_phase_us as t5b2_pw_per_phase_us,
	case when perts_t5b2.response_nm is null then 'Off' when perts_t5b2.response_nm in ('Pattern A', 'Pattern B') then perts_t5b2.response_nm else 'Any Detection' end as t5b2_response_nm,
	perts_t5b2.synchronization as t5b2_synchronization,
	--
	pes.long_episode_threshold,
	pes.sat_detector1,
	pes.sat_detector2,
	--
	pes.epoch_length,
	pes.episodes_per_day,
	pes.therapies_per_day,
	pes.long_episodes_per_month,
	pes.long_episodes_total,
	pes.saturations_per_month,
	pes.saturations_total,
	pes.magnets_per_month,
	pes.magnets_total
from rns_ods.programming_epochs pe
join xref.patient_ids x
	on x.xref_id = pe.patient_id
		and x.xref_src = 'pdms_patient_at_center_id'
join rns_ods.programming_epoch_montages m
	on pe.programming_epoch_id = m.programming_epoch_id
join rns_ods.programming_epoch_detection_settings peds
	on m.programming_epoch_id = peds.programming_epoch_id
--
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp1
	on bp1.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp1.pattern = 'Pattern A' and bp1.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp2
	on bp2.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp2.pattern = 'Pattern A' and bp2.detector = 'Second Detector'
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp3
	on bp3.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp3.pattern = 'Pattern B' and bp3.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp4
	on bp4.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp4.pattern = 'Pattern B' and bp4.detector = 'Second Detector'
--
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp1
	on lp1.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp1.pattern = 'Pattern A' and lp1.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp2
	on lp2.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp2.pattern = 'Pattern A' and lp2.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp3
	on lp3.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp3.pattern = 'Pattern A' and lp3.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp4
	on lp4.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp4.pattern = 'Pattern A' and lp4.detector = 'First Detector'
--
left join rns_ods.programming_epoch_responsive_therapies pert
	on pe.programming_epoch_id = pert.programming_epoch_id
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t1b1
	on pert.programming_epoch_responsive_therapy_id = perts_t1b1.programming_epoch_responsive_therapy_id
		and perts_t1b1.therapy like 'Therapy #1%' and perts_t1b1.response_nm in ('Burst #1', 'Pattern A')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t1b2
	on pert.programming_epoch_responsive_therapy_id = perts_t1b2.programming_epoch_responsive_therapy_id
		and perts_t1b2.therapy like 'Therapy #1%' and perts_t1b2.response_nm in ('Burst #2', 'Pattern B')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t2b1
	on pert.programming_epoch_responsive_therapy_id = perts_t2b1.programming_epoch_responsive_therapy_id
		and perts_t2b1.therapy like 'Therapy #2%' and perts_t2b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t2b2
	on pert.programming_epoch_responsive_therapy_id = perts_t2b2.programming_epoch_responsive_therapy_id
		and perts_t2b2.therapy like 'Therapy #2%' and perts_t2b2.response_nm in ('Burst #2')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t3b1
	on pert.programming_epoch_responsive_therapy_id = perts_t3b1.programming_epoch_responsive_therapy_id
		and perts_t3b1.therapy like 'Therapy #3%' and perts_t3b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t3b2
	on pert.programming_epoch_responsive_therapy_id = perts_t2b2.programming_epoch_responsive_therapy_id
		and perts_t2b2.therapy like 'Therapy #3%' and perts_t2b2.response_nm in ('Burst #2')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t4b1
	on pert.programming_epoch_responsive_therapy_id = perts_t4b1.programming_epoch_responsive_therapy_id
		and perts_t4b1.therapy like 'Therapy #4%' and perts_t4b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t4b2
	on pert.programming_epoch_responsive_therapy_id = perts_t4b2.programming_epoch_responsive_therapy_id
		and perts_t4b2.therapy like 'Therapy #4%' and perts_t4b2.response_nm in ('Burst #2')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t5b1
	on pert.programming_epoch_responsive_therapy_id = perts_t5b1.programming_epoch_responsive_therapy_id
		and perts_t5b1.therapy like 'Therapy #5%' and perts_t5b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t5b2
	on pert.programming_epoch_responsive_therapy_id = perts_t5b2.programming_epoch_responsive_therapy_id
		and perts_t5b2.therapy like 'Therapy #5%' and perts_t5b2.response_nm in ('Burst #2')
left join rns_ods.programming_epoch_summaries pes
	on pes.patient_id = pe.patient_id
		and pes.programming_dts = pe.programming_dts





GO
/****** Object:  View [rns_dm].[sm_programming_epoch_parameter_changes]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[sm_programming_epoch_parameter_changes] as
select
	spe.rns_deid_id,
	spe.programming_dt,
	--A1
	pef_curr.pattern_a1_bp1_bandpass_threshold - pef_prev.pattern_a1_bp1_bandpass_threshold as pattern_a1_bp1_bandpass_threshold,
	pef_curr.pattern_a1_bp1_cm_max_frequency_hz - pef_prev.pattern_a1_bp1_cm_max_frequency_hz as pattern_a1_bp1_cm_max_frequency_hz,
	pef_curr.pattern_a1_bp1_cm_min_amplitude_prcnt - pef_prev.pattern_a1_bp1_cm_min_amplitude_prcnt as pattern_a1_bp1_cm_min_amplitude_prcnt,
	pef_curr.pattern_a1_bp1_cm_min_duration_secs - pef_prev.pattern_a1_bp1_cm_min_duration_secs as pattern_a1_bp1_cm_min_duration_secs,
	pef_curr.pattern_a1_bp1_cm_min_frequency_hz - pef_prev.pattern_a1_bp1_cm_min_frequency_hz as pattern_a1_bp1_cm_min_frequency_hz,
	--
	pef_curr.pattern_a1_ll1_threshold_prcnt - pef_prev.pattern_a1_ll1_threshold_prcnt as pattern_a1_ll1_threshold_prcnt,
	pef_curr.pattern_a1_ll1_cm_long_term_trend_mins - pef_prev.pattern_a1_ll1_cm_long_term_trend_mins as pattern_a1_ll1_cm_long_term_trend_mins,
	pef_curr.pattern_a1_ll1_cm_short_term_trend_secs - pef_prev.pattern_a1_ll1_cm_short_term_trend_secs as pattern_a1_ll1_cm_short_term_trend_secs,
	--A2
	pef_curr.pattern_a2_bp2_bandpass_threshold - pef_prev.pattern_a2_bp2_bandpass_threshold as pattern_a2_bp2_bandpass_threshold,
	pef_curr.pattern_a2_bp2_cm_max_frequency_hz - pef_prev.pattern_a2_bp2_cm_max_frequency_hz as pattern_a2_bp2_cm_max_frequency_hz,
	pef_curr.pattern_a2_bp2_cm_min_amplitude_prcnt - pef_prev.pattern_a2_bp2_cm_min_amplitude_prcnt as pattern_a2_bp2_cm_min_amplitude_prcnt,
	pef_curr.pattern_a2_bp2_cm_min_duration_secs - pef_prev.pattern_a2_bp2_cm_min_duration_secs as pattern_a2_bp2_cm_min_duration_secs,
	pef_curr.pattern_a2_bp2_cm_min_frequency_hz - pef_prev.pattern_a2_bp2_cm_min_frequency_hz as pattern_a2_bp2_cm_min_frequency_hz,
	--
	pef_curr.pattern_a2_ll2_threshold_prcnt - pef_prev.pattern_a2_ll2_threshold_prcnt as pattern_a2_ll2_threshold_prcnt,
	pef_curr.pattern_a2_ll2_cm_long_term_trend_mins - pef_prev.pattern_a2_ll2_cm_long_term_trend_mins as pattern_a2_ll2_cm_long_term_trend_mins,
	pef_curr.pattern_a2_ll2_cm_short_term_trend_secs - pef_prev.pattern_a2_ll2_cm_short_term_trend_secs as pattern_a2_ll2_cm_short_term_trend_secs,
	--B1
	pef_curr.pattern_b1_bp3_bandpass_threshold - pef_prev.pattern_b1_bp3_bandpass_threshold as pattern_b1_bp3_bandpass_threshold,
	pef_curr.pattern_b1_bp3_cm_max_frequency_hz - pef_prev.pattern_b1_bp3_cm_max_frequency_hz as pattern_b1_bp3_cm_max_frequency_hz,
	pef_curr.pattern_b1_bp3_cm_min_amplitude_prcnt - pef_prev.pattern_b1_bp3_cm_min_amplitude_prcnt as pattern_b1_bp3_cm_min_amplitude_prcnt,
	pef_curr.pattern_b1_bp3_cm_min_duration_secs - pef_prev.pattern_b1_bp3_cm_min_duration_secs as pattern_b1_bp3_cm_min_duration_secs,
	pef_curr.pattern_b1_bp3_cm_min_frequency_hz - pef_prev.pattern_b1_bp3_cm_min_frequency_hz as pattern_b1_bp3_cm_min_frequency_hz,
	--
	pef_curr.pattern_b1_ll3_threshold_prcnt - pef_prev.pattern_b1_ll3_threshold_prcnt as pattern_b1_ll3_threshold_prcnt,
	pef_curr.pattern_b1_ll3_cm_long_term_trend_mins - pef_prev.pattern_b1_ll3_cm_long_term_trend_mins as pattern_b1_ll3_cm_long_term_trend_mins,
	pef_curr.pattern_b1_ll3_cm_short_term_trend_secs - pef_prev.pattern_b1_ll3_cm_short_term_trend_secs as pattern_b1_ll3_cm_short_term_trend_secs,
	--B2
	pef_curr.pattern_b2_bp4_bandpass_threshold - pef_prev.pattern_b2_bp4_bandpass_threshold as pattern_b2_bp4_bandpass_threshold,
	pef_curr.pattern_b2_bp4_cm_max_frequency_hz - pef_prev.pattern_b2_bp4_cm_max_frequency_hz as pattern_b2_bp4_cm_max_frequency_hz,
	pef_curr.pattern_b2_bp4_cm_min_amplitude_prcnt - pef_prev.pattern_b2_bp4_cm_min_amplitude_prcnt as pattern_b2_bp4_cm_min_amplitude_prcnt,
	pef_curr.pattern_b2_bp4_cm_min_duration_secs - pef_prev.pattern_b2_bp4_cm_min_duration_secs as pattern_b2_bp4_cm_min_duration_secs,
	pef_curr.pattern_b2_bp4_cm_min_frequency_hz - pef_prev.pattern_b2_bp4_cm_min_frequency_hz as pattern_b2_bp4_cm_min_frequency_hz,
	--
	pef_curr.pattern_b2_ll4_threshold_prcnt - pef_prev.pattern_b2_ll4_threshold_prcnt as pattern_b2_ll4_threshold_prcnt,
	pef_curr.pattern_b2_ll4_cm_long_term_trend_mins - pef_prev.pattern_b2_ll4_cm_long_term_trend_mins as pattern_b2_ll4_cm_long_term_trend_mins,
	pef_curr.pattern_b2_ll4_cm_short_term_trend_secs - pef_prev.pattern_b2_ll4_cm_short_term_trend_secs as pattern_b2_ll4_cm_short_term_trend_secs,
	--T1
	pef_curr.t1b1_estimated_charge_density_uc_cm_sq - pef_prev.t1b1_estimated_charge_density_uc_cm_sq as t1b1_estimated_charge_density_uc_cm_sq,
	pef_curr.t1b1_burst_duration_ms - pef_prev.t1b1_burst_duration_ms as t1b1_burst_duration_ms,
	pef_curr.t1b2_estimated_charge_density_uc_cm_sq - pef_prev.t1b2_estimated_charge_density_uc_cm_sq as t1b2_estimated_charge_density_uc_cm_sq,
	pef_curr.t1b2_burst_duration_ms - pef_prev.t1b2_burst_duration_ms as t1b2_burst_duration_ms,
	--T2
	pef_curr.t2b1_estimated_charge_density_uc_cm_sq - pef_prev.t2b1_estimated_charge_density_uc_cm_sq as t2b1_estimated_charge_density_uc_cm_sq,
	pef_curr.t2b1_burst_duration_ms - pef_prev.t2b1_burst_duration_ms as t2b1_burst_duration_ms,
	pef_curr.t2b2_estimated_charge_density_uc_cm_sq - pef_prev.t2b2_estimated_charge_density_uc_cm_sq as t2b2_estimated_charge_density_uc_cm_sq,
	pef_curr.t2b2_burst_duration_ms - pef_prev.t2b2_burst_duration_ms as t2b2_burst_duration_ms,
	--T3
	pef_curr.t3b1_estimated_charge_density_uc_cm_sq - pef_prev.t3b1_estimated_charge_density_uc_cm_sq as t3b1_estimated_charge_density_uc_cm_sq,
	pef_curr.t3b1_burst_duration_ms - pef_prev.t3b1_burst_duration_ms as t3b1_burst_duration_ms,
	pef_curr.t3b2_estimated_charge_density_uc_cm_sq - pef_prev.t3b2_estimated_charge_density_uc_cm_sq as t3b2_estimated_charge_density_uc_cm_sq,
	pef_curr.t3b2_burst_duration_ms - pef_prev.t3b2_burst_duration_ms as t3b2_burst_duration_ms,
	--T4
	pef_curr.t4b1_estimated_charge_density_uc_cm_sq - pef_prev.t4b1_estimated_charge_density_uc_cm_sq as t4b1_estimated_charge_density_uc_cm_sq,
	pef_curr.t4b1_burst_duration_ms - pef_prev.t4b1_burst_duration_ms as t4b1_burst_duration_ms,
	pef_curr.t4b2_estimated_charge_density_uc_cm_sq - pef_prev.t4b2_estimated_charge_density_uc_cm_sq as t4b2_estimated_charge_density_uc_cm_sq,
	pef_curr.t4b2_burst_duration_ms - pef_prev.t4b2_burst_duration_ms as t4b2_burst_duration_ms,
	--T5
	pef_curr.t5b1_estimated_charge_density_uc_cm_sq - pef_prev.t5b1_estimated_charge_density_uc_cm_sq as t5b1_estimated_charge_density_uc_cm_sq,
	pef_curr.t5b1_burst_duration_ms - pef_prev.t5b1_burst_duration_ms as t5b1_burst_duration_ms,
	pef_curr.t5b2_estimated_charge_density_uc_cm_sq - pef_prev.t5b2_estimated_charge_density_uc_cm_sq as t5b2_estimated_charge_density_uc_cm_sq,
	pef_curr.t5b2_burst_duration_ms - pef_prev.t5b2_burst_duration_ms as t5b2_burst_duration_ms
from rns_dm.sm_programming_epochs spe
left join rns_dm.programming_epochs_flat pef_curr
	on spe.rns_deid_id = pef_curr.rns_deid_id
		and spe.programming_dts = pef_curr.programming_dts
left join rns_dm.programming_epochs_flat pef_prev
	on spe.rns_deid_id = pef_prev.rns_deid_id
		and spe.prev_programming_dts = pef_prev.programming_dts
GO
/****** Object:  View [rns_dm].[sm_programming_epoch_change_summaries]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [rns_dm].[sm_programming_epoch_change_summaries] as
select
	rns_deid_id,
	programming_dt,
	detector_chng,
	case
		when detector_chng = 'incr sensitivity' then 1
		when detector_chng = 'decr sensitivity' then -1
		--when detector_chng = 'no change' then 0
	end as detector_chng_cd,
	stimulation_chng,
	case
		when stimulation_chng = 'incr stimulation' then 1
		when stimulation_chng = 'decr stimulation' then -1
		--when stimulation_chng = 'no change' then 0
	end as stimulation_chng_cd
from
(
	select
		rns_deid_id,
		programming_dt,
		case
			when 
				--A1 > means "increased" and < means "decreased"
				pattern_a1_bp1_bandpass_threshold > 0
				or pattern_a1_bp1_cm_max_frequency_hz < 0
				or pattern_a1_bp1_cm_min_amplitude_prcnt > 0
				or pattern_a1_bp1_cm_min_duration_secs > 0
				or pattern_a1_bp1_cm_min_frequency_hz > 0
				--
				or pattern_a1_ll1_threshold_prcnt > 0
				or pattern_a1_ll1_cm_long_term_trend_mins > 0
				or pattern_a1_ll1_cm_short_term_trend_secs > 0
				--A2
				or pattern_a2_bp2_bandpass_threshold > 0
				or pattern_a2_bp2_cm_max_frequency_hz < 0
				or pattern_a2_bp2_cm_min_amplitude_prcnt > 0
				or pattern_a2_bp2_cm_min_duration_secs > 0
				or pattern_a2_bp2_cm_min_frequency_hz > 0
				--
				or pattern_a2_ll2_threshold_prcnt > 0
				or pattern_a2_ll2_cm_long_term_trend_mins > 0
				or pattern_a2_ll2_cm_short_term_trend_secs > 0
				--B1
				or pattern_b1_bp3_bandpass_threshold > 0
				or pattern_b1_bp3_cm_max_frequency_hz < 0
				or pattern_b1_bp3_cm_min_amplitude_prcnt > 0
				or pattern_b1_bp3_cm_min_duration_secs > 0
				or pattern_b1_bp3_cm_min_frequency_hz > 0
				--
				or pattern_b1_ll3_threshold_prcnt > 0
				or pattern_b1_ll3_cm_long_term_trend_mins > 0
				or pattern_b1_ll3_cm_short_term_trend_secs > 0
				--B2
				or pattern_b2_bp4_bandpass_threshold > 0
				or pattern_b2_bp4_cm_max_frequency_hz < 0
				or pattern_b2_bp4_cm_min_amplitude_prcnt > 0
				or pattern_b2_bp4_cm_min_duration_secs > 0
				or pattern_b2_bp4_cm_min_frequency_hz > 0
				--
				or pattern_b2_ll4_threshold_prcnt > 0
				or pattern_b2_ll4_cm_long_term_trend_mins > 0
				or pattern_b2_ll4_cm_short_term_trend_secs > 0
			then 'decr sensitivity' -- i.e. more specific
			when 
				--A1 > means "increased" and < means "decreased"
				pattern_a1_bp1_bandpass_threshold < 0
				or pattern_a1_bp1_cm_max_frequency_hz > 0
				or pattern_a1_bp1_cm_min_amplitude_prcnt < 0
				or pattern_a1_bp1_cm_min_duration_secs < 0
				or pattern_a1_bp1_cm_min_frequency_hz < 0
				--
				or pattern_a1_ll1_threshold_prcnt < 0
				or pattern_a1_ll1_cm_long_term_trend_mins < 0
				or pattern_a1_ll1_cm_short_term_trend_secs < 0
				--A2
				or pattern_a2_bp2_bandpass_threshold < 0
				or pattern_a2_bp2_cm_max_frequency_hz > 0
				or pattern_a2_bp2_cm_min_amplitude_prcnt < 0
				or pattern_a2_bp2_cm_min_duration_secs < 0
				or pattern_a2_bp2_cm_min_frequency_hz < 0
				--
				or pattern_a2_ll2_threshold_prcnt < 0
				or pattern_a2_ll2_cm_long_term_trend_mins < 0
				or pattern_a2_ll2_cm_short_term_trend_secs < 0
				--B1
				or pattern_b1_bp3_bandpass_threshold < 0
				or pattern_b1_bp3_cm_max_frequency_hz > 0
				or pattern_b1_bp3_cm_min_amplitude_prcnt < 0
				or pattern_b1_bp3_cm_min_duration_secs < 0
				or pattern_b1_bp3_cm_min_frequency_hz < 0
				--
				or pattern_b1_ll3_threshold_prcnt < 0
				or pattern_b1_ll3_cm_long_term_trend_mins < 0
				or pattern_b1_ll3_cm_short_term_trend_secs < 0
				--B2
				or pattern_b2_bp4_bandpass_threshold < 0
				or pattern_b2_bp4_cm_max_frequency_hz > 0
				or pattern_b2_bp4_cm_min_amplitude_prcnt < 0
				or pattern_b2_bp4_cm_min_duration_secs < 0
				or pattern_b2_bp4_cm_min_frequency_hz < 0
				--
				or pattern_b2_ll4_threshold_prcnt < 0
				or pattern_b2_ll4_cm_long_term_trend_mins < 0
				or pattern_b2_ll4_cm_short_term_trend_secs < 0
			then 'incr sensitivity' -- i.e. less specific
			--else 'no change'
		end as detector_chng,
		case
			when 
				--T1
				t1b1_estimated_charge_density_uc_cm_sq > 0
				or t1b1_burst_duration_ms > 0
				or t1b2_estimated_charge_density_uc_cm_sq > 0
				or t1b2_burst_duration_ms > 0
				--T2
				or t2b1_estimated_charge_density_uc_cm_sq > 0
				or t2b1_burst_duration_ms > 0
				or t2b2_estimated_charge_density_uc_cm_sq > 0
				or t2b2_burst_duration_ms > 0
				--T3
				or t3b1_estimated_charge_density_uc_cm_sq > 0
				or t3b1_burst_duration_ms > 0
				or t3b2_estimated_charge_density_uc_cm_sq > 0
				or t3b2_burst_duration_ms > 0
				--T4
				or t4b1_estimated_charge_density_uc_cm_sq > 0
				or t4b1_burst_duration_ms > 0
				or t4b2_estimated_charge_density_uc_cm_sq > 0
				or t4b2_burst_duration_ms > 0
				--T5
				or t5b1_estimated_charge_density_uc_cm_sq > 0
				or t5b1_burst_duration_ms > 0
				or t5b2_estimated_charge_density_uc_cm_sq > 0
				or t5b2_burst_duration_ms > 0
			then 'decr stimulation'
			when 
				--T1
				t1b1_estimated_charge_density_uc_cm_sq < 0
				or t1b1_burst_duration_ms < 0
				or t1b2_estimated_charge_density_uc_cm_sq < 0
				or t1b2_burst_duration_ms < 0
				--T2
				or t2b1_estimated_charge_density_uc_cm_sq < 0
				or t2b1_burst_duration_ms < 0
				or t2b2_estimated_charge_density_uc_cm_sq < 0
				or t2b2_burst_duration_ms < 0
				--T3
				or t3b1_estimated_charge_density_uc_cm_sq < 0
				or t3b1_burst_duration_ms < 0
				or t3b2_estimated_charge_density_uc_cm_sq < 0
				or t3b2_burst_duration_ms < 0
				--T4
				or t4b1_estimated_charge_density_uc_cm_sq < 0
				or t4b1_burst_duration_ms < 0
				or t4b2_estimated_charge_density_uc_cm_sq < 0
				or t4b2_burst_duration_ms < 0
				--T5
				or t5b1_estimated_charge_density_uc_cm_sq < 0
				or t5b1_burst_duration_ms < 0
				or t5b2_estimated_charge_density_uc_cm_sq < 0
				or t5b2_burst_duration_ms < 0
			then 'incr stimulation'
			--else 'no change'
		end as stimulation_chng
	from rns_dm.sm_programming_epoch_parameter_changes
) x
GO
/****** Object:  View [rns_dm].[programming_epochs]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [rns_dm].[programming_epochs] as 
select
	pe.programming_epoch_id,
	pe.url,
	x.rns_deid_id,
	pe.patient_id,
	pe.programmer,
	pe.programming_dts,
	pe.report_type,
	pe.battery_voltage,
	pe.model_nmbr,
	pe.serial_nmbr,
	pe.hardware_vers,
	pe.software_vers,
	pe.rom_vers,
	pe.lead1,
	pe.lead2
from rns_ods.programming_epochs pe
join xref.patient_ids x
	on cast(pe.patient_id as varchar(1000)) = x.xref_id
		and x.xref_src = 'pdms_patient_at_center_id'

GO
/****** Object:  View [rns_dm].[sm_pe_nshd_weighted_responsive_therapies]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [rns_dm].[sm_pe_nshd_weighted_responsive_therapies] as 
select
	epert.rns_deid_id,
	epert.programming_dt,
	datediff(day, i.implant_dt, epert.programming_dt) as days_post_implant,
	coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) as t1_a,
	coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) as t1_b,
	case when epert.a_rt_e >= 1 then 1.0 * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.a_rt_e - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.a_rt_e * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end * eas.a_e as a_rt_e_total,
	case when epert.a_rt_le >= 1 then 1.0 * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.a_rt_le - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.a_rt_e * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end * eas.a_le as a_rt_le_total,
	case when epert.b_rt_e >= 1 then 1.0 * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.b_rt_e - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.b_rt_e * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end * eas.b_e as b_rt_e_total,
	case when epert.b_rt_le >= 1 then 1.0 * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.b_rt_le - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.b_rt_e * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end * eas.b_le as b_rt_le_total,
	--
	case when epert.a_rt_e >= 1 then 1.0 * coalesce(rt.t1_a, rt.t1_1, 0.0) + (epert.a_rt_e - 1.0) * coalesce(rt.t2_1, 0.0) else epert.a_rt_e * coalesce(rt.t1_a, rt.t1_1, 0.0) end * eas.a_e as a_rt_e_total_l1,
	case when epert.a_rt_le >= 1 then 1.0 * coalesce(rt.t1_a, rt.t1_1, 0.0) + (epert.a_rt_le - 1.0) * coalesce(rt.t2_1, 0.0) else epert.a_rt_e * coalesce(rt.t1_a, rt.t1_1, 0.0) end * eas.a_le as a_rt_le_total_l1,
	case when epert.b_rt_e >= 1 then 1.0 * coalesce(rt.t1_1, 0.0) + (epert.b_rt_e - 1.0) * coalesce(rt.t2_1, 0.0) else epert.b_rt_e * coalesce(rt.t1_1, 0.0) end * eas.b_e as b_rt_e_total_l1,
	case when epert.b_rt_le >= 1 then 1.0 * coalesce(rt.t1_1, 0.0) + (epert.b_rt_le - 1.0) * coalesce(rt.t2_1, 0.0) else epert.b_rt_e * coalesce(rt.t1_1, 0.0) end * eas.b_le as b_rt_le_total_l1,
	--
	case when epert.a_rt_e >= 1 then 1.0 * coalesce(rt.t1_2, 0.0) + (epert.a_rt_e - 1.0) * coalesce(rt.t2_2, 0.0) else epert.a_rt_e * coalesce(rt.t1_2, 0.0) end * eas.a_e as a_rt_e_total_l2,
	case when epert.a_rt_le >= 1 then 1.0 * coalesce(rt.t1_2, 0.0) + (epert.a_rt_le - 1.0) * coalesce(rt.t2_2, 0.0) else epert.a_rt_e * coalesce(rt.t1_2, 0.0) end * eas.a_le as a_rt_le_total_l2,
	case when epert.b_rt_e >= 1 then 1.0 * coalesce(rt.t1_b, rt.t1_2, 0.0) + (epert.b_rt_e - 1.0) * coalesce(rt.t2_2, 0.0) else epert.b_rt_e * coalesce(rt.t1_b, rt.t1_2, 0.0) end * eas.b_e as b_rt_e_total_l2,
	case when epert.b_rt_le >= 1 then 1.0 * coalesce(rt.t1_b, rt.t1_2, 0.0) + (epert.b_rt_le - 1.0) * coalesce(rt.t2_2, 0.0) else epert.b_rt_e * coalesce(rt.t1_b, rt.t1_2, 0.0) end * eas.b_le as b_rt_le_total_l2,
	--
	coalesce(case when epert.a_rt_e >= 1 then 1.0 * coalesce(rt.t1_a, rt.t1_1, 0.0) + (epert.a_rt_e - 1.0) * coalesce(rt.t2_1, 0.0) else epert.a_rt_e * coalesce(rt.t1_a, rt.t1_1, 0.0) end, 0) * eas.a_e +
	coalesce(case when epert.a_rt_le >= 1 then 1.0 * coalesce(rt.t1_a, rt.t1_1, 0.0) + (epert.a_rt_le - 1.0) * coalesce(rt.t2_1, 0.0) else epert.a_rt_e * coalesce(rt.t1_a, rt.t1_1, 0.0) end, 0) * eas.a_le +
	coalesce(case when epert.b_rt_e >= 1 then 1.0 * coalesce(rt.t1_1, 0.0) + (epert.b_rt_e - 1.0) * coalesce(rt.t2_1, 0.0) else epert.b_rt_e * coalesce(rt.t1_1, 0.0) end, 0) * eas.b_e +
	coalesce(case when epert.b_rt_le >= 1 then 1.0 * coalesce(rt.t1_1, 0.0) + (epert.b_rt_le - 1.0) * coalesce(rt.t2_1, 0.0) else epert.b_rt_e * coalesce(rt.t1_1, 0.0) end, 0) * eas.b_le as rt_l1,
	--
	coalesce(case when epert.a_rt_e >= 1 then 1.0 * coalesce(rt.t1_2, 0.0) + (epert.a_rt_e - 1.0) * coalesce(rt.t2_2, 0.0) else epert.a_rt_e * coalesce(rt.t1_2, 0.0) end, 0) * eas.a_e +
	coalesce(case when epert.a_rt_le >= 1 then 1.0 * coalesce(rt.t1_2, 0.0) + (epert.a_rt_le - 1.0) * coalesce(rt.t2_2, 0.0) else epert.a_rt_e * coalesce(rt.t1_2, 0.0) end, 0) * eas.a_le +
	coalesce(case when epert.b_rt_e >= 1 then 1.0 * coalesce(rt.t1_b, rt.t1_2, 0.0) + (epert.b_rt_e - 1.0) * coalesce(rt.t2_2, 0.0) else epert.b_rt_e * coalesce(rt.t1_b, rt.t1_2, 0.0) end, 0) * eas.b_e +
	coalesce(case when epert.b_rt_le >= 1 then 1.0 * coalesce(rt.t1_b, rt.t1_2, 0.0) + (epert.b_rt_le - 1.0) * coalesce(rt.t2_2, 0.0) else epert.b_rt_e * coalesce(rt.t1_b, rt.t1_2, 0.0) end, 0) * eas.b_le as rt_l2,
	--
	coalesce(case when epert.a_rt_e >= 1 then 1.0 * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.a_rt_e - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.a_rt_e * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end, 0) * eas.a_e +
	coalesce(case when epert.a_rt_le >= 1 then 1.0 * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.a_rt_le - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.a_rt_e * coalesce(rt.t1_a, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end, 0) * eas.a_le +
	coalesce(case when epert.b_rt_e >= 1 then 1.0 * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.b_rt_e - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.b_rt_e * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end, 0) * eas.b_e +
	coalesce(case when epert.b_rt_le >= 1 then 1.0 * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) + (epert.b_rt_le - 1.0) * (coalesce(rt.t2_1, 0.0) + coalesce(rt.t2_2, 0.0)) else epert.b_rt_e * coalesce(rt.t1_b, coalesce(rt.t1_1, 0.0) + coalesce(rt.t1_2, 0.0)) end, 0) * eas.b_le as rt_total,
	cast(datediff(hour, epe.programming_dts, coalesce(epe.next_programming_dts, epe.max_reviewed_files_dts)) as decimal(10,2)) / 24.0 as pe_days_dec_calc, -- changed from getdate() BAD to max(file_dts) GOOD; 2/20/2018 NDS
	datediff(day, epe.programming_dts, coalesce(epe.next_programming_dts, epe.max_reviewed_files_dts)) as pe_days_int_calc -- changed from getdate() BAD to max(file_dts) GOOD; 2/20/2018 NDS
from rns_dm.sm_pe_el_responsive_therapies epert
join 
(
	select 
		*,
		a1_e + a2_e as a_e,
		a1_le + a2_le as a_le,
		b1_e + b2_e as b_e,
		b1_le + b2_le as b_le
	from rns_dm.sm_nshd_summaries
) eas
	on epert.rns_deid_id = eas.rns_deid_id
		and epert.programming_dt = eas.programming_dt
join
(
	select *
	from
	(
		select
			pe.rns_deid_id,
			cast(pe.programming_dts as date) as programming_dt,
			--perts.channel1_pos,
			--perts.channel3_pos,
			--b.burst_nm,
			perts.programming_epoch_responsive_therapy_id,
			case when perts.therapy like 'Therapy #1%' then 't1' when perts.therapy like 'Therapy #2%' then 't2' when perts.therapy like 'Therapy #3%' then 't3' when perts.therapy like 'Therapy #4%' then 't4' when perts.therapy like 'Therapy #5%' then 't5' end + '_' + case when perts.response_nm = 'Pattern A Therapy' then 'a' when perts.response_nm = 'Pattern B Therapy' then 'b' when b.burst_nm = 1 or (not perts.channel1_pos = '0' and perts.channel3_pos = '0') then '1' when b.burst_nm = 2 or (perts.channel1_pos = '0' and not perts.channel3_pos = '0') then '2' end as therapy_burst,
			case 
				when not perts.channel1_pos = '0' and not perts.channel3_pos = '0' then perts.estimated_charge_density_uc_cm_sq / 2.0
				--when perts.channel1_pos = '0' and b.burst_nm = 1 then null -- only situation like this is DD and l1 is disabled, stim is on l2
				else perts.estimated_charge_density_uc_cm_sq 
			end as estimated_charge_density_uc_cm_sq
		from rns_dm.programming_epochs pe
		join rns_ods.programming_epoch_responsive_therapies pert
			on pe.programming_epoch_id = pert.programming_epoch_id
		join rns_dm.programming_epoch_responsive_therapy_settings perts
			on pert.programming_epoch_responsive_therapy_id = perts.programming_epoch_responsive_therapy_id
		left join
		(
			select 1 as burst_nm union all select 2
		) b
			on not perts.channel1_pos = '0'
				and not perts.channel3_pos = '0'
	) d 
	pivot
	(
		sum(d.estimated_charge_density_uc_cm_sq)
		for d.therapy_burst in (t1_a, t1_b, t1_1, t1_2, t2_1, t2_2, t3_1, t3_2, t4_1, t4_2, t5_1, t5_2)
	) p
) rt
	on rt.rns_deid_id = epert.rns_deid_id
		and rt.programming_dt = epert.programming_dt
join rns_dm.sm_programming_epochs epe
	on epert.rns_deid_id = epe.rns_deid_id
		and epert.programming_dt = epe.programming_dt
join rns_abstractions_ods.implants i
	on epert.rns_deid_id = i.rns_deid_id

GO
/****** Object:  View [rns_dm].[programming_epoch_detectors]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [rns_dm].[programming_epoch_detectors] as
select
	pe.rns_deid_id,
	pe.programming_dts,
	next_prog.programming_dts as next_programming_dts,
	ped.pattern_a, -- note that even the AND logic is lazy because there is never a second detector to AND
	ped.pattern_b,
	max(case when (bp.pattern = 'Pattern A' and bp.detector = 'First Detector') or (ll.pattern = 'Pattern A' and ll.detector = 'First Detector') or (pe.rns_deid_id = 'RNS1529' and cast(pe.programming_dts as date) = '11/18/2015') then 1 else 0 end) as a1,
	max(case when (bp.pattern = 'Pattern A' and bp.detector = 'Second Detector') or (ll.pattern = 'Pattern A' and ll.detector = 'Second Detector') then 1 else 0 end) as a2,	
	max(case when (bp.pattern = 'Pattern B' and bp.detector = 'First Detector') or (ll.pattern = 'Pattern B' and ll.detector = 'First Detector') then 1 else 0 end) as b1,
	max(case when (bp.pattern = 'Pattern B' and bp.detector = 'Second Detector') or (ll.pattern = 'Pattern B' and ll.detector = 'Second Detector') or (pe.rns_deid_id = 'RNS1529' and cast(pe.programming_dts as date) = '11/18/2015') then 1 else 0 end) as b2
from rns_dm.programming_epochs pe
join rns_ods.programming_epoch_detection_settings ped
	on pe.programming_epoch_id = ped.programming_epoch_id
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp
	on ped.programming_epoch_detection_setting_id = bp.programming_epoch_detection_setting_id
left join rns_ods.programming_epoch_detection_setting_linelength_parameters ll
	on ped.programming_epoch_detection_setting_id = ll.programming_epoch_detection_setting_id
outer apply
(
	select top 1 pex.*
	from rns_dm.programming_epochs pex
	where pe.rns_deid_id = pex.rns_deid_id
		and pex.programming_dts > pe.programming_dts
	order by pex.programming_dts asc
) next_prog
group by
	pe.rns_deid_id,
	pe.programming_dts,
	next_prog.programming_dts,
	ped.pattern_a,
	ped.pattern_b



GO
/****** Object:  View [rns_dm].[sm_pe_nshd_weighted_electrographic_seizures]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [rns_dm].[sm_pe_nshd_weighted_electrographic_seizures] as
select
	eeps.rns_deid_id,
	eeps.programming_dt,
	--nhd_le.long_episodes_total / pe.pe_days_dec * 7.0 as long_episodes_raw_per_wk,
	case when (coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) = 0 then 0.00 else ens.a1_e * cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) as decimal(10,2)) end as a1_e_sz_calc,
	case when (coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) = 0 then 0.00 else ens.a2_e * cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) as decimal(10,2)) end as a2_e_sz_calc,
	case when (coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) = 0 then 0.00 else ens.a1_le * cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) as decimal(10,2)) end as a1_le_sz_calc,
	case when (coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) = 0 then 0.00 else ens.a2_le * cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) as decimal(10,2)) end as a2_le_sz_calc,	
	case when (coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) = 0 then 0.00 else ens.b1_e * cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) as decimal(10,2)) end as b1_e_sz_calc,
	case when (coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) = 0 then 0.00 else ens.b2_e * cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) as decimal(10,2)) end as b2_e_sz_calc,
	case when (coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) = 0 then 0.00 else ens.b1_le * cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) as decimal(10,2)) end as b1_le_sz_calc,
	case when (coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) = 0 then 0.00 else ens.b2_le * cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) as decimal(10,2)) end as b2_le_sz_calc,
	--
	-- A
	--
	--A1_E
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) = 0 then 0.00 else ens.a1_e * cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--A2_E
	-- weight according to episode length + detector type
	case when (coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) = 0 then 0.00 else ens.a2_e * cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--A1_LE
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) = 0 then 0.00 else ens.a1_le * cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) as decimal(10,2)) end
	+
	--A2_LE
	-- weight according to episode length + detector type
	case when (coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) = 0 then 0.00 else ens.a2_le * cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) as decimal(10,2)) end
	+
	--
	-- B
	--
	--B1_E
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) = 0 then 0.00 else ens.b1_e * cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--B2_E
	-- weight according to episode length + detector type
	case when (coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) = 0 then 0.00 else ens.b2_e * cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--B1_LE
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) = 0 then 0.00 else ens.b1_le * cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) as decimal(10,2)) end
	+
	--B2_LE
	-- weight according to episode length + detector type
	case when (coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) = 0 then 0.00 else ens.b2_le * cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) as decimal(10,2)) end as electrographic_seizures_calc_total,
	--
	-- A
	--
	--A1_E
	-- weight according to episode length + detector type					
	(case when (coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) = 0 then 0.00 else ens.a1_e * cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--A2_E
	-- weight according to episode length + detector type
	case when (coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) = 0 then 0.00 else ens.a2_e * cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--A1_LE
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) = 0 then 0.00 else ens.a1_le * cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) as decimal(10,2)) end
	+
	--A2_LE
	-- weight according to episode length + detector type
	case when (coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) = 0 then 0.00 else ens.a2_le * cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) as decimal(10,2)) end
	+
	--
	-- B
	--
	--B1_E
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) = 0 then 0.00 else ens.b1_e * cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--B2_E
	-- weight according to episode length + detector type
	case when (coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) = 0 then 0.00 else ens.b2_e * cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) as decimal(10,2)) end
	+
	--B1_LE
	-- weight according to episode length + detector type					
	case when (coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) = 0 then 0.00 else ens.b1_le * cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) as decimal(10,2)) end
	+
	--B2_LE
	-- weight according to episode length + detector type
	case when (coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) = 0 then 0.00 else ens.b2_le * cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) as decimal(10,2)) end) / pe.pe_days_dec * 7.0 as electrographic_seizures_calc_per_wk
from rns_dm.sm_ecog_pe_summaries eeps
join rns_dm.sm_nshd_summaries ens
	on eeps.rns_deid_id = ens.rns_deid_id
		and eeps.programming_dt = ens.programming_dt
join rns_dm.sm_programming_epochs pe
	on eeps.rns_deid_id = pe.rns_deid_id
		and eeps.programming_dt = pe.programming_dt
left join 
(
	select
		nhd.rns_deid_id,
		spe.programming_dt,
		sum(nhd.long_episodes_cnt) as long_episodes_total
	from rns_ods.neurostimulator_daily_histories nhd
	join rns_dm.sm_programming_epochs spe
		on nhd.rns_deid_id = nhd.rns_deid_id
			and nhd.neurostimulator_daily_dt >= spe.programming_dt and nhd.neurostimulator_daily_dt < coalesce(spe.next_programming_dt, spe.max_reviewed_files_dts)
	group by 
		nhd.rns_deid_id,
		spe.programming_dt
) nhd_le
	on nhd_le.rns_deid_id = eeps.rns_deid_id
		and nhd_le.programming_dt = eeps.programming_dt






GO
/****** Object:  View [rns_dm].[sm_electrographic_seizures_change_per_pe]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [rns_dm].[sm_electrographic_seizures_change_per_pe] as
select
	e1.rns_deid_id,
	e1.programming_dt,
	e1.pe_nmbr,
	e2.electrographic_seizures_calc_per_wk - e1.electrographic_seizures_calc_per_wk as sz_abs_change_from_previous, --maybe also try from baseline...
	-1 + case when not coalesce(e1.electrographic_seizures_calc_per_wk, 0) = 0 then e2.electrographic_seizures_calc_per_wk / e1.electrographic_seizures_calc_per_wk end as sz_prcnt_change_from_previous --maybe also try from baseline...
from 
(
	select es.*, spe.pe_nmbr
	from [rns_dm].[sm_pe_nshd_weighted_electrographic_seizures] es
	join rns_dm.sm_programming_epochs spe
		on es.rns_deid_id = spe.rns_deid_id
			and es.programming_dt = spe.programming_dt
) e1, 
(
	select es.*, spe.pe_nmbr
	from [rns_dm].[sm_pe_nshd_weighted_electrographic_seizures] es
	join rns_dm.sm_programming_epochs spe
		on es.rns_deid_id = spe.rns_deid_id
			and es.programming_dt = spe.programming_dt
) e2
where e1.rns_deid_id = e2.rns_deid_id
	and e1.pe_nmbr + 1 = e2.pe_nmbr
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)


GO
/****** Object:  View [rns_abstractions_dm].[medical_histories]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [rns_abstractions_dm].[medical_histories] as 
select
	i.rns_deid_id,
	case
		when mh.diagnosis_dsc like '%hypertension%' or mh.diagnosis_dsc like '%hypertenson%' then 'hypertension'
		when mh.diagnosis_dsc like '%thyroid%' then 'thyroid disorder'
		when mh.diagnosis_dsc like '%convulsions%' or mh.diagnosis_dsc like '%seizure%' or mh.diagnosis_dsc like '%epilepsy%' then 'epilepsy'
		when mh.diagnosis_dsc like '%headache%' or mh.diagnosis_dsc like '%migraine%' then 'headache syndrome'
		when mh.diagnosis_dsc like '%varicella%' then 'varicella'
		when mh.diagnosis_dsc like '%calculus%' then 'nephrolithiasis'
		when mh.diagnosis_dsc like '%asthma%' or mh.diagnosis_dsc like '%reactive airway%' then 'asthma'
		when mh.diagnosis_dsc like '%anemia%' then 'anemia'
		when mh.diagnosis_dsc like '%depression%' or mh.diagnosis_dsc like '%depressive%'  then 'depressive disorder'
		when mh.diagnosis_dsc like '%anxiety%' or mh.diagnosis_dsc like '%panic%' then 'anxiety disorder'
		when mh.diagnosis_dsc like '%fracture%' then 'bone fracture'
		when mh.diagnosis_dsc like '%encephalitis%' then 'encephalitis'
		when mh.diagnosis_dsc like '%gastrointestinal%' or mh.diagnosis_dsc like '%epigastric%' then 'gastrointestinal disorder'
		when mh.diagnosis_dsc like '%concussion%' or mh.diagnosis_dsc like '%head injury%' then 'traumatic brain injury'
		when mh.diagnosis_dsc like '%cerebrovascular%' or mh.diagnosis_dsc like '%aneurysm%' then 'cerebrovascular disease'
		when mh.diagnosis_dsc like '%hyperlipidemia%' then 'cardiovascular disease'
		when mh.diagnosis_dsc like '%embolism%' or mh.diagnosis_dsc like '%thrombosis%' then 'thrombus/embolus'
		when mh.diagnosis_dsc like '%insomnia%' then 'sleep-wake disorder'
		when mh.diagnosis_dsc like '%sweating%' then 'hyperhidrosis'
		when mh.diagnosis_dsc in ('systemic sclerosis','Raynaud syndrome','pericarditis','leukopenia','esophageal reflux','osteopenia','lupus') then mh.diagnosis_dsc
		when mh.diagnosis_dsc like '%arthritis%' or mh.diagnosis_dsc like '%arthropathy%' then 'arthritis'
		when mh.diagnosis_dsc like '%glaucoma%' then 'glaucoma'
		when mh.diagnosis_dsc like '%mitral%valve%' then 'mitral valve prolapse'
		when mh.diagnosis_dsc like '%ecchymoses spontaneous%' then 'coagulopathy'
		--else mh.diagnosis_dsc
	end as diagnosis_dsc_coded,
	mh.*
from rns_abstractions_ods.medical_histories mh
join rns_abstractions_ods.implants i
	on mh.patient_id = i.patient_id


GO
/****** Object:  View [rns_abstractions_dm].[seizure_classifications]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_abstractions_dm].[seizure_classifications] as 
select
	i.rns_deid_id,
	mh.*
from rns_abstractions_ods.seizure_classifications mh
join rns_abstractions_ods.implants i
	on mh.patient_id = i.patient_id
GO
/****** Object:  View [rns_abstractions_dm].[seizure_onsets]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_abstractions_dm].[seizure_onsets] as 
select
	i.rns_deid_id,
	mh.*
from rns_abstractions_ods.seizure_onsets mh
join rns_abstractions_ods.implants i
	on mh.patient_id = i.patient_id
GO
/****** Object:  View [rns_abstractions_dm].[surgical_histories]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_abstractions_dm].[surgical_histories] as 
select
	i.rns_deid_id,
	mh.*
from rns_abstractions_ods.surgical_histories mh
join rns_abstractions_ods.implants i
	on mh.patient_id = i.patient_id
GO
/****** Object:  View [rns_dm].[activity_logs]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [rns_dm].[activity_logs] as
select
	x.rns_deid_id,
	ii.*
from rns_ods.activity_logs ii
join xref.patient_ids x
	on cast(ii.patient_id as varchar(1000)) = x.xref_id
		and x.xref_src = 'pdms_patient_at_center_id'

GO
/****** Object:  View [rns_dm].[event_lists]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [rns_dm].[event_lists] as
select
	x.rns_deid_id,
	el.patient_id,
	el.interrogation_dts,
	el.episode_sequence,
	el.event_dts,
	el.duration,
	el.event_type,
	elc.episode_trigger,
	elc.a1_fd,
	elc.a2_fd,
	elc.b1_fd,
	elc.b2_fd,
	elc.a1_rd,
	elc.a2_rd,
	elc.b1_rd,
	elc.b2_rd,
	elc.a1_total,
	elc.a2_total,
	elc.b1_total,
	elc.b2_total,
	elc.a_total,
	elc.b_total,
	elc.responsive_therapy_cnt,
	elc.saturation_cnt,
	elc.magnet_cnt,
	elc.noise_cnt,	
	el.load_dts
from rns_ods.event_lists el
join xref.patient_ids x
	on cast(el.patient_id as varchar(1000)) = x.xref_id
		and x.xref_src = 'pdms_patient_at_center_id'
join rns_dm.event_lists_components elc
	on elc.rns_deid_id = x.rns_deid_id
		and elc.event_dts = el.event_dts
		and elc.episode_sequence = el.episode_sequence



GO
/****** Object:  View [rns_dm].[ieeg_file_data_compiled_for_seizure_markings_eof_annotations]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [rns_dm].[ieeg_file_data_compiled_for_seizure_markings_eof_annotations] as
select
	compiled_file_nm,
	datfile_nm,
	max(compiled_sample_nmbr) as eof_sample_nmbr,
	cast(max(compiled_sample_nmbr) as decimal(10,2)) / 250.00 as eof_sample_scnds
from rns_dm.ieeg_file_data_compiled_for_seizure_markings
group by 
	compiled_file_nm,
	datfile_nm
GO
/****** Object:  View [rns_dm].[ieeg_file_data_compiled_for_seizure_markings_impedance_normalized]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[ieeg_file_data_compiled_for_seizure_markings_impedance_normalized] as 
select
	sm.ieeg_file_data_compiled_for_seizure_markings_id,
	sm.rns_deid_id,
	sm.programming_dt,
	sm.datfile_nm,
	sm.compiled_file_nm,
	sm.compiled_sample_nmbr,
	sm.[file_id],
	sm.sample_nmbr,
	sm.channel1 * isf.channel1_sf as channel1,
	sm.channel2 * isf.channel1_sf as channel2,
	sm.channel3 * isf.channel1_sf as channel3,
	sm.channel4 * isf.channel1_sf as channel4,
	sm.load_dts
from rns_dm.ieeg_file_data_compiled_for_seizure_markings sm
join rns_dm.ltnd_impedance_scale_factors isf
	on sm.rns_deid_id = isf.rns_deid_id
		and sm.programming_dt = cast(isf.programming_dts as date)
GO
/****** Object:  View [rns_dm].[ieeg_file_data_recompiled_for_seizure_markings_eof_annotations]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [rns_dm].[ieeg_file_data_recompiled_for_seizure_markings_eof_annotations] as
select
	smc_1.csv_file_nm + '.csv' as compiled_file_nm,
	rc.datfile_nm,
	max(smc_2.csv_file_line) - 1 as eof_sample_nmbr,
	(cast(max(smc_2.csv_file_line) as decimal(10,2)) - 1) / 250.00 as eof_sample_scnds
from rns_ods.seizure_markings_csv_eof_tmp smc_1
join rns_ods.seizure_markings_csv_eof_tmp smc_2
	on smc_1.eof_rnk = smc_2.eof_rnk - 1
		and smc_1.csv_file_nm = smc_2.csv_file_nm
left join 
(
	select distinct rc.[file_id], rc.datfile_nm
	from rns_dm.ieeg_file_data_recompiled_for_seizure_markings rc
) rc
	on smc_1.dat_file_id = rc.[file_id]
where not smc_2.csv_file_line is null
group by 
	smc_1.csv_file_nm + '.csv',
	rc.datfile_nm

GO
/****** Object:  View [rns_dm].[impedance_measurements]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[impedance_measurements] as
select *
from
(
	select
		im.patient_id,
		im.measurement_dts,
		im.lead_nm,
		im.lead_ohms
	from rns_ods.impedance_measurements im
) d
pivot
(
	max(lead_ohms) for lead_nm in
	(
		[lead_1_measurements],
		[lead_2_measurements],
		[lead_3_measurements],
		[lead_4_measurements],
		[lead_5_measurements],
		[lead_6_measurements],
		[lead_7_measurements],
		[lead_8_measurements]
	)
) p

GO
/****** Object:  View [rns_dm].[nonseizure_detections]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[nonseizure_detections] as
select
	replace(d.server_patient_di, 'X:', 'Z:') + '\' + d.datfileName as file_path
from [rns_dm].[data] d
where d.server_patient_di like '%CJ%'
	and d.trigger_reason = 'ECOG_SCHEDULED_CATEGORY'
GO
/****** Object:  View [rns_dm].[pdms_detector_clinical_settings]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[pdms_detector_clinical_settings] as
select
	i.detector_nm,
	i.clinical_parameter_val as min_freq,
	a.clinical_parameter_val as max_freq,
	i.technical_setting_val1 as count_criterion,
	i.technical_setting_val2 as window_size,
	a.technical_setting_val1 as min_width
from [rns_ods].[pdms_detector_clinical_parameter_settings] a, [rns_ods].[pdms_detector_clinical_parameter_settings] i
where a.detector_nm = 'BP' and i.detector_nm = 'BP'
	and i.clinical_parameter_nm = 'min_freq'
	and a.clinical_parameter_nm = 'max_freq'
	and i.clinical_parameter_val < a.clinical_parameter_val
GO
/****** Object:  View [rns_dm].[programming_epoch_summaries]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [rns_dm].[programming_epoch_summaries] as 
select
	x.rns_deid_id,
	pes.*
from rns_ods.programming_epoch_summaries pes
join xref.patient_ids x
	on cast(pes.patient_id as varchar(1000)) = x.xref_id
GO
/****** Object:  View [rns_dm].[remote_monitor_reports]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rns_dm].[remote_monitor_reports] as 
select
	r.remote_monitor_report_id,
	x.rns_deid_id,	
	r.lay_nm,
	r.dat_nm,
	fd.file_dts,
	r.group_id,
	r.name,
	cast(r.start_time as decimal(10,2)) as start_time,
	cast(r.duration as decimal(10,2)) as duration,	
	r.load_dts		
from rns_ods.remote_monitor_reports r
join rns_ods.pdms_file_dates fd
	on r.dat_nm = fd.file_nm
join xref.patient_ids x
	on fd.pdms_patient_at_center_id = x.xref_id
		and x.xref_src = 'pdms_patient_at_center_id'
GO
/****** Object:  View [rns_dm].[seizure_surveys_normalized]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [rns_dm].[seizure_surveys_normalized] as
	select
		s.rns_deid_id,
		s.survey_dt,
		rank() over (partition by s.rns_deid_id order by survey_dt asc) as earliest_survey_rnk,
		rank() over (partition by s.rns_deid_id order by survey_dt desc) as latest_survey_rnk,
		case 
			when s.seizure_type1_frequency_units = 'day' then s.seizure_type1_frequency_dec * 365.00 / 12.00
			when s.seizure_type1_frequency_units = 'week' then s.seizure_type1_frequency_dec * 52.00 / 12.00
			when s.seizure_type1_frequency_units = 'month' then s.seizure_type1_frequency_dec
			when s.seizure_type1_frequency_units = 'year' then s.seizure_type1_frequency_dec / 12.00
			else 0.00
		end as seizure1_freq_per_month,
		case
			when s.seizure_type1_duration_units = 'seconds' then s.seizure_type1_duration_dec
			when s.seizure_type1_duration_units = 'minutes' then s.seizure_type1_duration_dec * 60.00
			else 0.00
		end as seizure1_duration_seconds,
		case 
			when s.seizure_type2_frequency_units = 'day' then s.seizure_type2_frequency_dec * 365.00 / 12.00
			when s.seizure_type2_frequency_units = 'week' then s.seizure_type2_frequency_dec * 52.00 / 12.00
			when s.seizure_type2_frequency_units = 'month' then s.seizure_type2_frequency_dec
			when s.seizure_type2_frequency_units = 'year' then s.seizure_type2_frequency_dec / 12.00
			else 0.00
		end as seizure2_freq_per_month,
		case
			when s.seizure_type2_duration_units = 'seconds' then s.seizure_type2_duration_dec
			when s.seizure_type2_duration_units = 'minutes' then s.seizure_type2_duration_dec * 60.00
			else 0.00
		end as seizure2_duration_seconds,
		case 
			when s.seizure_type3_frequency_units = 'day' then s.seizure_type3_frequency_dec * 365.00 / 12.00
			when s.seizure_type3_frequency_units = 'week' then s.seizure_type3_frequency_dec * 52.00 / 12.00
			when s.seizure_type3_frequency_units = 'month' then s.seizure_type3_frequency_dec
			when s.seizure_type3_frequency_units = 'year' then s.seizure_type3_frequency_dec / 12.00
			else 0.00
		end as seizure3_freq_per_month,
		case
			when s.seizure_type3_duration_units = 'seconds' then s.seizure_type3_duration_dec
			when s.seizure_type3_duration_units = 'minutes' then s.seizure_type3_duration_dec * 60.00
			else 0.00
		end as seizure3_duration_seconds,
		case 
			when s.seizure_type4_frequency_units = 'day' then s.seizure_type4_frequency_dec * 365.00 / 12.00
			when s.seizure_type4_frequency_units = 'week' then s.seizure_type4_frequency_dec * 52.00 / 12.00
			when s.seizure_type4_frequency_units = 'month' then s.seizure_type4_frequency_dec
			when s.seizure_type4_frequency_units = 'year' then s.seizure_type4_frequency_dec / 12.00
			else 0.00
		end as seizure4_freq_per_month,
		case
			when s.seizure_type4_duration_units = 'seconds' then s.seizure_type4_duration_dec
			when s.seizure_type4_duration_units = 'minutes' then s.seizure_type4_duration_dec * 60.00
			else 0.00
		end as seizure4_duration_seconds,
		case 
			when s.seizure_type5_frequency_units = 'day' then s.seizure_type5_frequency_dec * 365.00 / 12.00
			when s.seizure_type5_frequency_units = 'week' then s.seizure_type5_frequency_dec * 52.00 / 12.00
			when s.seizure_type5_frequency_units = 'month' then s.seizure_type5_frequency_dec
			when s.seizure_type5_frequency_units = 'year' then s.seizure_type5_frequency_dec / 12.00
			else 0.00
		end as seizure5_freq_per_month,
		case
			when s.seizure_type5_duration_units = 'seconds' then s.seizure_type5_duration_dec
			when s.seizure_type5_duration_units = 'minutes' then s.seizure_type5_duration_dec * 60.00
			else 0.00
		end as seizure5_duration_seconds
	from rns_ods.seizure_surveys s

GO
/****** Object:  View [rns_dm].[sm_compiled_file_first_stim_of_episode_markings]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [rns_dm].[sm_compiled_file_first_stim_of_episode_markings] as
select
	sf.compiled_file_nm,
	sf.datfile_nm,
	ees.episode_nmbr,
	r.name,
	cast(sf.min_compiled_sample_nmbr / cast(250 as bigint) as decimal(10,3)) as compiled_file_start_s,	
	r.start_time,
	cast(sf.min_compiled_sample_nmbr / cast(250 as bigint) as decimal(10,3)) + try_cast(r.start_time as decimal(10,3)) as compiled_start_time,
	ad.stim_start_time_dec as compiled_start_time_ed,
	ad.stim_start_csv_file_line as csv_file_line_stim,
	case 
		when sf.sz_flg = 1 and try_cast(r.start_time as decimal(10,3)) > try_cast(sf.sz_relative_onset_s as decimal(10,3)) then 'st_i' 
		when not r.start_time is null then 'st_ii'
		else null 
	end as stim_annot_calc
from [rns_dm].[sm_files] sf
join [rns_dm].[sm_ecog_episode_summaries] ees
	on ees.file_nm = sf.datfile_nm
cross apply --change to outer apply to validate
(
	select top 1 rmr.*
	from [rns_ods].[remote_monitor_reports] rmr
	where sf.datfile_nm = rmr.dat_nm
		and rmr.name like '%therapy%'
		and cast(rmr.start_time as decimal(10,3)) >= ees.episode_file_start_s
	order by cast(rmr.start_time as decimal(10,3)) asc
) r
cross apply
(
	select top 1 		
		eds.stim_start_csv_file_line,
		eds.stim_start_time_dec,
		eds.ch1_blnk_val
	from [rns_dm].[rns_seizure_markings_edf_edited_data_stims] eds
	where eds.csv_file_nm = sf.compiled_file_nm
	order by abs(sf.min_csv_file_line + cast(r.start_time * 250.0 - eds.stim_start_time_dec * 250.0 as bigint)) asc
) ad
GO
/****** Object:  View [rns_dm].[sm_mnth_nshd_weighted_electrographic_seizures]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [rns_dm].[sm_mnth_nshd_weighted_electrographic_seizures] as
select
	eeps.rns_deid_id,
	nhd_le.month_dt,
	avg(
		--
		-- A
		--
		--A1_E
		-- weight according to episode length + detector type					
		case when (coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) = 0 then 0.00 else ens.a1_e * cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0)) as decimal(10,2)) end
		+
		--A2_E
		-- weight according to episode length + detector type
		case when (coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) = 0 then 0.00 else ens.a2_e * cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0)) as decimal(10,2)) end
		+
		--A1_LE
		-- weight according to episode length + detector type					
		case when (coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) = 0 then 0.00 else ens.a1_le * cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0)) as decimal(10,2)) end
		+
		--A2_LE
		-- weight according to episode length + detector type
		case when (coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) = 0 then 0.00 else ens.a2_le * cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0)) as decimal(10,2)) end
		+
		--
		-- B
		--
		--B1_E
		-- weight according to episode length + detector type					
		case when (coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) = 0 then 0.00 else ens.b1_e * cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0)) as decimal(10,2)) end
		+
		--B2_E
		-- weight according to episode length + detector type
		case when (coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) = 0 then 0.00 else ens.b2_e * cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0)) as decimal(10,2)) end
		+
		--B1_LE
		-- weight according to episode length + detector type					
		case when (coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) = 0 then 0.00 else ens.b1_le * cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0)) as decimal(10,2)) end
		+
		--B2_LE
		-- weight according to episode length + detector type
		case when (coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) = 0 then 0.00 else ens.b2_le * cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0)) as decimal(10,2)) / cast((coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0)) as decimal(10,2)) end
	) as electrographic_seizures_calc_per_mnth
from rns_dm.sm_ecog_pe_summaries eeps
join rns_dm.sm_nshd_summaries ens
	on eeps.rns_deid_id = ens.rns_deid_id
		and eeps.programming_dt = ens.programming_dt
join rns_dm.sm_programming_epochs pe
	on eeps.rns_deid_id = pe.rns_deid_id
		and eeps.programming_dt = pe.programming_dt
left join 
(
	select
		nhd.rns_deid_id,
		spe.programming_dt,
		cast(cast(month(nhd.neurostimulator_daily_dt) as varchar(10)) + '-1-' + cast(year(nhd.neurostimulator_daily_dt) as varchar(10)) as date) as month_dt,
		sum(nhd.long_episodes_cnt) as long_episodes_total
	from rns_ods.neurostimulator_daily_histories nhd
	join rns_dm.sm_programming_epochs spe
		on nhd.rns_deid_id = nhd.rns_deid_id
			and nhd.neurostimulator_daily_dt >= spe.programming_dt and nhd.neurostimulator_daily_dt < coalesce(spe.next_programming_dt, spe.max_reviewed_files_dts)
	group by 
		nhd.rns_deid_id,
		cast(cast(month(nhd.neurostimulator_daily_dt) as varchar(10)) + '-1-' + cast(year(nhd.neurostimulator_daily_dt) as varchar(10)) as date),
		spe.programming_dt
) nhd_le
	on nhd_le.rns_deid_id = eeps.rns_deid_id
		and nhd_le.programming_dt = eeps.programming_dt
group by
	eeps.rns_deid_id,
	nhd_le.month_dt





GO
/****** Object:  View [rns_dm].[sm_pe_nshd_weighted_accuracies]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [rns_dm].[sm_pe_nshd_weighted_accuracies] as
select
	eeps.rns_deid_id,
	eeps.programming_dt,
	case when (eeps.a1_eg_e_sen is null and not ens.a1_e = 0) or (eeps.a1_eg_le_sen is null and not ens.a1_le = 0) or (eeps.a2_eg_e_sen is null and not ens.a2_e = 0) or (eeps.a2_eg_le_sen is null and not ens.a2_le = 0) or (eeps.b1_eg_e_sen is null and not ens.b1_e = 0) or (eeps.b1_eg_le_sen is null and not ens.b1_le = 0) or (eeps.b2_eg_e_sen is null and not ens.b2_e = 0) or (eeps.b2_eg_le_sen is null and not ens.b2_le = 0) then 1 else 0 end as missing_entire_pattern_data_flg,
	case when coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) +	coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) +	coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) + coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) + coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) +	coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) +	coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) + coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0) = 0 then null else
	cast((
		coalesce(eeps.a1_eg_e_tp, 0) +
		coalesce(eeps.a1_eg_le_tp, 0) +
		coalesce(eeps.a2_eg_e_tp, 0) +
		coalesce(eeps.a2_eg_le_tp, 0) +
		coalesce(eeps.b1_eg_e_tp, 0) +
		coalesce(eeps.b1_eg_le_tp, 0) +
		coalesce(eeps.b2_eg_e_tp, 0) +
		coalesce(eeps.b2_eg_le_tp, 0)
	) as decimal(10,2)) /
	cast((
		coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_fn, 0) +
		coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_fn, 0) +
		coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_fn, 0) +
		coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_fn, 0) +
		coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_fn, 0) +
		coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_fn, 0) +
		coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_fn, 0) +
		coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_fn, 0)
	) as decimal(10,2)) end as ecog_sen,	
	case when coalesce(eeps.a1_eg_e_fp, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0) + coalesce(eeps.a1_eg_le_tn, 0) +	coalesce(eeps.a2_eg_e_fp, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0) + coalesce(eeps.b2_eg_le_tn, 0) = 0 then null else
	cast((
		coalesce(eeps.a1_eg_e_tn, 0) +
		coalesce(eeps.a1_eg_le_tn, 0) +
		coalesce(eeps.a2_eg_e_tn, 0) +
		coalesce(eeps.a2_eg_le_tn, 0) +
		coalesce(eeps.b1_eg_e_tn, 0) +
		coalesce(eeps.b1_eg_le_tn, 0) +
		coalesce(eeps.b2_eg_e_tn, 0) +
		coalesce(eeps.b2_eg_le_tn, 0)
	) as decimal(10,2)) /
	cast((
		coalesce(eeps.a1_eg_e_fp, 0) + coalesce(eeps.a1_eg_e_tn, 0) +
		coalesce(eeps.a1_eg_le_fp, 0) + coalesce(eeps.a1_eg_le_tn, 0) +
		coalesce(eeps.a2_eg_e_fp, 0) + coalesce(eeps.a2_eg_e_tn, 0) +
		coalesce(eeps.a2_eg_le_fp, 0) + coalesce(eeps.a2_eg_le_tn, 0) +
		coalesce(eeps.b1_eg_e_fp, 0) + coalesce(eeps.b1_eg_e_tn, 0) +
		coalesce(eeps.b1_eg_le_fp, 0) + coalesce(eeps.b1_eg_le_tn, 0) +
		coalesce(eeps.b2_eg_e_fp, 0) + coalesce(eeps.b2_eg_e_tn, 0) +
		coalesce(eeps.b2_eg_le_fp, 0) + coalesce(eeps.b2_eg_le_tn, 0)
	) as decimal(10,2)) end as ecog_spe,	
	cast((
		coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_tn, 0) +
		coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_tn, 0) +
		coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_tn, 0) +
		coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_tn, 0) +
		coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_tn, 0) +
		coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_tn, 0) +
		coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_tn, 0) +
		coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_tn, 0)
	) as decimal(10,2)) /
	cast((
		coalesce(eeps.a1_eg_e_tp, 0) + coalesce(eeps.a1_eg_e_tn, 0) + coalesce(eeps.a1_eg_e_fp, 0) + coalesce(eeps.a1_eg_e_fn, 0) +		
		coalesce(eeps.a1_eg_le_tp, 0) + coalesce(eeps.a1_eg_le_tn, 0) + coalesce(eeps.a1_eg_le_fp, 0) + coalesce(eeps.a1_eg_le_fn, 0) +		
		coalesce(eeps.a2_eg_e_tp, 0) + coalesce(eeps.a2_eg_e_tn, 0) + coalesce(eeps.a2_eg_e_fp, 0) + coalesce(eeps.a2_eg_e_fn, 0) +		
		coalesce(eeps.a2_eg_le_tp, 0) + coalesce(eeps.a2_eg_le_tn, 0) + coalesce(eeps.a2_eg_le_fp, 0) + coalesce(eeps.a2_eg_le_fn, 0) +		
		coalesce(eeps.b1_eg_e_tp, 0) + coalesce(eeps.b1_eg_e_tn, 0) + coalesce(eeps.b1_eg_e_fp, 0) + coalesce(eeps.b1_eg_e_fn, 0) +		
		coalesce(eeps.b1_eg_le_tp, 0) + coalesce(eeps.b1_eg_le_tn, 0) + coalesce(eeps.b1_eg_le_fp, 0) + coalesce(eeps.b1_eg_le_fn, 0) +		
		coalesce(eeps.b2_eg_e_tp, 0) + coalesce(eeps.b2_eg_e_tn, 0) + coalesce(eeps.b2_eg_e_fp, 0) + coalesce(eeps.b2_eg_e_fn, 0) +		
		coalesce(eeps.b2_eg_le_tp, 0) + coalesce(eeps.b2_eg_le_tn, 0) + coalesce(eeps.b2_eg_le_fp, 0) + coalesce(eeps.b2_eg_le_fn, 0)
	) as decimal(10,2)) as ecog_accuracy,
	--
	-- A
	--
	--A1_E
	-- weight according to episode length + detector type					
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a1_eg_e_acc, 0) * cast(ens.a1_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+
	--A2_E
	-- weight according to episode length + detector type
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a2_eg_e_acc, 0) * cast(ens.a2_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+
	--A1_LE
	-- weight according to episode length + detector type					
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a1_eg_le_acc, 0) * cast(ens.a1_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+
	--A2_LE
	-- weight according to episode length + detector type
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a2_eg_le_acc, 0) * cast(ens.a2_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+
	--
	-- B
	--
	--B1_E
	-- weight according to episode length + detector type					
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b1_eg_e_acc, 0) * cast(ens.b1_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+
	--B2_E
	-- weight according to episode length + detector type
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b2_eg_e_acc, 0) * cast(ens.b2_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+	
	--B1_LE
	-- weight according to episode length + detector type					
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b1_eg_le_acc, 0) * cast(ens.b1_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end
	+
	--B2_LE
	-- weight according to episode length + detector type
	case when (case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b2_eg_le_acc, 0) * cast(ens.b2_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_acc is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_acc is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_acc is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_acc is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_acc is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_acc is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_acc is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_acc is null then 0 else ens.b2_le end) as decimal(10,2)) end as eac,
	--
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a1_eg_e_sen, 0) * cast(ens.a1_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a2_eg_e_sen, 0) * cast(ens.a2_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a1_eg_le_sen, 0) * cast(ens.a1_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a2_eg_le_sen, 0) * cast(ens.a2_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b1_eg_e_sen, 0) * cast(ens.b1_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b2_eg_e_sen, 0) * cast(ens.b2_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +	
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b1_eg_le_sen, 0) * cast(ens.b1_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b2_eg_le_sen, 0) * cast(ens.b2_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_sen is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_sen is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_sen is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_sen is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_sen is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_sen is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_sen is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_sen is null then 0 else ens.b2_le end) as decimal(10,2)) end as sen,
	--
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a1_eg_e_spe, 0) * cast(ens.a1_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a2_eg_e_spe, 0) * cast(ens.a2_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a1_eg_le_spe, 0) * cast(ens.a1_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.a2_eg_le_spe, 0) * cast(ens.a2_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b1_eg_e_spe, 0) * cast(ens.b1_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b2_eg_e_spe, 0) * cast(ens.b2_e as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +	
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b1_eg_le_spe, 0) * cast(ens.b1_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end +
	case when (case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) = 0 then 0.00 else coalesce(eeps.b2_eg_le_spe, 0) * cast(ens.b2_le as decimal(10,2)) / cast((case when eeps.a1_eg_e_spe is null then 0 else ens.a1_e end + case when eeps.a1_eg_le_spe is null then 0 else ens.a1_le end + case when eeps.a2_eg_e_spe is null then 0 else ens.a2_e end + case when eeps.a2_eg_le_spe is null then 0 else ens.a2_le end + case when eeps.b1_eg_e_spe is null then 0 else ens.b1_e end + case when eeps.b1_eg_le_spe is null then 0 else ens.b1_le end + case when eeps.b2_eg_e_spe is null then 0 else ens.b2_e end + case when eeps.b2_eg_le_spe is null then 0 else ens.b2_le end) as decimal(10,2)) end as spe
from rns_dm.sm_ecog_pe_summaries eeps
join rns_dm.sm_nshd_summaries ens
	on eeps.rns_deid_id = ens.rns_deid_id
		and eeps.programming_dt = ens.programming_dt
--join rns_dm.sm_al_nde_summaries ans
--	on eeps.rns_deid_id = ans.rns_deid_id
--		and eeps.programming_dt = ans.programming_dt







GO
/****** Object:  View [rns_dm].[sm_pe_nshd_weighted_latencies]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE view [rns_dm].[sm_pe_nshd_weighted_latencies] as
select
	sl.rns_deid_id,
	sl.programming_dt,
	ecog_sl.latency as ecog_latency_s,
	sl.a1,
	sl.a2,
	sl.b1,
	sl.b2,
	--
	-- A
	--
	--A1
	-- weight according to episode length + detector type					
	case when ((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) = 0 then 0.00 else coalesce(sl.a1, 0) * cast(ens.a1_e + ens.a1_le as decimal(10,2)) / cast(((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) as decimal(10,2)) end
	+
	--A2
	-- weight according to episode length + detector type
	case when ((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) = 0 then 0.00 else coalesce(sl.a2, 0) * cast(ens.a2_e + ens.a2_le as decimal(10,2)) / cast(((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) as decimal(10,2)) end
	+
	--
	-- B
	--
	--B1
	-- weight according to episode length + detector type					
	case when ((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) = 0 then 0.00 else coalesce(sl.b1, 0) * cast(ens.b1_e + ens.b1_le as decimal(10,2)) / cast(((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) as decimal(10,2)) end
	+
	--B2_LE
	-- weight according to episode length + detector type
	case when ((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) = 0 then 0.00 else coalesce(sl.b2, 0) * cast(ens.b2_e + ens.b2_le as decimal(10,2)) / cast(((ens.a1_e + ens.a1_le) * case when sl.a1 is null then 0 else 1 end + (ens.a2_e + ens.a2_le) * case when sl.a2 is null then 0 else 1 end + (ens.b1_e + ens.b1_le) * case when sl.b1 is null then 0 else 1 end + (ens.b2_e + ens.b2_le) * case when sl.b2 is null then 0 else 1 end) as decimal(10,2)) end as weighted_latency_s
from
(
	select *
	from
	(
		select
			ees.rns_deid_id,
			ees.programming_dt,
			ees.first_detector,
			--stdev(sz_relative_onset_s - first_detector_trigger_s) as stdev_latency,
			avg(first_detector_trigger_s - sz_relative_onset_s) as latency			
		from rns_dm.sm_ecog_episode_summaries ees
		where ees.sz_annotation in ('sz_on', 'sz_on_l', 'sz_on_r', 'sz_on_b')
			--and ees.episode_nmbr = 1
			--and ees.first_detector_trigger_s > ees.sz_relative_onset_s
			and ees.first_detector_trigger_s - ees.sz_relative_onset_s >= -5
			and ees.first_detector_trigger_s - ees.sz_relative_onset_s < 10
		group by
			ees.rns_deid_id,
			ees.programming_dt,
			ees.first_detector
	) d
	pivot
	(
		max(d.latency) for d.first_detector in ([A1],[A2],[B1],[B2])
	) p
) sl
join rns_dm.sm_nshd_summaries ens
	on sl.rns_deid_id = ens.rns_deid_id
		and sl.programming_dt = ens.programming_dt
join 
(
	select
		ees.rns_deid_id,
		ees.programming_dt,			
		--stdev(sz_relative_onset_s - first_detector_trigger_s) as stdev_latency,
		avg(first_detector_trigger_s - sz_relative_onset_s) as latency			
	from rns_dm.sm_ecog_episode_summaries ees
	where ees.sz_annotation in ('sz_on', 'sz_on_l', 'sz_on_r', 'sz_on_b')
		--and ees.episode_nmbr = 1
		--and ees.first_detector_trigger_s > ees.sz_relative_onset_s
		and ees.first_detector_trigger_s - ees.sz_relative_onset_s >= -5
		and ees.first_detector_trigger_s - ees.sz_relative_onset_s < 10
	group by
		ees.rns_deid_id,
		ees.programming_dt
) ecog_sl
	on sl.rns_deid_id = ecog_sl.rns_deid_id
		and sl.programming_dt = ecog_sl.programming_dt
--join rns_dm.sm_al_nde_summaries ans
--	on eeps.rns_deid_id = ans.rns_deid_id
--		and eeps.programming_dt = ans.programming_dt









GO
/****** Object:  StoredProcedure [rns_sql2matlab].[ieeg_recordings]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [rns_sql2matlab].[ieeg_recordings]
	@rns_deid_id as varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select
	lay_file_id,
	dat_file_id,
	file_dts,
	patient_dir,
	datfile_nm,
	datfile_path,
	trigger_reason,
	detection_set_name,
	responsive_therapy_enable,
	channel1 as channel1_map,
	channel2 as channel2_map,
	channel3 as channel3_map,
	channel4 as channel4_map,
	channel1_srate,
	channel2_srate,
	channel3_srate,
	channel4_srate,
	channel1_lp_frequency,
	channel2_lp_frequency,
	channel3_lp_frequency,
	channel4_lp_frequency,
	channel1_hp_frequency,
	channel2_hp_frequency,
	channel3_hp_frequency,
	channel4_hp_frequency,
	channel1_stored_sample_interval,
	channel2_stored_sample_interval,
	channel3_stored_sample_interval,
	channel4_stored_sample_interval,
	channel1_rt_sample_interval,
	channel2_rt_sample_interval,
	channel3_rt_sample_interval,
	channel4_rt_sample_interval,
	amp1_channel,
	amp2_channel,
	amp1_linelength_window,
	amp2_linelength_window,
	amp1_linelength_interval,
	amp2_linelength_interval,
	amp1_area_window_size,
	amp2_area_window_size,
	amp1_area_sample_interval,
	amp2_area_sample_interval,
	amp1_linelength_sample_count,
	amp2_linelength_sample_count,
	amp1_area_sample_count,
	amp2_area_sample_count,
	pre_trigger_length,
	post_trigger_length,
	pin_label_input_1,
	pin_label_input_2,
	pin_label_input_3,
	pin_label_input_4,
	pin_label_input_5,
	pin_label_input_6,
	pin_label_input_7,
	pin_label_input_8,
	null as channel1, 
	null as channel2, 
	null as channel3, 
	null as channel4
from rns_dm.np_parameters
where rns_deid_id = @rns_deid_id
END



GO
/****** Object:  StoredProcedure [rns_sql2matlab].[patients]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [rns_sql2matlab].[patients]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		i.rns_deid_id,
		i.gender,
		i.birth_dt,
		i.epilepsy_dx_dt,
		i.implant_dt,
		i.epilepsy_type_ilae,
		i.epilepsy_etiology_ilae,
		i.lead1_type,
		i.lead1_location,
		i.lead1_orientation,
		i.lead1_laterality,
		i.lead2_type,
		i.lead2_location,
		i.lead2_orientation,
		i.lead2_laterality,
		i.placement_notes,
		null as medications,
		null as surgical_hx,
		null as medical_hx,
		null as seizure_classifications,
		null as seizure_onsets,
		null as programming_epochs,
		null as activity_logs,
		null as rns_ieeg_recordings
	from rns_abstractions_ods.implants i	
END



GO
/****** Object:  StoredProcedure [rns_sql2matlab].[programming_epochs]    Script Date: 10/25/2018 12:53:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [rns_sql2matlab].[programming_epochs]
	@rns_deid_id as varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select	
	pe.battery_voltage,
	pe.hardware_vers,
	pe.lead1,
	pe.lead2,
	pe.model_nmbr,
	pe.programmer,
	pe.programming_dts,
	pe.report_type,
	pe.rom_vers,
	pe.serial_nmbr,
	pe.software_vers,
	m.channel1_gain,
	m.channel1_neg,
	m.channel1_pos,
	m.channel2_gain,
	m.channel2_neg,
	m.channel2_pos,
	m.channel3_gain,
	m.channel3_neg,
	m.channel3_pos,
	m.channel4_gain,
	m.channel4_neg,
	m.channel4_pos,
	peds.detection_set_name,
	peds.detection_status,
	peds.first_detector,
	peds.second_detector,
	peds.pattern_a,
	peds.pattern_b,
	--
	bp1.bandpass_threshold as pattern_a1_bp1_bandpass_threshold,
	bp1.cm_max_frequency_hz as pattern_a1_bp1_cm_max_frequency_hz,
	bp1.cm_max_frequency_shape as pattern_a1_bp1_cm_max_frequency_shape,
	bp1.cm_min_amplitude_prcnt as pattern_a1_bp1_cm_min_amplitude_prcnt,
	bp1.cm_min_duration_secs as pattern_a1_bp1_cm_min_duration_secs,
	bp1.cm_min_frequency_hz as pattern_a1_bp1_cm_min_frequency_hz,
	bp1.cm_min_frequency_shape as pattern_a1_bp1_cm_min_frequency_shape,
	bp1.detection_analysis_window_ms as pattern_a1_bp1_detection_analysis_window_ms,
	bp1.detection_persistence_secs as pattern_a1_bp1_detection_persistence_secs,
	bp1.inversion as pattern_a1_bp1_inversion,
	bp1.max_frequency_min_width_ms as pattern_a1_bp1_max_frequency_min_width_ms,
	bp1.min_amplitude as pattern_a1_bp1_min_amplitude,
	bp1.min_amplitude_bandpass_hysteresis as pattern_a1_bp1_min_amplitude_bandpass_hysteresis,
	bp1.min_frequency_cnt_criterion as pattern_a1_bp1_min_frequency_cnt_criterion,
	bp1.min_frequency_window_ms as pattern_a1_bp1_min_frequency_window_ms,
	--
	lp1.cm_detection_threshold_prcnt as pattern_a1_ll1_threshold_prcnt,
	lp1.cm_long_term_trend_mins as pattern_a1_ll1_cm_long_term_trend_mins,
	lp1.cm_short_term_trend_secs as pattern_a1_ll1_cm_short_term_trend_secs,
	lp1.detection_peristence_secs as pattern_a1_ll1_detection_peristence_secs,
	lp1.detector as pattern_a1_ll1_detector,
	--
	bp2.bandpass_threshold as pattern_a2_bp2_bandpass_threshold,
	bp2.cm_max_frequency_hz as pattern_a2_bp2_cm_max_frequency_hz,
	bp2.cm_max_frequency_shape as pattern_a2_bp2_cm_max_frequency_shape,
	bp2.cm_min_amplitude_prcnt as pattern_a2_bp2_cm_min_amplitude_prcnt,
	bp2.cm_min_duration_secs as pattern_a2_bp2_cm_min_duration_secs,
	bp2.cm_min_frequency_hz as pattern_a2_bp2_cm_min_frequency_hz,
	bp2.cm_min_frequency_shape as pattern_a2_bp2_cm_min_frequency_shape,
	bp2.detection_analysis_window_ms as pattern_a2_bp2_detection_analysis_window_ms,
	bp2.detection_persistence_secs as pattern_a2_bp2_detection_persistence_secs,
	bp2.inversion as pattern_a2_bp2_inversion,
	bp2.max_frequency_min_width_ms as pattern_a2_bp2_max_frequency_min_width_ms,
	bp2.min_amplitude as pattern_a2_bp2_min_amplitude,
	bp2.min_amplitude_bandpass_hysteresis as pattern_a2_bp2_min_amplitude_bandpass_hysteresis,
	bp2.min_frequency_cnt_criterion as pattern_a2_bp2_min_frequency_cnt_criterion,
	bp2.min_frequency_window_ms as pattern_a2_bp2_min_frequency_window_ms,
	--
	lp2.cm_detection_threshold_prcnt as pattern_a2_ll2_threshold_prcnt,
	lp2.cm_long_term_trend_mins as pattern_a2_ll2_cm_long_term_trend_mins,
	lp2.cm_short_term_trend_secs as pattern_a2_ll2_cm_short_term_trend_secs,
	lp2.detection_peristence_secs as pattern_a2_ll2_detection_peristence_secs,
	lp2.detector as pattern_a2_ll2_detector,
	--
	bp3.bandpass_threshold as pattern_b1_bp3_bandpass_threshold,
	bp3.cm_max_frequency_hz as pattern_b1_bp3_cm_max_frequency_hz,
	bp3.cm_max_frequency_shape as pattern_b1_bp3_cm_max_frequency_shape,
	bp3.cm_min_amplitude_prcnt as pattern_b1_bp3_cm_min_amplitude_prcnt,
	bp3.cm_min_duration_secs as pattern_b1_bp3_cm_min_duration_secs,
	bp3.cm_min_frequency_hz as pattern_b1_bp3_cm_min_frequency_hz,
	bp3.cm_min_frequency_shape as pattern_b1_bp3_cm_min_frequency_shape,
	bp3.detection_analysis_window_ms as pattern_b1_bp3_detection_analysis_window_ms,
	bp3.detection_persistence_secs as pattern_b1_bp3_detection_persistence_secs,
	bp3.inversion as pattern_b1_bp3_inversion,
	bp3.max_frequency_min_width_ms as pattern_b1_bp3_max_frequency_min_width_ms,
	bp3.min_amplitude as pattern_b1_bp3_min_amplitude,
	bp3.min_amplitude_bandpass_hysteresis as pattern_b1_bp3_min_amplitude_bandpass_hysteresis,
	bp3.min_frequency_cnt_criterion as pattern_b1_bp3_min_frequency_cnt_criterion,
	bp3.min_frequency_window_ms as pattern_b1_bp3_min_frequency_window_ms,
	--
	lp3.cm_detection_threshold_prcnt as pattern_b1_ll3_threshold_prcnt,
	lp3.cm_long_term_trend_mins as pattern_b1_ll3_cm_long_term_trend_mins,
	lp3.cm_short_term_trend_secs as pattern_b1_ll3_cm_short_term_trend_secs,
	lp3.detection_peristence_secs as pattern_b1_ll3_detection_peristence_secs,
	lp3.detector as pattern_b1_ll3_detector,
	--
	bp4.bandpass_threshold as pattern_b2_bp4_bandpass_threshold,
	bp4.cm_max_frequency_hz as pattern_b2_bp4_cm_max_frequency_hz,
	bp4.cm_max_frequency_shape as pattern_b2_bp4_cm_max_frequency_shape,
	bp4.cm_min_amplitude_prcnt as pattern_b2_bp4_cm_min_amplitude_prcnt,
	bp4.cm_min_duration_secs as pattern_b2_bp4_cm_min_duration_secs,
	bp4.cm_min_frequency_hz as pattern_b2_bp4_cm_min_frequency_hz,
	bp4.cm_min_frequency_shape as pattern_b2_bp4_cm_min_frequency_shape,
	bp4.detection_analysis_window_ms as pattern_b2_bp4_detection_analysis_window_ms,
	bp4.detection_persistence_secs as pattern_b2_bp4_detection_persistence_secs,
	bp4.inversion as pattern_b2_bp4_inversion,
	bp4.max_frequency_min_width_ms as pattern_b2_bp4_max_frequency_min_width_ms,
	bp4.min_amplitude as pattern_b2_bp4_min_amplitude,
	bp4.min_amplitude_bandpass_hysteresis as pattern_b2_bp4_min_amplitude_bandpass_hysteresis,
	bp4.min_frequency_cnt_criterion as pattern_b2_bp4_min_frequency_cnt_criterion,
	bp4.min_frequency_window_ms as pattern_b2_bp4_min_frequency_window_ms,
	--
	lp4.cm_detection_threshold_prcnt as pattern_b2_ll4_threshold_prcnt,
	lp4.cm_long_term_trend_mins as pattern_b2_ll4_cm_long_term_trend_mins,
	lp4.cm_short_term_trend_secs as pattern_b2_ll4_cm_short_term_trend_secs,
	lp4.detection_peristence_secs as pattern_b2_ll4_detection_peristence_secs,
	lp4.detector as pattern_b21_ll4_detector,
	--
	perts_t1b1.adaptation as t1b1_adaptation,
	perts_t1b1.burst_duration_ms as t1b1_burst_duration_ms,
	perts_t1b1.can as t1b1_can,
	perts_t1b1.channel1_neg as t1b1_channel1_neg,
	perts_t1b1.channel1_pos as t1b1_channel1_pos,
	perts_t1b1.channel2_neg as t1b1_channel2_neg,
	perts_t1b1.channel2_pos as t1b1_channel2_pos,
	perts_t1b1.channel3_neg as t1b1_channel3_neg,
	perts_t1b1.channel3_pos as t1b1_channel3_pos,
	perts_t1b1.channel4_neg as t1b1_channel4_neg,
	perts_t1b1.channel4_pos as t1b1_channel4_pos,
	perts_t1b1.current_ma as t1b1_current_ma,
	perts_t1b1.estimated_charge_density_uc_cm_sq as t1b1_estimated_charge_density_uc_cm_sq,
	perts_t1b1.frequency_hz as t1b1_frequency_hz,
	perts_t1b1.frequency_ms as t1b1_frequency_ms,
	perts_t1b1.pw_per_phase_us as t1b1_pw_per_phase_us,
	case when perts_t1b1.response_nm is null then 'Off' when perts_t1b1.response_nm in ('Pattern A', 'Pattern B') then perts_t1b1.response_nm else 'Any Detection' end as t1b1_response_nm,
	perts_t1b1.synchronization as t1b1_synchronization,
	--
	perts_t1b2.adaptation as t1b2_adaptation,
	perts_t1b2.burst_duration_ms as t1b2_burst_duration_ms,
	perts_t1b2.can as t1b2_can,
	perts_t1b2.channel1_neg as t1b2_channel1_neg,
	perts_t1b2.channel1_pos as t1b2_channel1_pos,
	perts_t1b2.channel2_neg as t1b2_channel2_neg,
	perts_t1b2.channel2_pos as t1b2_channel2_pos,
	perts_t1b2.channel3_neg as t1b2_channel3_neg,
	perts_t1b2.channel3_pos as t1b2_channel3_pos,
	perts_t1b2.channel4_neg as t1b2_channel4_neg,
	perts_t1b2.channel4_pos as t1b2_channel4_pos,
	perts_t1b2.current_ma as t1b2_current_ma,
	perts_t1b2.estimated_charge_density_uc_cm_sq as t1b2_estimated_charge_density_uc_cm_sq,
	perts_t1b2.frequency_hz as t1b2_frequency_hz,
	perts_t1b2.frequency_ms as t1b2_frequency_ms,
	perts_t1b2.pw_per_phase_us as t1b2_pw_per_phase_us,
	case when perts_t1b2.response_nm is null then 'Off' when perts_t1b2.response_nm in ('Pattern A', 'Pattern B') then perts_t1b2.response_nm else 'Any Detection' end as t1b2_response_nm,
	perts_t1b2.synchronization as t1b2_synchronization,
	--
	perts_t2b1.adaptation as t2b1_adaptation,
	perts_t2b1.burst_duration_ms as t2b1_burst_duration_ms,
	perts_t2b1.can as t2b1_can,
	perts_t2b1.channel1_neg as t2b1_channel1_neg,
	perts_t2b1.channel1_pos as t2b1_channel1_pos,
	perts_t2b1.channel2_neg as t2b1_channel2_neg,
	perts_t2b1.channel2_pos as t2b1_channel2_pos,
	perts_t2b1.channel3_neg as t2b1_channel3_neg,
	perts_t2b1.channel3_pos as t2b1_channel3_pos,
	perts_t2b1.channel4_neg as t2b1_channel4_neg,
	perts_t2b1.channel4_pos as t2b1_channel4_pos,
	perts_t2b1.current_ma as t2b1_current_ma,
	perts_t2b1.estimated_charge_density_uc_cm_sq as t2b1_estimated_charge_density_uc_cm_sq,
	perts_t2b1.frequency_hz as t2b1_frequency_hz,
	perts_t2b1.frequency_ms as t2b1_frequency_ms,
	perts_t2b1.pw_per_phase_us as t2b1_pw_per_phase_us,
	case when perts_t2b1.response_nm is null then 'Off' when perts_t2b1.response_nm in ('Pattern A', 'Pattern B') then perts_t2b1.response_nm else 'Any Detection' end as t2b1_response_nm,
	perts_t2b1.synchronization as t2b1_synchronization,
	--
	perts_t2b2.adaptation as t2b2_adaptation,
	perts_t2b2.burst_duration_ms as t2b2_burst_duration_ms,
	perts_t2b2.can as t2b2_can,
	perts_t2b2.channel1_neg as t2b2_channel1_neg,
	perts_t2b2.channel1_pos as t2b2_channel1_pos,
	perts_t2b2.channel2_neg as t2b2_channel2_neg,
	perts_t2b2.channel2_pos as t2b2_channel2_pos,
	perts_t2b2.channel3_neg as t2b2_channel3_neg,
	perts_t2b2.channel3_pos as t2b2_channel3_pos,
	perts_t2b2.channel4_neg as t2b2_channel4_neg,
	perts_t2b2.channel4_pos as t2b2_channel4_pos,
	perts_t2b2.current_ma as t2b2_current_ma,
	perts_t2b2.estimated_charge_density_uc_cm_sq as t2b2_estimated_charge_density_uc_cm_sq,
	perts_t2b2.frequency_hz as t2b2_frequency_hz,
	perts_t2b2.frequency_ms as t2b2_frequency_ms,
	perts_t2b2.pw_per_phase_us as t2b2_pw_per_phase_us,
	case when perts_t2b2.response_nm is null then 'Off' when perts_t2b2.response_nm in ('Pattern A', 'Pattern B') then perts_t2b2.response_nm else 'Any Detection' end as t2b2_response_nm,
	perts_t2b2.synchronization as t2b2_synchronization,
	--
	perts_t3b1.adaptation as t3b1_adaptation,
	perts_t3b1.burst_duration_ms as t3b1_burst_duration_ms,
	perts_t3b1.can as t3b1_can,
	perts_t3b1.channel1_neg as t3b1_channel1_neg,
	perts_t3b1.channel1_pos as t3b1_channel1_pos,
	perts_t3b1.channel2_neg as t3b1_channel2_neg,
	perts_t3b1.channel2_pos as t3b1_channel2_pos,
	perts_t3b1.channel3_neg as t3b1_channel3_neg,
	perts_t3b1.channel3_pos as t3b1_channel3_pos,
	perts_t3b1.channel4_neg as t3b1_channel4_neg,
	perts_t3b1.channel4_pos as t3b1_channel4_pos,
	perts_t3b1.current_ma as t3b1_current_ma,
	perts_t3b1.estimated_charge_density_uc_cm_sq as t3b1_estimated_charge_density_uc_cm_sq,
	perts_t3b1.frequency_hz as t3b1_frequency_hz,
	perts_t3b1.frequency_ms as t3b1_frequency_ms,
	perts_t3b1.pw_per_phase_us as t3b1_pw_per_phase_us,
	case when perts_t3b1.response_nm is null then 'Off' when perts_t3b1.response_nm in ('Pattern A', 'Pattern B') then perts_t3b1.response_nm else 'Any Detection' end as t3b1_response_nm,
	perts_t3b1.synchronization as t3b1_synchronization,
	--
	perts_t3b2.adaptation as t3b2_adaptation,
	perts_t3b2.burst_duration_ms as t3b2_burst_duration_ms,
	perts_t3b2.can as t3b2_can,
	perts_t3b2.channel1_neg as t3b2_channel1_neg,
	perts_t3b2.channel1_pos as t3b2_channel1_pos,
	perts_t3b2.channel2_neg as t3b2_channel2_neg,
	perts_t3b2.channel2_pos as t3b2_channel2_pos,
	perts_t3b2.channel3_neg as t3b2_channel3_neg,
	perts_t3b2.channel3_pos as t3b2_channel3_pos,
	perts_t3b2.channel4_neg as t3b2_channel4_neg,
	perts_t3b2.channel4_pos as t3b2_channel4_pos,
	perts_t3b2.current_ma as t3b2_current_ma,
	perts_t3b2.estimated_charge_density_uc_cm_sq as t3b2_estimated_charge_density_uc_cm_sq,
	perts_t3b2.frequency_hz as t3b2_frequency_hz,
	perts_t3b2.frequency_ms as t3b2_frequency_ms,
	perts_t3b2.pw_per_phase_us as t3b2_pw_per_phase_us,
	case when perts_t3b2.response_nm is null then 'Off' when perts_t3b2.response_nm in ('Pattern A', 'Pattern B') then perts_t3b2.response_nm else 'Any Detection' end as t3b2_response_nm,
	perts_t3b2.synchronization as t3b2_synchronization,
	--
	perts_t4b1.adaptation as t4b1_adaptation,
	perts_t4b1.burst_duration_ms as t4b1_burst_duration_ms,
	perts_t4b1.can as t4b1_can,
	perts_t4b1.channel1_neg as t4b1_channel1_neg,
	perts_t4b1.channel1_pos as t4b1_channel1_pos,
	perts_t4b1.channel2_neg as t4b1_channel2_neg,
	perts_t4b1.channel2_pos as t4b1_channel2_pos,
	perts_t4b1.channel3_neg as t4b1_channel3_neg,
	perts_t4b1.channel3_pos as t4b1_channel3_pos,
	perts_t4b1.channel4_neg as t4b1_channel4_neg,
	perts_t4b1.channel4_pos as t4b1_channel4_pos,
	perts_t4b1.current_ma as t4b1_current_ma,
	perts_t4b1.estimated_charge_density_uc_cm_sq as t4b1_estimated_charge_density_uc_cm_sq,
	perts_t4b1.frequency_hz as t4b1_frequency_hz,
	perts_t4b1.frequency_ms as t4b1_frequency_ms,
	perts_t4b1.pw_per_phase_us as t4b1_pw_per_phase_us,
	case when perts_t4b1.response_nm is null then 'Off' when perts_t4b1.response_nm in ('Pattern A', 'Pattern B') then perts_t4b1.response_nm else 'Any Detection' end as t4b1_response_nm,
	perts_t4b1.synchronization as t4b1_synchronization,
	--
	perts_t4b2.adaptation as t4b2_adaptation,
	perts_t4b2.burst_duration_ms as t4b2_burst_duration_ms,
	perts_t4b2.can as t4b2_can,
	perts_t4b2.channel1_neg as t4b2_channel1_neg,
	perts_t4b2.channel1_pos as t4b2_channel1_pos,
	perts_t4b2.channel2_neg as t4b2_channel2_neg,
	perts_t4b2.channel2_pos as t4b2_channel2_pos,
	perts_t4b2.channel3_neg as t4b2_channel3_neg,
	perts_t4b2.channel3_pos as t4b2_channel3_pos,
	perts_t4b2.channel4_neg as t4b2_channel4_neg,
	perts_t4b2.channel4_pos as t4b2_channel4_pos,
	perts_t4b2.current_ma as t4b2_current_ma,
	perts_t4b2.estimated_charge_density_uc_cm_sq as t4b2_estimated_charge_density_uc_cm_sq,
	perts_t4b2.frequency_hz as t4b2_frequency_hz,
	perts_t4b2.frequency_ms as t4b2_frequency_ms,
	perts_t4b2.pw_per_phase_us as t4b2_pw_per_phase_us,
	case when perts_t4b2.response_nm is null then 'Off' when perts_t4b2.response_nm in ('Pattern A', 'Pattern B') then perts_t4b2.response_nm else 'Any Detection' end as t4b2_response_nm,
	perts_t4b2.synchronization as t4b2_synchronization,
	--
	perts_t5b1.adaptation as t5b1_adaptation,
	perts_t5b1.burst_duration_ms as t5b1_burst_duration_ms,
	perts_t5b1.can as t5b1_can,
	perts_t5b1.channel1_neg as t5b1_channel1_neg,
	perts_t5b1.channel1_pos as t5b1_channel1_pos,
	perts_t5b1.channel2_neg as t5b1_channel2_neg,
	perts_t5b1.channel2_pos as t5b1_channel2_pos,
	perts_t5b1.channel3_neg as t5b1_channel3_neg,
	perts_t5b1.channel3_pos as t5b1_channel3_pos,
	perts_t5b1.channel4_neg as t5b1_channel4_neg,
	perts_t5b1.channel4_pos as t5b1_channel4_pos,
	perts_t5b1.current_ma as t5b1_current_ma,
	perts_t5b1.estimated_charge_density_uc_cm_sq as t5b1_estimated_charge_density_uc_cm_sq,
	perts_t5b1.frequency_hz as t5b1_frequency_hz,
	perts_t5b1.frequency_ms as t5b1_frequency_ms,
	perts_t5b1.pw_per_phase_us as t5b1_pw_per_phase_us,
	case when perts_t5b1.response_nm is null then 'Off' when perts_t5b1.response_nm in ('Pattern A', 'Pattern B') then perts_t5b1.response_nm else 'Any Detection' end as t5b1_response_nm,
	perts_t5b1.synchronization as t5b1_synchronization,
	--
	perts_t5b2.adaptation as t5b2_adaptation,
	perts_t5b2.burst_duration_ms as t5b2_burst_duration_ms,
	perts_t5b2.can as t5b2_can,
	perts_t5b2.channel1_neg as t5b2_channel1_neg,
	perts_t5b2.channel1_pos as t5b2_channel1_pos,
	perts_t5b2.channel2_neg as t5b2_channel2_neg,
	perts_t5b2.channel2_pos as t5b2_channel2_pos,
	perts_t5b2.channel3_neg as t5b2_channel3_neg,
	perts_t5b2.channel3_pos as t5b2_channel3_pos,
	perts_t5b2.channel4_neg as t5b2_channel4_neg,
	perts_t5b2.channel4_pos as t5b2_channel4_pos,
	perts_t5b2.current_ma as t5b2_current_ma,
	perts_t5b2.estimated_charge_density_uc_cm_sq as t5b2_estimated_charge_density_uc_cm_sq,
	perts_t5b2.frequency_hz as t5b2_frequency_hz,
	perts_t5b2.frequency_ms as t5b2_frequency_ms,
	perts_t5b2.pw_per_phase_us as t5b2_pw_per_phase_us,
	case when perts_t5b2.response_nm is null then 'Off' when perts_t5b2.response_nm in ('Pattern A', 'Pattern B') then perts_t5b2.response_nm else 'Any Detection' end as t5b2_response_nm,
	perts_t5b2.synchronization as t5b2_synchronization,
	--
	pes.long_episode_threshold,
	pes.sat_detector1,
	pes.sat_detector2,
	--
	pes.epoch_length,
	pes.episodes_per_day,
	pes.therapies_per_day,
	pes.long_episodes_per_month,
	pes.long_episodes_total,
	pes.saturations_per_month,
	pes.saturations_total,
	pes.magnets_per_month,
	pes.magnets_total
from rns_ods.programming_epochs pe
join xref.patient_ids x
	on x.xref_id = pe.patient_id
		and x.xref_src = 'pdms_patient_at_center_id'
join rns_ods.programming_epoch_montages m
	on pe.programming_epoch_id = m.programming_epoch_id
join rns_ods.programming_epoch_detection_settings peds
	on m.programming_epoch_id = peds.programming_epoch_id
--
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp1
	on bp1.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp1.pattern = 'Pattern A' and bp1.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp2
	on bp2.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp2.pattern = 'Pattern A' and bp2.detector = 'Second Detector'
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp3
	on bp3.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp3.pattern = 'Pattern B' and bp3.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_bandpass_parameters bp4
	on bp4.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and bp4.pattern = 'Pattern B' and bp4.detector = 'Second Detector'
--
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp1
	on lp1.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp1.pattern = 'Pattern A' and lp1.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp2
	on lp2.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp2.pattern = 'Pattern A' and lp2.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp3
	on lp3.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp3.pattern = 'Pattern A' and lp3.detector = 'First Detector'
left join rns_ods.programming_epoch_detection_setting_linelength_parameters lp4
	on lp4.programming_epoch_detection_setting_id = peds.programming_epoch_detection_setting_id
		and lp4.pattern = 'Pattern A' and lp4.detector = 'First Detector'
--
left join rns_ods.programming_epoch_responsive_therapies pert
	on pe.programming_epoch_id = pert.programming_epoch_id
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t1b1
	on pert.programming_epoch_responsive_therapy_id = perts_t1b1.programming_epoch_responsive_therapy_id
		and perts_t1b1.therapy like 'Therapy #1%' and perts_t1b1.response_nm in ('Burst #1', 'Pattern A')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t1b2
	on pert.programming_epoch_responsive_therapy_id = perts_t1b2.programming_epoch_responsive_therapy_id
		and perts_t1b2.therapy like 'Therapy #1%' and perts_t1b2.response_nm in ('Burst #2', 'Pattern B')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t2b1
	on pert.programming_epoch_responsive_therapy_id = perts_t2b1.programming_epoch_responsive_therapy_id
		and perts_t2b1.therapy like 'Therapy #2%' and perts_t2b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t2b2
	on pert.programming_epoch_responsive_therapy_id = perts_t2b2.programming_epoch_responsive_therapy_id
		and perts_t2b2.therapy like 'Therapy #2%' and perts_t2b2.response_nm in ('Burst #2')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t3b1
	on pert.programming_epoch_responsive_therapy_id = perts_t3b1.programming_epoch_responsive_therapy_id
		and perts_t3b1.therapy like 'Therapy #3%' and perts_t3b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t3b2
	on pert.programming_epoch_responsive_therapy_id = perts_t2b2.programming_epoch_responsive_therapy_id
		and perts_t2b2.therapy like 'Therapy #3%' and perts_t2b2.response_nm in ('Burst #2')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t4b1
	on pert.programming_epoch_responsive_therapy_id = perts_t4b1.programming_epoch_responsive_therapy_id
		and perts_t4b1.therapy like 'Therapy #4%' and perts_t4b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t4b2
	on pert.programming_epoch_responsive_therapy_id = perts_t4b2.programming_epoch_responsive_therapy_id
		and perts_t4b2.therapy like 'Therapy #4%' and perts_t4b2.response_nm in ('Burst #2')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t5b1
	on pert.programming_epoch_responsive_therapy_id = perts_t5b1.programming_epoch_responsive_therapy_id
		and perts_t5b1.therapy like 'Therapy #5%' and perts_t5b1.response_nm in ('Burst #1')
left join rns_dm.programming_epoch_responsive_therapy_settings perts_t5b2
	on pert.programming_epoch_responsive_therapy_id = perts_t5b2.programming_epoch_responsive_therapy_id
		and perts_t5b2.therapy like 'Therapy #5%' and perts_t5b2.response_nm in ('Burst #2')
left join rns_ods.programming_epoch_summaries pes
	on pes.patient_id = pe.patient_id
		and pes.programming_dts = pe.programming_dts
where x.rns_deid_id = @rns_deid_id
order by pe.programming_dts asc
END


GO


USE [RNS]
GO

/****** Object:  View [rns_dm].[ltnd_impedance_measurements]    Script Date: 10/25/2018 1:08:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [rns_dm].[ltnd_impedance_measurements] as
select *
from
(
	select
		x.rns_deid_id,
		im.measurement_dts,
		im.lead_nm,
		im.lead_ohms
	from rns_ods.impedance_measurements im
	join xref.patient_ids x
		on x.xref_id = im.patient_id
			and x.xref_src = 'pdms_patient_at_center_id'
) d
pivot
(
	max(lead_ohms) for lead_nm in 
	(
		lead_1_measurements,
		lead_2_measurements,
		lead_3_measurements,
		lead_4_measurements,
		lead_5_measurements,
		lead_6_measurements,
		lead_7_measurements,
		lead_8_measurements
	)
) p
GO


USE [RNS]
GO

/****** Object:  View [rns_dm].[ltnd_impedance_scale_factors]    Script Date: 10/25/2018 1:08:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [rns_dm].[ltnd_impedance_scale_factors] as
select
	lim.rns_deid_id,
	lim.measurement_dts,
	nm.next_measurement_dts,
	a.programming_dts,
	(lim.lead_1_measurements + lim.lead_2_measurements) / 2 as channel1_avg,
	(lim.lead_3_measurements + lim.lead_4_measurements) / 2 as channel2_avg,
	(lim.lead_5_measurements + lim.lead_6_measurements) / 2 as channel3_avg,
	(lim.lead_7_measurements + lim.lead_8_measurements) / 2 as channel4_avg,
	a.avg_ohms as pe_avg,
	1 / (((lim.lead_1_measurements + lim.lead_2_measurements) / 2) / a.avg_ohms) as channel1_sf,
	1 / (((lim.lead_3_measurements + lim.lead_4_measurements) / 2) / a.avg_ohms) as channel2_sf,
	1 / (((lim.lead_5_measurements + lim.lead_6_measurements) / 2) / a.avg_ohms) as channel3_sf,
	1 / (((lim.lead_7_measurements + lim.lead_8_measurements) / 2) / a.avg_ohms) as channel4_sf
from rns_dm.ltnd_impedance_measurements lim
join
(
	select
		spe.rns_deid_id,
		spe.programming_dts,
		spe.next_programming_dts,
		avg(im.lead_ohms) as avg_ohms,
		stdev(im.lead_ohms) as stdev_ohms
	from rns_dm.sm_programming_epochs spe
	join xref.patient_ids x
		on spe.rns_deid_id = x.rns_deid_id
			and x.xref_src = 'pdms_patient_at_center_id'
	join rns_ods.impedance_measurements im
		on x.xref_id = im.patient_id
			and measurement_dts between spe.programming_dts and spe.next_programming_dts
	group by
		spe.rns_deid_id,
		spe.programming_dts,
		coalescespe.next_programming_dts
) a
	on lim.rns_deid_id = a.rns_deid_id
		and lim.measurement_dts between a.programming_dts and a.next_programming_dts

GO


USE [RNS]
GO

/****** Object:  View [rns_dm].[unloaded_ieeg_files]    Script Date: 10/28/2018 7:18:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [rns_dm].[unloaded_ieeg_files] as
select *
from rns_ods.files f
where
	f.extension = '.dat'
	and not exists
(
	select 'x'
	from rns_ods.ieeg_data d
	where f.[file_id] = d.[file_id]
)
GO


