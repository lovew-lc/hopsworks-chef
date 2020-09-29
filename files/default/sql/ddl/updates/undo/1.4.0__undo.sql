ALTER TABLE `hopsworks`.`conda_commands` ADD COLUMN `host_id` int(11) NOT NULL;
ALTER TABLE `hopsworks`.`conda_commands` ADD KEY (`host_id`);
ALTER TABLE `hopsworks`.`conda_commands` ADD CONSTRAINT `FK_481_519` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION ;
ALTER TABLE `hopsworks`.`conda_commands` ADD COLUMN `proj` varchar(255) COLLATE latin1_general_cs NOT NULL;
ALTER TABLE `hopsworks`.`conda_commands` DROP COLUMN `error_message`;
ALTER TABLE `hopsworks`.`conda_commands` CHANGE `environment_yml` `environment_yml` VARCHAR(10000) COLLATE latin1_general_cs DEFAULT NULL;
ALTER TABLE `hopsworks`.`conda_commands` ADD COLUMN `machine_type` varchar(52) COLLATE latin1_general_cs DEFAULT NULL;

ALTER TABLE `hopsworks`.`jupyter_project` CHANGE `cid` `pid` bigint(20) NOT NULL;
ALTER TABLE `hopsworks`.`tensorboard` CHANGE `cid` `pid` bigint(20) NOT NULL;
ALTER TABLE `hopsworks`.`serving` CHANGE `cid` `local_pid` bigint(20) NOT NULL;

ALTER TABLE `hopsworks`.`jupyter_settings` CHANGE COLUMN `base_dir` `base_dir` varchar(255) COLLATE latin1_general_cs DEFAULT '/Jupyter/';

SET SQL_SAFE_UPDATES = 0;
UPDATE `hopsworks`.`jupyter_settings` `j`
JOIN `hopsworks`.`project` `p`
ON `j`.`project_id` = `p`.`id`
SET `j`.`base_dir` = '/Jupyter/';
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE `hopsworks`.`jupyter_git_config` DROP COLUMN `git_backend`;

ALTER TABLE `hopsworks`.`python_dep` DROP COLUMN `base_env`;
ALTER TABLE `hopsworks`.`python_dep` DROP INDEX `dependency`;
ALTER TABLE `hopsworks`.`python_dep` ADD COLUMN `machine_type` int(11) NOT NULL;
ALTER TABLE `hopsworks`.`python_dep` ADD CONSTRAINT `dependency` UNIQUE (`dependency`,`version`,`install_type`,`repo_id`,`machine_type`);

ALTER TABLE `hopsworks`.`hosts` ADD COLUMN `conda_enabled` tinyint(1) NOT NULL DEFAULT '1';

CREATE TABLE IF NOT EXISTS `online_feature_group` (
  `id`                                INT(11)         NOT NULL AUTO_INCREMENT,
  `db_name`                           VARCHAR(5000)   NOT NULL,
  `table_name`                        VARCHAR(5000)    NOT NULL,
  PRIMARY KEY (`id`)
)
  ENGINE = ndbcluster
  DEFAULT CHARSET = latin1
  COLLATE = latin1_general_cs;

ALTER TABLE `hopsworks`.`cached_feature_group` DROP COLUMN `online_enabled`;
ALTER TABLE `hopsworks`.`cached_feature_group` DROP COLUMN `default_storage`;

ALTER TABLE `hopsworks`.`cached_feature_group` ADD COLUMN `online_feature_group` INT(11) DEFAULT NULL; 

ALTER TABLE `hopsworks`.`cached_feature_group` ADD FOREIGN KEY `online_fg_fk` (`online_feature_group`) REFERENCES `online_feature_group` (`id`)  ON DELETE SET NULL ON UPDATE NO ACTION; 

CREATE TABLE `hopsworks`.`tf_lib_mapping` (
  `tf_version` varchar(20) COLLATE latin1_general_cs NOT NULL,
  `cuda_version` varchar(20) COLLATE latin1_general_cs NOT NULL,
  `cudnn_version` varchar(20) COLLATE latin1_general_cs NOT NULL,
  `nccl_version` varchar(20) COLLATE latin1_general_cs NOT NULL,
  PRIMARY KEY (`tf_version`)
) ENGINE=ndbcluster DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

ALTER TABLE `hopsworks`.`project` DROP COLUMN `docker_image`;
ALTER TABLE `hopsworks`.`project` ADD COLUMN `conda_env` tinyint(1) DEFAULT '0';


ALTER TABLE `hopsworks`.`feature_store_s3_connector` DROP COLUMN `server_encryption_algorithm`;
ALTER TABLE `hopsworks`.`feature_store_s3_connector` DROP COLUMN `server_encryption_key`;

ALTER TABLE `hopsworks`.`training_dataset_split` DROP INDEX `dataset_id_split_name`;

ALTER TABLE `hopsworks`.`remote_user` DROP COLUMN `status`;

ALTER TABLE `hopsworks`.`dataset` DROP COLUMN `permission`;
ALTER TABLE `hopsworks`.`dataset_shared_with` DROP COLUMN `permission`;

ALTER TABLE `hopsworks`.`activity` CHANGE COLUMN `activity` `activity` VARCHAR(128) COLLATE latin1_general_cs NOT NULL;

UPDATE `hopsworks`.`anaconda_repo` SET `url`="PyPi" WHERE `url`="pypi";

DROP TABLE IF EXISTS `remote_group_project_mapping`; 