-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: futuremtn_central_coast
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `__efmigrationshistory`
--

DROP TABLE IF EXISTS `__efmigrationshistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ProductVersion` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cubedata`
--

DROP TABLE IF EXISTS `cubedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cubedata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importRunId` int NOT NULL,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `dateIdx` int NOT NULL,
  `basinID` int NOT NULL,
  `hillID` int NOT NULL,
  `zoneID` int NOT NULL,
  `patchID` bigint NOT NULL,
  `coverfract` float NOT NULL,
  `litterc` float NOT NULL,
  `burn` float NOT NULL,
  `soilc` float NOT NULL,
  `depthToGW` float NOT NULL,
  `canopyevap` float NOT NULL,
  `streamflow` float NOT NULL,
  `rootdepth` float NOT NULL,
  `groundevap` float NOT NULL,
  `vegAccessWater` float NOT NULL,
  `Qin` float NOT NULL,
  `Qout` float NOT NULL,
  `rain` float NOT NULL,
  `stratumIDOver` bigint NOT NULL,
  `vegParmIDOver` int NOT NULL,
  `consumedCOver` float NOT NULL,
  `mortCOver` float NOT NULL,
  `netpsnOver` float NOT NULL,
  `heightOver` float NOT NULL,
  `transOver` float NOT NULL,
  `leafCOver` float NOT NULL,
  `stemCOver` float NOT NULL,
  `rootCOver` float NOT NULL,
  `rootdepthCOver` float NOT NULL,
  `laiOver` float NOT NULL,
  `stratumIDUnder` bigint NOT NULL,
  `vegParmIDUnder` int NOT NULL,
  `consumedCUnder` float NOT NULL,
  `mortCUnder` float NOT NULL,
  `transUnder` float NOT NULL,
  `netpsnUnder` float NOT NULL,
  `heightUnder` float NOT NULL,
  `leafCUnder` float NOT NULL,
  `stemCUnder` float NOT NULL,
  `rootCUnder` float NOT NULL,
  `rootdepthUnder` float NOT NULL,
  `laiUnder` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_CubeData_scenarioRunId_warmingIdx_dateIdx_zoneID_patchID` (`scenarioRunId`,`warmingIdx`,`dateIdx`,`zoneID`,`patchID`)
) ENGINE=InnoDB AUTO_INCREMENT=116881 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dates`
--

DROP TABLE IF EXISTS `dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime(6) NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `day` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `firedata`
--

DROP TABLE IF EXISTS `firedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firedata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importRunId` int NOT NULL,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `sourceFile` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `level` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `basinID` int NOT NULL,
  `hillID` int DEFAULT NULL,
  `zoneID` int DEFAULT NULL,
  `patchID` bigint DEFAULT NULL,
  `burn` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_FireData_scenarioRunId_warmingIdx_year_month_zoneID_patchID` (`scenarioRunId`,`warmingIdx`,`year`,`month`,`zoneID`,`patchID`)
) ENGINE=InnoDB AUTO_INCREMENT=3438721 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `importrun`
--

DROP TABLE IF EXISTS `importrun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `importrun` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scenarioName` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `scenarioProfile` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `scenarioRunId` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `databaseName` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sourceRoot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `startedUtc` datetime(6) NOT NULL,
  `finishedUtc` datetime(6) DEFAULT NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `filesImported` int NOT NULL,
  `rowsImported` bigint NOT NULL,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patchdata`
--

DROP TABLE IF EXISTS `patchdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patchdata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importRunId` int NOT NULL,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `zoneID` int NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_PatchData_scenarioRunId_zoneID` (`scenarioRunId`,`zoneID`)
) ENGINE=InnoDB AUTO_INCREMENT=4478 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stratumdata`
--

DROP TABLE IF EXISTS `stratumdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stratumdata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importRunId` int NOT NULL,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `sourceFile` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `basinID` int NOT NULL,
  `hillID` int NOT NULL,
  `zoneID` int NOT NULL,
  `patchID` bigint NOT NULL,
  `stratumID` bigint NOT NULL,
  `totalc` float NOT NULL,
  `total_plantc` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_StratumData_scenarioRunId_warmingIdx_year_month_stratumID` (`scenarioRunId`,`warmingIdx`,`year`,`month`,`stratumID`)
) ENGINE=InnoDB AUTO_INCREMENT=4460001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `terraindata`
--

DROP TABLE IF EXISTS `terraindata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terraindata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `gridSize` int NOT NULL,
  `gridWidth` int NOT NULL,
  `gridHeight` int NOT NULL,
  `pixelGrainSize` int NOT NULL,
  `decimalPrecision` int NOT NULL,
  `_dataList` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_TerrainData_scenarioRunId_warmingIdx_year_month` (`scenarioRunId`,`warmingIdx`,`year`,`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `waterdata`
--

DROP TABLE IF EXISTS `waterdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waterdata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importRunId` int NOT NULL,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `dateIdx` int NOT NULL,
  `basinID` int NOT NULL,
  `streamflow` float NOT NULL,
  `rain` float NOT NULL,
  `evaporation` float NOT NULL,
  `evaporation_surf` float NOT NULL,
  `exfiltration_unsat_zone` float NOT NULL,
  `exfiltration_sat_zone` float NOT NULL,
  `transpiration_sat_zone` float NOT NULL,
  `transpiration_unsat_zone` float NOT NULL,
  `sat_deficit_z` float NOT NULL,
  `rz_storage` float NOT NULL,
  `rootzone_depth` float NOT NULL,
  `family_pct_cover` float NOT NULL,
  `burn` float NOT NULL,
  `litter_cs_totalc` float NOT NULL,
  `soil_cs_totalc` float NOT NULL,
  `cs_net_psn` float NOT NULL,
  `epv_height` float NOT NULL,
  `cs_leafc` float NOT NULL,
  `cs_leafc_store` float NOT NULL,
  `cs_live_stemc` float NOT NULL,
  `cs_dead_stemc` float NOT NULL,
  `cs_frootc` float NOT NULL,
  `cs_live_crootc` float NOT NULL,
  `cs_dead_crootc` float NOT NULL,
  `fe_canopy_target_prop_c_consumed` float NOT NULL,
  `fe_canopy_target_prop_c_remain_adjusted` float NOT NULL,
  `fe_canopy_target_prop_c_remain_adjusted_leafc` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_WaterData_scenarioRunId_warmingIdx_dateIdx` (`scenarioRunId`,`warmingIdx`,`dateIdx`)
) ENGINE=InnoDB AUTO_INCREMENT=11689 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-14  1:33:59
