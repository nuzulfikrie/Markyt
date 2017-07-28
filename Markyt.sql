-- MySQL Script generated by MySQL Workbench
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema  markyt
-- -----------------------------------------------------
-- Base de datos de  markyt
DROP SCHEMA IF EXISTS ` markyt` ;

-- -----------------------------------------------------
-- Schema  markyt
--
-- Base de datos de  markyt
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS ` markyt` DEFAULT CHARACTER SET utf8 ;
USE ` markyt` ;

-- -----------------------------------------------------
-- Table ` markyt`.`projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`projects` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`projects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  `description` LONGTEXT NULL,
  `relation_level` INT(3) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ` markyt`.`rounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`rounds` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`rounds` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `ends_in_date` DATE NULL,
  `description` TEXT NULL,
  `trim_helper` TINYINT(1) NULL,
  `whole_word_helper` TINYINT(1) NULL,
  `punctuation_helper` TINYINT(1) NULL,
  `start_document` INT UNSIGNED NULL,
  `end_document` INT UNSIGNED NULL,
  `is_visible` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_rounds_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_rounds_projects1_idx` ON ` markyt`.`rounds` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`documents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`documents` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`documents` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` VARCHAR(40) NULL,
  `title` LONGTEXT NOT NULL,
  `created` DATETIME NULL,
  `html` LONGBLOB NOT NULL,
  `raw` LONGBLOB NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ` markyt`.`types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`types` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `colour` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_types_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_types_projects1_idx` ON ` markyt`.`types` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`groups` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ` markyt`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`users` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` INT UNSIGNED NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  `created` TIMESTAMP NULL,
  `modified` TIMESTAMP NULL,
  `image` MEDIUMBLOB NULL,
  `image_type` VARCHAR(45) NULL,
  `logged_until` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_users_groups1`
    FOREIGN KEY (`group_id`)
    REFERENCES ` markyt`.`groups` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_users_groups1_idx` ON ` markyt`.`users` (`group_id` ASC);

CREATE UNIQUE INDEX `email_UNIQUE` ON ` markyt`.`users` (`email` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`annotations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`annotations` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`annotations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `round_id` INT UNSIGNED NOT NULL,
  `init` INT UNSIGNED NULL,
  `end` INT UNSIGNED NULL,
  `annotated_text` TEXT NOT NULL,
  `section` VARCHAR(1) NULL COMMENT 'title or abstract',
  `mode` INT(10) UNSIGNED NOT NULL,
  `created` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_annotations_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES ` markyt`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES ` markyt`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_annotations_rounds` ON ` markyt`.`annotations` (`round_id` ASC);

CREATE INDEX `fk_annotations_documents` ON ` markyt`.`annotations` (`document_id` ASC);

CREATE INDEX `fk_annotations_types` ON ` markyt`.`annotations` (`type_id` ASC);

CREATE INDEX `fk_annotations_users` ON ` markyt`.`annotations` (`user_id` ASC);

CREATE INDEX `complex_index_2` USING HASH ON ` markyt`.`annotations` (`round_id` ASC, `user_id` ASC, `document_id` ASC, `type_id` ASC, `init` ASC, `end` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`questions` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`questions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` INT UNSIGNED NOT NULL,
  `question` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_questions_classes1`
    FOREIGN KEY (`type_id`)
    REFERENCES ` markyt`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_questions_classes1_idx` ON ` markyt`.`questions` (`type_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`projects_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`projects_users` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`projects_users` (
  `project_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`project_id`, `user_id`),
  CONSTRAINT `fk_projects_has_users_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_projects_has_users_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_projects_has_users_users1_idx` ON ` markyt`.`projects_users` (`user_id` ASC);

CREATE INDEX `fk_projects_has_users_projects1_idx` ON ` markyt`.`projects_users` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`users_rounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`users_rounds` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`users_rounds` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `round_id` INT UNSIGNED NOT NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  `state` INT(10) UNSIGNED NULL COMMENT '{0= NORMAL,1=OCUPADO/LOCK}',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_users_has_rounds_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_rounds_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_users_has_rounds_rounds1_idx` ON ` markyt`.`users_rounds` (`round_id` ASC);

CREATE INDEX `fk_users_has_rounds_users1_idx` ON ` markyt`.`users_rounds` (`user_id` ASC);

CREATE UNIQUE INDEX `fk_users_has_rounds_users_rounds_idx` ON ` markyt`.`users_rounds` (`user_id` ASC, `round_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`annotations_questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`annotations_questions` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`annotations_questions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `annotation_id` INT UNSIGNED NOT NULL,
  `question_id` INT UNSIGNED NOT NULL,
  `answer` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_anotations_has_questions_anotations1`
    FOREIGN KEY (`annotation_id`)
    REFERENCES ` markyt`.`annotations` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_anotations_has_questions_questions1`
    FOREIGN KEY (`question_id`)
    REFERENCES ` markyt`.`questions` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_anotations_has_questions_questions1_idx` USING HASH ON ` markyt`.`annotations_questions` (`question_id` ASC);

CREATE INDEX `fk_anotations_has_questions_anotations1_idx` USING HASH ON ` markyt`.`annotations_questions` (`annotation_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`documents_projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`documents_projects` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`documents_projects` (
  `document_id` INT UNSIGNED NOT NULL,
  `project_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`document_id`, `project_id`),
  CONSTRAINT `fk_documents_has_projects_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES ` markyt`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documents_has_projects_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_documents_has_projects_projects1_idx` ON ` markyt`.`documents_projects` (`project_id` ASC);

CREATE INDEX `fk_documents_has_projects_documents1_idx` ON ` markyt`.`documents_projects` (`document_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`types_rounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`types_rounds` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`types_rounds` (
  `round_id` INT UNSIGNED NOT NULL,
  `type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`round_id`, `type_id`),
  CONSTRAINT `fk_rounds_has_types_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rounds_has_types_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES ` markyt`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_rounds_has_types_types1_idx` ON ` markyt`.`types_rounds` (`type_id` ASC);

CREATE INDEX `fk_rounds_has_types_rounds1_idx` ON ` markyt`.`types_rounds` (`round_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`posts` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(120) NOT NULL,
  `body` TEXT NOT NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_posts_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_posts_users1_idx` ON ` markyt`.`posts` (`user_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`consensus_annotations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`consensus_annotations` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`consensus_annotations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `round_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `project_id` INT UNSIGNED NOT NULL,
  `type_id` INT UNSIGNED NOT NULL,
  `annotation` TEXT NOT NULL,
  `init` INT UNSIGNED NOT NULL,
  `end` INT UNSIGNED NOT NULL,
  `section` VARCHAR(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_consensusAnnotations_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES ` markyt`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensusAnnotations_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensusAnnotations_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES ` markyt`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensusAnnotations_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `complex_index` ON ` markyt`.`consensus_annotations` (`init` ASC, `end` ASC, `type_id` ASC, `round_id` ASC, `document_id` ASC, `section` ASC);

CREATE INDEX `fk_consensusAnnotations_documents1_idx` ON ` markyt`.`consensus_annotations` (`document_id` ASC);

CREATE INDEX `fk_consensusAnnotations_rounds1_idx` ON ` markyt`.`consensus_annotations` (`round_id` ASC);

CREATE INDEX `fk_consensusAnnotations_types1_idx` ON ` markyt`.`consensus_annotations` (`type_id` ASC);

CREATE INDEX `fk_consensusAnnotations_projects1_idx` ON ` markyt`.`consensus_annotations` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`documents_assessments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`documents_assessments` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`documents_assessments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `project_id` INT UNSIGNED NOT NULL,
  `positive` TINYINT NULL,
  `neutral` TINYINT NULL,
  `negative` TINYINT NULL,
  `about_author` VARCHAR(500) NULL,
  `topic` VARCHAR(500) NULL,
  `note` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_documents_has_users_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES ` markyt`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documents_has_users_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documents_rates_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_documents_has_users_users1_idx` ON ` markyt`.`documents_assessments` (`user_id` ASC);

CREATE INDEX `fk_documents_has_users_documents1_idx` ON ` markyt`.`documents_assessments` (`document_id` ASC);

CREATE INDEX `fk_documents_rates_projects1_idx` ON ` markyt`.`documents_assessments` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`relations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`relations` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`relations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `colour` VARCHAR(45) NOT NULL,
  `is_directed` TINYINT(1) NULL DEFAULT 0,
  `marker` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_relations_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_relations_projects1_idx` ON ` markyt`.`relations` (`project_id` ASC);

CREATE UNIQUE INDEX `name_UNIQUE` ON ` markyt`.`relations` (`name` ASC, `project_id` ASC);

CREATE UNIQUE INDEX `id_UNIQUE` ON ` markyt`.`relations` (`id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`annotations_inter_relations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`annotations_inter_relations` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`annotations_inter_relations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `relation_id` INT UNSIGNED NOT NULL,
  `annotation_a_id` INT UNSIGNED NOT NULL,
  `annotation_b_id` INT UNSIGNED NOT NULL,
  `created` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `comment` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_annotations_has_relations_annotations1`
    FOREIGN KEY (`annotation_a_id`)
    REFERENCES ` markyt`.`annotations` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_has_relations_relations1`
    FOREIGN KEY (`relation_id`)
    REFERENCES ` markyt`.`relations` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_has_relations_annotations`
    FOREIGN KEY (`annotation_b_id`)
    REFERENCES ` markyt`.`annotations` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_annotations_has_relations_relations1_idx` ON ` markyt`.`annotations_inter_relations` (`relation_id` ASC);

CREATE INDEX `fk_annotations_has_relations_annotations1_idx` ON ` markyt`.`annotations_inter_relations` (`annotation_a_id` ASC);

CREATE INDEX `fk_annotations_has_relations_annotations_idx` ON ` markyt`.`annotations_inter_relations` (`annotation_b_id` ASC);

CREATE UNIQUE INDEX `union` ON ` markyt`.`annotations_inter_relations` (`annotation_a_id` ASC, `annotation_b_id` ASC, `relation_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`project_resources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`project_resources` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`project_resources` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `file` LONGBLOB NOT NULL,
  `name` TEXT NOT NULL,
  `extension` VARCHAR(200) NOT NULL,
  `created` TIMESTAMP NULL,
  `modified` TIMESTAMP NULL,
  `size` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_files_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_files_projects1_idx` ON ` markyt`.`project_resources` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`connections`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`connections` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`connections` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `ip` VARCHAR(45) NULL,
  `created` TIMESTAMP NULL,
  `modified` TIMESTAMP NULL,
  `session_time` TIME NULL,
  `city` VARCHAR(45) NULL,
  `country` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_connections_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_connections_users1_idx` ON ` markyt`.`connections` (`user_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`tasks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`tasks` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`tasks` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `program_name` VARCHAR(45) NULL,
  `created` TIMESTAMP NULL,
  `user_email` VARCHAR(45) NULL,
  `log` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ` markyt`.`jobs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`jobs` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`jobs` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `round_id` INT UNSIGNED NULL,
  `PID` VARCHAR(45) NULL,
  `status` VARCHAR(500) NULL,
  `percentage` FLOAT NULL,
  `program` VARCHAR(2000) NULL,
  `created` TIMESTAMP NULL,
  `modified` TIMESTAMP NULL,
  `comments` LONGTEXT NULL,
  `exception` LONGTEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_jobs_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jobs_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `PID_UNIQUE` ON ` markyt`.`jobs` (`PID` ASC);

CREATE INDEX `fk_jobs_users1_idx` ON ` markyt`.`jobs` (`user_id` ASC);

CREATE INDEX `fk_jobs_rounds1_idx` ON ` markyt`.`jobs` (`round_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`annotated_documents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`annotated_documents` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`annotated_documents` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `round_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `text_marked` LONGBLOB NULL,
  `annotation_minutes` FLOAT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_annotated_documents_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES ` markyt`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotated_documents_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotated_documents_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES ` markyt`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_annotated_documents_users1_idx` ON ` markyt`.`annotated_documents` (`user_id` ASC);

CREATE INDEX `fk_annotated_documents_rounds1_idx` ON ` markyt`.`annotated_documents` (`round_id` ASC);

CREATE INDEX `fk_annotated_documents_documents1_idx` ON ` markyt`.`annotated_documents` (`document_id` ASC);

CREATE UNIQUE INDEX `userRoundsDoc` ON ` markyt`.`annotated_documents` (`user_id` ASC, `round_id` ASC, `document_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`network`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`network` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`network` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `algorithm` CHAR(1) NULL COMMENT 'I = intersection , U = union , D = diffrenece',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ` markyt`.`project_networks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`project_networks` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`project_networks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `operation` TEXT NOT NULL,
  `exception` TEXT NULL,
  `name` TEXT NULL,
  `created` TIMESTAMP NULL,
  `JSON` LONGTEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_projects_has_networks_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_projects_has_networks_projects1_idx` ON ` markyt`.`project_networks` (`project_id` ASC);


-- -----------------------------------------------------
-- Table ` markyt`.`consensus_relations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ` markyt`.`consensus_relations` ;

CREATE TABLE IF NOT EXISTS ` markyt`.`consensus_relations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `round_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `project_id` INT UNSIGNED NOT NULL,
  `relation_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_consensus_relations_documents10`
    FOREIGN KEY (`document_id`)
    REFERENCES ` markyt`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensus_relations_rounds10`
    FOREIGN KEY (`round_id`)
    REFERENCES ` markyt`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensus_relations_projects10`
    FOREIGN KEY (`project_id`)
    REFERENCES ` markyt`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensus_relations_relations1`
    FOREIGN KEY (`relation_id`)
    REFERENCES ` markyt`.`relations` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_consensus_relations_documents1_idx` ON ` markyt`.`consensus_relations` (`document_id` ASC);

CREATE INDEX `fk_consensus_relations_rounds1_idx` ON ` markyt`.`consensus_relations` (`round_id` ASC);

CREATE INDEX `fk_consensus_relations_projects1_idx` ON ` markyt`.`consensus_relations` (`project_id` ASC);

CREATE INDEX `fk_consensus_relations_relations1_idx` ON ` markyt`.`consensus_relations` (`relation_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table ` markyt`.`groups`
-- -----------------------------------------------------
START TRANSACTION;
USE ` markyt`;
INSERT INTO ` markyt`.`groups` (`id`, `name`) VALUES (1, 'Admin');
INSERT INTO ` markyt`.`groups` (`id`, `name`) VALUES (2, 'Annotator');

COMMIT;
