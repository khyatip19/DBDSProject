CREATE DATABASE IF NOT EXISTS `railwaybookingsystem` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `railwaybookingsystem`;

-- Table structure for table `Person`
CREATE TABLE `Person` (
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(50),
  `first_name` VARCHAR(50),
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Customer`
CREATE TABLE `Customer` (
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`username`),
  FOREIGN KEY (`username`) REFERENCES `Person`(`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Employee`
CREATE TABLE `Employee` (
  `username` VARCHAR(50) NOT NULL,
  `ssn` VARCHAR(11) NOT NULL,
  `role` VARCHAR(30),
  `phone_no` VARCHAR(15),
  PRIMARY KEY (`username`),
  FOREIGN KEY (`username`) REFERENCES `Person`(`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Train`
CREATE TABLE `Train` (
  `train_id` INT NOT NULL,
  PRIMARY KEY (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Station`
CREATE TABLE `Station` (
  `station_id` INT NOT NULL,
  `name` VARCHAR(100),
  `city` VARCHAR(50),
  `state` VARCHAR(2),
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Transit_Line`
CREATE TABLE `Transit_Line` (
  `line_name` VARCHAR(100) NOT NULL,
  `origin` INT NOT NULL,
  `destination` INT NOT NULL,
  `base_fare` DECIMAL(10,2),
  PRIMARY KEY (`line_name`),
  FOREIGN KEY (`origin`) REFERENCES `Station`(`station_id`),
  FOREIGN KEY (`destination`) REFERENCES `Station`(`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Train_Schedule`
CREATE TABLE `Train_Schedule` (
  `schedule_id` INT NOT NULL,
  `line_name` VARCHAR(100) NOT NULL,
  `train_id` INT NOT NULL,
  `depart_datetime` DATETIME,
  `arrival_datetime` DATETIME,
  `travel_time` INT,
  PRIMARY KEY (`schedule_id`),
  FOREIGN KEY (`line_name`) REFERENCES `Transit_Line`(`line_name`),
  FOREIGN KEY (`train_id`) REFERENCES `Train`(`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Stop`
CREATE TABLE `Stop` (
  `stop_id` INT NOT NULL,
  `station_id` INT NOT NULL,
  `schedule_id` INT NOT NULL,
  `arrival_time` TIME,
  `depart_time` TIME,
  PRIMARY KEY (`stop_id`),
  FOREIGN KEY (`station_id`) REFERENCES `Station`(`station_id`),
  FOREIGN KEY (`schedule_id`) REFERENCES `Train_Schedule`(`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Reservation`
CREATE TABLE `Reservation` (
  `reservation_number` INT NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `schedule_id` INT NOT NULL,
  `reservation_date` DATE,
  `total_fare` DECIMAL(10,2),
  `origin` INT NOT NULL,
  `destination` INT NOT NULL,
  `depart_date` DATE,
  `departure_time` TIME,
  `discount` DECIMAL(5,2),
  `ticket_type` VARCHAR(20),
  PRIMARY KEY (`reservation_number`),
  FOREIGN KEY (`username`) REFERENCES `Customer`(`username`),
  FOREIGN KEY (`schedule_id`) REFERENCES `Train_Schedule`(`schedule_id`),
  FOREIGN KEY (`origin`) REFERENCES `Station`(`station_id`),
  FOREIGN KEY (`destination`) REFERENCES `Station`(`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `Question`
CREATE TABLE `Question` (
  `question_id` INT NOT NULL,
  `customer_username` VARCHAR(50),
  `employee_username` VARCHAR(50),
  `question_text` TEXT,
  `answer_text` TEXT,
  `ask_date` DATE,
  `answer_date` DATE,
  PRIMARY KEY (`question_id`),
  FOREIGN KEY (`customer_username`) REFERENCES `Customer`(`username`),
  FOREIGN KEY (`employee_username`) REFERENCES `Employee`(`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;