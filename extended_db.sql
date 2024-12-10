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
INSERT INTO `Reservation` VALUES (41089,'MananTest1',2,'2024-12-09',220.00,1,4,'2024-12-15','09:00:00',0.00,'Round-Trip'),(352086,'MananTest1',1,'2024-12-09',90.00,1,4,'2024-12-15','08:00:00',10.00,'One-Way');
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
INSERT INTO `Station` VALUES (1,'Boston','Boston','MA'),(2,'Providence','Providence','RI'),(3,'New Haven','New Haven','CT'),(4,'New York','New York','NY'),(5,'Hartford','Hartford','CT'),(6,'Worcester','Worcester','MA'),(7,'Albany','Albany','NY'),(8,'Springfield','Springfield','MA'),(9,'Pittsfield','Pittsfield','MA'),(10,'Buffalo','Buffalo','NY'),(11,'Syracuse','Syracuse','NY'),(12,'Rochester','Rochester','NY'),(13,'Cleveland','Cleveland','OH'),(14,'Chicago','Chicago','IL'),(15,'Detroit','Detroit','MI'),(16,'Columbus','Columbus','OH'),(17,'Indianapolis','Indianapolis','IN'),(18,'St. Louis','St. Louis','MO'),(19,'Kansas City','Kansas City','MO'),(20,'Denver','Denver','CO');
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
INSERT INTO `Stop` VALUES (1,1,1,'08:00:00','08:15:00'),(2,2,1,'08:45:00','09:00:00'),(3,3,1,'10:30:00','10:45:00'),(4,4,1,'12:00:00','12:15:00'),(5,1,2,'09:00:00','09:15:00'),(6,2,2,'09:45:00','10:00:00'),(7,3,2,'11:30:00','11:45:00'),(8,4,2,'13:00:00','13:15:00'),(9,4,4,'10:00:00','10:15:00'),(10,5,4,'11:00:00','11:15:00'),(11,6,4,'12:00:00','12:15:00'),(12,7,4,'13:00:00','13:15:00');
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
INSERT INTO `Train` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30);
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Train_Schedule`
--

LOCK TABLES `Train_Schedule` WRITE;
/*!40000 ALTER TABLE `Train_Schedule` DISABLE KEYS */;
INSERT INTO `Train_Schedule` VALUES (1,'Boston_NewYork',1,'2024-12-15 08:00:00','2024-12-15 12:30:00',210,100.00),(2,'Boston_NewYork',2,'2024-12-15 09:00:00','2024-12-15 13:30:00',210,110.00),(3,'Boston_NewYork',3,'2024-12-15 10:00:00','2024-12-15 14:30:00',210,120.00),(4,'NewYork_StLouis',4,'2024-12-15 10:00:00','2024-12-15 18:30:00',510,180.00),(5,'NewYork_StLouis',5,'2024-12-15 11:00:00','2024-12-15 19:30:00',510,190.00),(6,'NewYork_StLouis',6,'2024-12-15 12:00:00','2024-12-15 20:30:00',510,200.00),(7,'Boston_Chicago',7,'2024-12-15 08:00:00','2024-12-15 20:30:00',780,150.00),(8,'Boston_Chicago',8,'2024-12-15 09:00:00','2024-12-15 21:30:00',780,160.00),(9,'Boston_Chicago',9,'2024-12-15 10:00:00','2024-12-15 22:30:00',780,170.00),(10,'Cleveland_Chicago',10,'2024-12-15 07:00:00','2024-12-15 14:30:00',330,120.00),(11,'Cleveland_Chicago',11,'2024-12-15 08:00:00','2024-12-15 15:30:00',330,130.00),(12,'Cleveland_Chicago',12,'2024-12-15 09:00:00','2024-12-15 16:30:00',330,140.00),(13,'StLouis_NewYork',13,'2024-12-15 09:00:00','2024-12-15 17:30:00',510,180.00),(14,'StLouis_NewYork',14,'2024-12-15 10:00:00','2024-12-15 18:30:00',510,190.00),(15,'StLouis_NewYork',15,'2024-12-15 11:00:00','2024-12-15 19:30:00',510,200.00),(16,'Chicago_Boston',16,'2024-12-15 12:00:00','2024-12-15 00:30:00',780,150.00),(17,'Chicago_Boston',17,'2024-12-15 13:00:00','2024-12-15 01:30:00',780,160.00),(18,'Chicago_Boston',18,'2024-12-15 14:00:00','2024-12-15 02:30:00',780,170.00),(19,'Cleveland_Boston',19,'2024-12-15 12:00:00','2024-12-15 23:30:00',780,150.00),(20,'Cleveland_Boston',20,'2024-12-15 13:00:00','2024-12-15 00:30:00',780,160.00),(21,'Cleveland_Boston',21,'2024-12-15 14:00:00','2024-12-15 01:30:00',780,170.00);
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
INSERT INTO `Transit_Line` VALUES ('Boston_Chicago',1,14),('Boston_Cleveland',1,13),('Boston_NewYork',1,4),('Chicago_Boston',14,1),('Chicago_Cleveland',14,13),('Chicago_Denver',14,20),('Cleveland_Boston',13,1),('Cleveland_Chicago',13,14),('Denver_Chicago',20,14),('Detroit_Indianapolis',15,17),('Detroit_NewYork',15,4),('Indianapolis_Detroit',17,15),('NewYork_Boston',4,1),('NewYork_Detroit',4,15),('NewYork_StLouis',4,18),('StLouis_NewYork',18,4);
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

-- Dump completed on 2024-12-09 22:52:06
