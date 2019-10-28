

DROP TABLE IF EXISTS `BUNDLE_ACTIONS`;

CREATE TABLE `BUNDLE_ACTIONS` (
  `bundle_action_id` varchar(255) NOT NULL,
  `bundle_id` varchar(255) DEFAULT NULL,
  `coord_id` varchar(255) DEFAULT NULL,
  `coord_name` varchar(255) DEFAULT NULL,
  `critical` int(11) DEFAULT NULL,
  `last_modified_time` datetime DEFAULT NULL,
  `pending` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`bundle_action_id`),
  KEY `I_BNDLTNS_BUNDLE_ID` (`bundle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `BUNDLE_JOBS`;

CREATE TABLE `BUNDLE_JOBS` (
  `id` varchar(255) NOT NULL,
  `app_name` varchar(255) DEFAULT NULL,
  `app_path` varchar(255) DEFAULT NULL,
  `conf` mediumblob,
  `created_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `job_xml` mediumblob,
  `kickoff_time` datetime DEFAULT NULL,
  `last_modified_time` datetime DEFAULT NULL,
  `orig_job_xml` mediumblob,
  `pause_time` datetime DEFAULT NULL,
  `pending` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `suspended_time` datetime DEFAULT NULL,
  `time_out` int(11) DEFAULT NULL,
  `time_unit` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_BNDLJBS_CREATED_TIME` (`created_time`),
  KEY `I_BNDLJBS_LAST_MODIFIED_TIME` (`last_modified_time`),
  KEY `I_BNDLJBS_STATUS` (`status`),
  KEY `I_BNDLJBS_SUSPENDED_TIME` (`suspended_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `COORD_ACTIONS`;

CREATE TABLE `COORD_ACTIONS` (
  `id` varchar(255) NOT NULL,
  `action_number` int(11) DEFAULT NULL,
  `action_xml` mediumblob,
  `console_url` varchar(255) DEFAULT NULL,
  `created_conf` mediumblob,
  `created_time` datetime DEFAULT NULL,
  `error_code` varchar(255) DEFAULT NULL,
  `error_message` varchar(255) DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `external_status` varchar(255) DEFAULT NULL,
  `job_id` varchar(255) DEFAULT NULL,
  `last_modified_time` datetime DEFAULT NULL,
  `missing_dependencies` mediumblob,
  `nominal_time` datetime DEFAULT NULL,
  `pending` int(11) DEFAULT NULL,
  `push_missing_dependencies` mediumblob,
  `rerun_time` datetime DEFAULT NULL,
  `run_conf` mediumblob,
  `sla_xml` mediumblob,
  `status` varchar(255) DEFAULT NULL,
  `time_out` int(11) DEFAULT NULL,
  `tracker_uri` varchar(255) DEFAULT NULL,
  `job_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_CRD_TNS_CREATED_TIME` (`created_time`),
  KEY `I_CRD_TNS_EXTERNAL_ID` (`external_id`),
  KEY `I_CRD_TNS_JOB_ID` (`job_id`),
  KEY `I_CRD_TNS_LAST_MODIFIED_TIME` (`last_modified_time`),
  KEY `I_CRD_TNS_NOMINAL_TIME` (`nominal_time`),
  KEY `I_CRD_TNS_RERUN_TIME` (`rerun_time`),
  KEY `I_CRD_TNS_STATUS` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `COORD_JOBS`;

CREATE TABLE `COORD_JOBS` (
  `id` varchar(255) NOT NULL,
  `app_name` varchar(255) DEFAULT NULL,
  `app_namespace` varchar(255) DEFAULT NULL,
  `app_path` varchar(255) DEFAULT NULL,
  `bundle_id` varchar(255) DEFAULT NULL,
  `concurrency` int(11) DEFAULT NULL,
  `conf` mediumblob,
  `created_time` datetime DEFAULT NULL,
  `done_materialization` int(11) DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `execution` varchar(255) DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `job_xml` mediumblob,
  `last_action_number` int(11) DEFAULT NULL,
  `last_action` datetime DEFAULT NULL,
  `last_modified_time` datetime DEFAULT NULL,
  `mat_throttling` int(11) DEFAULT NULL,
  `next_matd_time` datetime DEFAULT NULL,
  `orig_job_xml` mediumblob,
  `pause_time` datetime DEFAULT NULL,
  `pending` int(11) DEFAULT NULL,
  `sla_xml` mediumblob,
  `start_time` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `suspended_time` datetime DEFAULT NULL,
  `time_out` int(11) DEFAULT NULL,
  `time_unit` varchar(255) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_CRD_JBS_BUNDLE_ID` (`bundle_id`),
  KEY `I_CRD_JBS_CREATED_TIME` (`created_time`),
  KEY `I_CRD_JBS_END_TIME` (`end_time`),
  KEY `I_CRD_JBS_LAST_MODIFIED_TIME` (`last_modified_time`),
  KEY `I_CRD_JBS_NEXT_MATD_TIME` (`next_matd_time`),
  KEY `I_CRD_JBS_STATUS` (`status`),
  KEY `I_CRD_JBS_SUSPENDED_TIME` (`suspended_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `OOZIE_SYS`;

CREATE TABLE `OOZIE_SYS` (
  `name` varchar(100) DEFAULT NULL,
  `data` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `OPENJPA_SEQUENCE_TABLE`;

CREATE TABLE `OPENJPA_SEQUENCE_TABLE` (
  `ID` tinyint(4) NOT NULL,
  `SEQUENCE_VALUE` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SLA_EVENTS`;

CREATE TABLE `SLA_EVENTS` (
  `event_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `alert_contact` varchar(255) DEFAULT NULL,
  `alert_frequency` varchar(255) DEFAULT NULL,
  `alert_percentage` varchar(255) DEFAULT NULL,
  `app_name` varchar(255) DEFAULT NULL,
  `dev_contact` varchar(255) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `job_data` text,
  `notification_msg` text,
  `parent_client_id` varchar(255) DEFAULT NULL,
  `parent_sla_id` varchar(255) DEFAULT NULL,
  `qa_contact` varchar(255) DEFAULT NULL,
  `se_contact` varchar(255) DEFAULT NULL,
  `sla_id` varchar(255) DEFAULT NULL,
  `upstream_apps` text,
  `user_name` varchar(255) DEFAULT NULL,
  `bean_type` varchar(31) DEFAULT NULL,
  `app_type` varchar(255) DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `expected_end` datetime DEFAULT NULL,
  `expected_start` datetime DEFAULT NULL,
  `job_status` varchar(255) DEFAULT NULL,
  `status_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `I_SL_VNTS_DTYPE` (`bean_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SLA_REGISTRATION`;

CREATE TABLE `SLA_REGISTRATION` (
  `job_id` varchar(255) NOT NULL,
  `app_name` varchar(255) DEFAULT NULL,
  `app_type` varchar(255) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `expected_duration` bigint(20) DEFAULT NULL,
  `expected_end` datetime DEFAULT NULL,
  `expected_start` datetime DEFAULT NULL,
  `job_data` varchar(255) DEFAULT NULL,
  `nominal_time` datetime DEFAULT NULL,
  `notification_msg` varchar(255) DEFAULT NULL,
  `parent_id` varchar(255) DEFAULT NULL,
  `sla_config` varchar(255) DEFAULT NULL,
  `upstream_apps` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `I_SL_RRTN_NOMINAL_TIME` (`nominal_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SLA_SUMMARY`;

CREATE TABLE `SLA_SUMMARY` (
  `job_id` varchar(255) NOT NULL,
  `actual_duration` bigint(20) DEFAULT NULL,
  `actual_end` datetime DEFAULT NULL,
  `actual_start` datetime DEFAULT NULL,
  `app_name` varchar(255) DEFAULT NULL,
  `app_type` varchar(255) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `event_processed` tinyint(4) DEFAULT NULL,
  `event_status` varchar(255) DEFAULT NULL,
  `expected_duration` bigint(20) DEFAULT NULL,
  `expected_end` datetime DEFAULT NULL,
  `expected_start` datetime DEFAULT NULL,
  `job_status` varchar(255) DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `nominal_time` datetime DEFAULT NULL,
  `parent_id` varchar(255) DEFAULT NULL,
  `sla_status` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `I_SL_SMRY_APP_NAME` (`app_name`),
  KEY `I_SL_SMRY_EVENT_PROCESSED` (`event_processed`),
  KEY `I_SL_SMRY_LAST_MODIFIED` (`last_modified`),
  KEY `I_SL_SMRY_NOMINAL_TIME` (`nominal_time`),
  KEY `I_SL_SMRY_PARENT_ID` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `VALIDATE_CONN`;

CREATE TABLE `VALIDATE_CONN` (
  `id` bigint(20) NOT NULL,
  `dummy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `WF_ACTIONS`;

CREATE TABLE `WF_ACTIONS` (
  `id` varchar(255) NOT NULL,
  `conf` mediumblob,
  `console_url` varchar(255) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `cred` varchar(255) DEFAULT NULL,
  `data` mediumblob,
  `end_time` datetime DEFAULT NULL,
  `error_code` varchar(255) DEFAULT NULL,
  `error_message` varchar(500) DEFAULT NULL,
  `execution_path` varchar(1024) DEFAULT NULL,
  `external_child_ids` mediumblob,
  `external_id` varchar(255) DEFAULT NULL,
  `external_status` varchar(255) DEFAULT NULL,
  `last_check_time` datetime DEFAULT NULL,
  `log_token` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `pending` int(11) DEFAULT NULL,
  `pending_age` datetime DEFAULT NULL,
  `retries` int(11) DEFAULT NULL,
  `signal_value` varchar(255) DEFAULT NULL,
  `sla_xml` mediumblob,
  `start_time` datetime DEFAULT NULL,
  `stats` mediumblob,
  `status` varchar(255) DEFAULT NULL,
  `tracker_uri` varchar(255) DEFAULT NULL,
  `transition` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `user_retry_count` int(11) DEFAULT NULL,
  `user_retry_interval` int(11) DEFAULT NULL,
  `user_retry_max` int(11) DEFAULT NULL,
  `wf_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_WF_CTNS_PENDING_AGE` (`pending_age`),
  KEY `I_WF_CTNS_STATUS` (`status`),
  KEY `I_WF_CTNS_WF_ID` (`wf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `WF_JOBS`;

CREATE TABLE `WF_JOBS` (
  `id` varchar(255) NOT NULL,
  `app_name` varchar(255) DEFAULT NULL,
  `app_path` varchar(255) DEFAULT NULL,
  `conf` mediumblob,
  `created_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `last_modified_time` datetime DEFAULT NULL,
  `log_token` varchar(255) DEFAULT NULL,
  `parent_id` varchar(255) DEFAULT NULL,
  `proto_action_conf` mediumblob,
  `run` int(11) DEFAULT NULL,
  `sla_xml` mediumblob,
  `start_time` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `wf_instance` mediumblob,
  PRIMARY KEY (`id`),
  KEY `I_WF_JOBS_END_TIME` (`end_time`),
  KEY `I_WF_JOBS_EXTERNAL_ID` (`external_id`),
  KEY `I_WF_JOBS_LAST_MODIFIED_TIME` (`last_modified_time`),
  KEY `I_WF_JOBS_PARENT_ID` (`parent_id`),
  KEY `I_WF_JOBS_STATUS` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

