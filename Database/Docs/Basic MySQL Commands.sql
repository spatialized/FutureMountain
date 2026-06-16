SELECT * FROM futuremtn_central_coast.cubedata;

USE futuremtn_central_coast;

SELECT 'dates' AS table_name, COUNT(*) AS rows_found FROM dates
UNION ALL SELECT 'cubedata', COUNT(*) FROM cubedata
UNION ALL SELECT 'waterdata', COUNT(*) FROM waterdata
UNION ALL SELECT 'firedata', COUNT(*) FROM firedata
UNION ALL SELECT 'patchdata', COUNT(*) FROM patchdata
UNION ALL SELECT 'stratumdata', COUNT(*) FROM stratumdata
UNION ALL SELECT 'terraindata', COUNT(*) FROM terraindata;

USE futuremtn_central_coast;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE terraindata;-- 
TRUNCATE TABLE stratumdata;

SET FOREIGN_KEY_CHECKS = 1;