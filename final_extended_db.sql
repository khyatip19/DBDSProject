-- MySQL dump 10.13  Distrib 9.0.1, for macos15.1 (arm64)
--
-- Host: localhost    Database: railwaybookingsystem
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
INSERT INTO `Station` VALUES (1,'Boston','Boston','MA'),(2,'New York','New York','NY'),(3,'Philadelphia','Philadelphia','PA'),(4,'Washington D.C.','Washington','DC'),(5,'Chicago','Chicago','IL'),(6,'Los Angeles','Los Angeles','CA'),(7,'San Francisco','San Francisco','CA'),(8,'Seattle','Seattle','WA'),(9,'Miami','Miami','FL');
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
INSERT INTO `Stop` VALUES (1,1,1,'08:00:00','08:15:00'),(2,3,1,'10:30:00','10:45:00'),(3,2,1,'12:00:00','12:15:00'),(4,2,2,'14:00:00','14:15:00'),(5,3,2,'16:30:00','16:45:00'),(6,1,2,'18:00:00','18:15:00'),(7,2,5,'10:00:00','10:15:00'),(8,3,5,'12:00:00','12:15:00'),(9,4,5,'13:30:00','13:45:00'),(10,3,7,'11:00:00','11:15:00'),(11,4,7,'12:30:00','12:45:00'),(12,5,7,'14:00:00','14:15:00'),(13,4,8,'14:00:00','14:15:00'),(14,3,8,'15:30:00','15:45:00'),(15,2,8,'17:00:00','17:15:00'),(16,4,9,'08:00:00','08:15:00'),(17,5,9,'11:30:00','11:45:00'),(18,6,9,'14:00:00','14:15:00'),(19,7,9,'16:30:00','16:45:00'),(20,5,10,'16:00:00','16:15:00'),(21,4,10,'19:30:00','19:45:00'),(22,3,10,'22:00:00','22:15:00'),(23,2,10,'23:30:00','23:45:00'),(24,5,11,'06:00:00','06:15:00'),(25,6,11,'09:00:00','09:15:00'),(26,7,11,'11:00:00','11:15:00'),(27,8,11,'14:30:00','14:45:00'),(28,6,12,'07:00:00','07:15:00'),(29,5,12,'10:30:00','10:45:00'),(30,4,12,'12:00:00','12:15:00'),(31,3,12,'14:30:00','14:45:00'),(32,6,13,'08:00:00','08:15:00'),(33,7,13,'09:30:00','09:45:00'),(34,8,13,'11:00:00','11:15:00'),(35,7,14,'14:00:00','14:15:00'),(36,6,14,'15:30:00','15:45:00'),(37,5,14,'17:00:00','17:15:00'),(38,7,15,'09:00:00','09:15:00'),(39,8,15,'12:00:00','12:15:00'),(40,9,15,'14:00:00','14:15:00'),(41,8,16,'17:00:00','17:15:00'),(42,7,16,'20:00:00','20:15:00'),(43,6,16,'22:30:00','22:45:00'),(44,9,17,'07:00:00','07:15:00'),(45,8,17,'10:00:00','10:15:00'),(46,5,17,'14:00:00','14:15:00'),(47,5,18,'16:00:00','16:15:00'),(48,8,18,'18:00:00','18:15:00'),(49,9,18,'22:00:00','22:15:00');
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
INSERT INTO `Train` VALUES (101),(102),(103),(104),(105),(106),(107),(108),(109),(110);
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
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Train_Schedule`
--

LOCK TABLES `Train_Schedule` WRITE;
/*!40000 ALTER TABLE `Train_Schedule` DISABLE KEYS */;
INSERT INTO `Train_Schedule` VALUES (1,'Boston_NY',101,'2024-12-10 08:00:00','2024-12-10 12:00:00',240,100.00),(2,'NY_Boston',101,'2024-12-10 14:00:00','2024-12-10 18:00:00',240,100.00),(3,'Boston_NY',102,'2024-12-11 09:00:00','2024-12-11 13:00:00',240,110.00),(4,'NY_Boston',102,'2024-12-11 15:00:00','2024-12-11 19:00:00',240,110.00),(5,'NY_Philadelphia',103,'2024-12-10 10:00:00','2024-12-10 12:30:00',150,60.00),(6,'Philadelphia_NY',103,'2024-12-10 13:00:00','2024-12-10 15:30:00',150,60.00),(7,'Philadelphia_Washington',104,'2024-12-12 11:00:00','2024-12-12 12:30:00',90,50.00),(8,'Washington_Philadelphia',104,'2024-12-12 14:00:00','2024-12-12 15:30:00',90,50.00),(9,'Washington_Chicago',105,'2024-12-13 08:00:00','2024-12-13 14:00:00',360,120.00),(10,'Chicago_Washington',105,'2024-12-13 16:00:00','2024-12-13 22:00:00',360,120.00),(11,'Chicago_LosAngeles',106,'2024-12-14 06:00:00','2024-12-14 18:00:00',720,200.00),(12,'LosAngeles_Chicago',106,'2024-12-15 07:00:00','2024-12-15 19:00:00',720,200.00),(13,'LosAngeles_SanFrancisco',107,'2024-12-15 08:00:00','2024-12-15 10:00:00',120,30.00),(14,'SanFrancisco_LosAngeles',107,'2024-12-15 14:00:00','2024-12-15 16:00:00',120,30.00),(15,'SanFrancisco_Seattle',108,'2024-12-16 09:00:00','2024-12-16 16:00:00',420,150.00),(16,'Seattle_SanFrancisco',108,'2024-12-16 17:00:00','2024-12-16 22:00:00',420,150.00),(17,'Miami_Chicago',109,'2024-12-17 07:00:00','2024-12-17 14:00:00',420,180.00),(18,'Chicago_Miami',109,'2024-12-17 16:00:00','2024-12-17 23:00:00',420,180.00);
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
INSERT INTO `Transit_Line` VALUES ('Boston_NY',1,2),('Chicago_LosAngeles',5,6),('Chicago_Miami',5,9),('Chicago_Washington',5,4),('LosAngeles_Chicago',6,5),('LosAngeles_SanFrancisco',6,7),('Miami_Chicago',9,5),('NY_Boston',2,1),('NY_Philadelphia',2,3),('Philadelphia_NY',3,2),('Philadelphia_Washington',3,4),('SanFrancisco_LosAngeles',7,6),('SanFrancisco_Seattle',7,8),('Seattle_SanFrancisco',8,7),('Washington_Chicago',4,5),('Washington_Philadelphia',4,3);
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

-- Dump completed on 2024-12-11  9:09:30
