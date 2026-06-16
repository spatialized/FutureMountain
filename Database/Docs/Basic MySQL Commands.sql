-- Common MySQL Commands

SELECT * FROM futuremtn_central_coast.cubedata;

USE futuremtn_central_coast;

SELECT 'dates' AS table_name, COUNT(*) AS rows_found FROM dates
UNION ALL SELECT 'cubedata', COUNT(*) FROM cubedata
UNION ALL SELECT 'waterdata', COUNT(*) FROM waterdata
UNION ALL SELECT 'firedata', COUNT(*) FROM firedata
UNION ALL SELECT 'patchdata', COUNT(*) FROM patchdata
UNION ALL SELECT 'stratumdata', COUNT(*) FROM stratumdata
UNION ALL SELECT 'terraindata', COUNT(*) FROM terraindata;


SHOW CREATE TABLE cubedata;
SHOW CREATE TABLE firedata;
SHOW CREATE TABLE patchdata;


USE futuremtn_central_coast;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE firedata;
TRUNCATE TABLE patchdata;
SET FOREIGN_KEY_CHECKS = 1;


ALTER TABLE cubedata AUTO_INCREMENT = 1;
ALTER TABLE firedata AUTO_INCREMENT = 1;
ALTER TABLE patchdata AUTO_INCREMENT = 1;



