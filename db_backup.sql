-- MySQL dump 10.13  Distrib 9.0.1, for macos15.1 (arm64)
--
-- Host: localhost    Database: RailwayBookingSystem
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE IF NOT EXISTS railwaybookingsystem;
USE railwaybookingsystem;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Person` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES ('MananTest1','temp@gmail.com');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `username` varchar(50) NOT NULL,
  `ssn` varchar(11) NOT NULL,
  `role` varchar(30) DEFAULT NULL,
  `phone_no` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Person` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES ('MananTest1','password','D','M');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question`
--

DROP TABLE IF EXISTS `Question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Question` (
  `question_id` int NOT NULL,
  `customer_username` varchar(50) DEFAULT NULL,
  `employee_username` varchar(50) DEFAULT NULL,
  `question_text` text,
  `answer_text` text,
  `ask_date` date DEFAULT NULL,
  `answer_date` date DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  KEY `customer_username` (`customer_username`),
  KEY `employee_username` (`employee_username`),
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`customer_username`) REFERENCES `Customer` (`username`),
  CONSTRAINT `question_ibfk_2` FOREIGN KEY (`employee_username`) REFERENCES `Employee` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question`
--

LOCK TABLES `Question` WRITE;
/*!40000 ALTER TABLE `Question` DISABLE KEYS */;
/*!40000 ALTER TABLE `Question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservation`
--

DROP TABLE IF EXISTS `Reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation` (
  `reservation_number` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `schedule_id` int NOT NULL,
  `reservation_date` date DEFAULT NULL,
  `total_fare` decimal(10,2) DEFAULT NULL,
  `origin` int NOT NULL,
  `destination` int NOT NULL,
  `depart_date` date DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  `discount` decimal(5,2) DEFAULT NULL,
  `ticket_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`reservation_number`),
  KEY `username` (`username`),
  KEY `schedule_id` (`schedule_id`),
  KEY `origin` (`origin`),
  KEY `destination` (`destination`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Customer` (`username`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `Train_Schedule` (`schedule_id`),
  CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`origin`) REFERENCES `Station` (`station_id`),
  CONSTRAINT `reservation_ibfk_4` FOREIGN KEY (`destination`) REFERENCES `Station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation`
--

LOCK TABLES `Reservation` WRITE;
/*!40000 ALTER TABLE `Reservation` DISABLE KEYS */;
INSERT INTO `Reservation` VALUES (417466,'MananTest1',1,'2024-12-07',99.00,1,1,'2024-12-10','08:00:00',99.00,'One-way'),(477798,'MananTest1',1,'2024-12-07',110.00,1,1,'2024-12-10','08:00:00',110.00,'One-way'),(499079,'MananTest1',1,'2024-12-07',99.00,1,1,'2024-12-10','08:00:00',99.00,'One-way'),(790797,'MananTest1',1,'2024-12-07',110.00,1,1,'2024-12-10','08:00:00',110.00,'One-way'),(991011,'MananTest1',1,'2024-12-07',99.00,1,1,'2024-12-10','08:00:00',99.00,'One-way'),(997125,'MananTest1',1,'2024-12-07',110.00,1,1,'2024-12-10','08:00:00',110.00,'One-way');
/*!40000 ALTER TABLE `Reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Station`
--

DROP TABLE IF EXISTS `Station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Station` (
  `station_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Station`
--

LOCK TABLES `Station` WRITE;
/*!40000 ALTER TABLE `Station` DISABLE KEYS */;
INSERT INTO `Station` VALUES (1,'New York Station','New York City','NY'),(2,'Philadelphia Station','Philadelphia','PA'),(3,'Washington Station','Washington DC','DC'),(4,'Boston Station','Boston','MA'),(5,'Miami Station','Miami','FL'),(6,'Los Angeles Station','Los Angeles','CA'),(7,'Chicago Station','Chicago','IL'),(8,'San Francisco Station','San Francisco','CA'),(9,'Seattle Station','Seattle','WA'),(10,'Austin Station','Austin','TX');
/*!40000 ALTER TABLE `Station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stop`
--

DROP TABLE IF EXISTS `Stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stop` (
  `stop_id` int NOT NULL,
  `station_id` int NOT NULL,
  `schedule_id` int NOT NULL,
  `arrival_time` time DEFAULT NULL,
  `depart_time` time DEFAULT NULL,
  PRIMARY KEY (`stop_id`),
  KEY `station_id` (`station_id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `stop_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `Station` (`station_id`),
  CONSTRAINT `stop_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `Train_Schedule` (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stop`
--

LOCK TABLES `Stop` WRITE;
/*!40000 ALTER TABLE `Stop` DISABLE KEYS */;
INSERT INTO `Stop` VALUES (1,1,1,'08:00:00','08:15:00'),(2,2,1,'10:00:00','10:15:00'),(3,3,1,'12:00:00','12:15:00'),(4,4,1,'14:00:00','14:15:00'),(5,1,2,'09:30:00','09:45:00'),(6,2,2,'11:30:00','11:45:00'),(7,3,2,'13:30:00','13:45:00'),(8,4,2,'15:30:00','15:45:00'),(9,1,3,'10:00:00','10:15:00'),(10,2,3,'12:00:00','12:15:00'),(11,3,3,'14:00:00','14:15:00'),(12,4,3,'16:00:00','16:15:00'),(13,6,7,'10:00:00','10:15:00'),(14,8,7,'12:00:00','12:15:00'),(15,9,7,'14:00:00','14:15:00'),(16,6,8,'11:00:00','11:15:00'),(17,8,8,'13:00:00','13:15:00'),(18,9,8,'15:00:00','15:15:00');
/*!40000 ALTER TABLE `Stop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Train`
--

DROP TABLE IF EXISTS `Train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Train` (
  `train_id` int NOT NULL,
  PRIMARY KEY (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Train`
--

LOCK TABLES `Train` WRITE;
/*!40000 ALTER TABLE `Train` DISABLE KEYS */;
INSERT INTO `Train` VALUES (101),(102),(103),(104),(105);
/*!40000 ALTER TABLE `Train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Train_Schedule`
--

DROP TABLE IF EXISTS `Train_Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Train_Schedule` (
  `schedule_id` int NOT NULL,
  `line_name` varchar(100) NOT NULL,
  `train_id` int NOT NULL AUTO_INCREMENT,
  `depart_datetime` datetime DEFAULT NULL,
  `arrival_datetime` datetime DEFAULT NULL,
  `travel_time` int DEFAULT NULL,
  `fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `line_name` (`line_name`),
  KEY `train_id` (`train_id`),
  CONSTRAINT `train_schedule_ibfk_1` FOREIGN KEY (`line_name`) REFERENCES `Transit_Line` (`line_name`),
  CONSTRAINT `train_schedule_ibfk_2` FOREIGN KEY (`train_id`) REFERENCES `Train` (`train_id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Train_Schedule`
--

LOCK TABLES `Train_Schedule` WRITE;
/*!40000 ALTER TABLE `Train_Schedule` DISABLE KEYS */;
INSERT INTO `Train_Schedule` VALUES (1,'East Coast Express',101,'2024-12-10 08:00:00','2024-12-10 14:00:00',370,110.00),(2,'East Coast Express',102,'2024-12-10 09:30:00','2024-12-10 15:30:00',390,120.00),(3,'East Coast Express',103,'2024-12-10 10:00:00','2024-12-10 16:00:00',410,130.00),(4,'East Coast Express',101,'2024-12-11 08:00:00','2024-12-11 14:00:00',380,115.00),(5,'East Coast Express',102,'2024-12-11 09:30:00','2024-12-11 15:30:00',400,125.00),(6,'East Coast Express',103,'2024-12-11 10:00:00','2024-12-11 16:00:00',420,135.00),(7,'Pacific Runner',104,'2024-12-10 10:00:00','2024-12-10 16:00:00',360,140.00),(8,'Pacific Runner',105,'2024-12-10 11:00:00','2024-12-10 17:00:00',380,150.00),(9,'Pacific Runner',104,'2024-12-11 10:00:00','2024-12-11 16:00:00',370,145.00),(10,'Pacific Runner',105,'2024-12-11 11:00:00','2024-12-11 17:00:00',390,155.00);
/*!40000 ALTER TABLE `Train_Schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transit_Line`
--

DROP TABLE IF EXISTS `Transit_Line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transit_Line` (
  `line_name` varchar(100) NOT NULL,
  `origin` int NOT NULL,
  `destination` int NOT NULL,
  PRIMARY KEY (`line_name`),
  KEY `origin` (`origin`),
  KEY `destination` (`destination`),
  CONSTRAINT `transit_line_ibfk_1` FOREIGN KEY (`origin`) REFERENCES `Station` (`station_id`),
  CONSTRAINT `transit_line_ibfk_2` FOREIGN KEY (`destination`) REFERENCES `Station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transit_Line`
--

LOCK TABLES `Transit_Line` WRITE;
/*!40000 ALTER TABLE `Transit_Line` DISABLE KEYS */;
INSERT INTO `Transit_Line` VALUES ('East Coast Express',1,4),('Pacific Runner',6,9);
/*!40000 ALTER TABLE `Transit_Line` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-07 21:10:31