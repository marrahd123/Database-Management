/* =====================================
	Creating table and inserting values
========================================*/
/* Create locations table */

mysql-ctl cli
use coordinates;
select * from locations;

CREATE TABLE locations
(
	id serial NOT NULL,
	name character varying(100),
	lng float,
	lat float
);

/* Insert the 9 locations with long, lat values */
INSERT INTO locations(name, lng, lat) VALUES ('Taylor 205',-93.4094885,37.5997674);
INSERT INTO locations(name, lng, lat) VALUES ('Chapel',-93.4108,37.6013);
INSERT INTO locations(name, lng, lat) VALUES ('Mellers',-93.4109,37.6007);
INSERT INTO locations(name, lng, lat) VALUES ('SBU Bell Tower',-93.4102,37.6013);
INSERT INTO locations(name, lng, lat) VALUES ('SBU Globe Fountain',-93.4104,37.6007);
INSERT INTO locations(name, lng, lat) VALUES ('Plaster 202', -93.4084,37.5993);
INSERT INTO locations(name, lng, lat) VALUES ('Randolph Chapel', -93.4097,37.6001);
INSERT INTO locations(name, lng, lat) VALUES ('Dunnegan Park', -93.4161167,37.6285305);
INSERT INTO locations(name, lng, lat) VALUES ('Casebolt', -93.4118269,37.6015075);
INSERT INTO locations(name, lng, lat) VALUES ('Beasley 405', -93.4115710,37.6043991);
INSERT INTO locations(name, lng, lat) VALUES ('Football Field', -93.412994,37.601901);
INSERT INTO locations(name, lng, lat) VALUES ('', 0,0);

/* Create a geometry type column */
ALTER TABLE locations ADD COLUMN geom geometry(POINT, 4326);

/* Derive geometry values (in WGS84/SRID4326 format) from lat, lng values */
/* Note that this command should be run after "INSERT INTO" commands */
UPDATE locations SET geom = ST_SetSRID(ST_MakePoint(lng, lat), 4326);


/* =====================================
	Find Convex Hull locations
========================================*/
SELECT ST_AsText(ST_ConvexHull(ST_Collect(geom)))
FROM locations;


/* =====================================
	Find 3 Nearest Neighbors
========================================*/
SELECT c2.name as name, c1.lat as originLat, c1.lng as originLng, c2.lat as destinationLat, c2.lng as destinationLng, ST_DISTANCE(c1.geom, c2.geom) as distance
FROM locations c1
JOIN locations c2 on c1.id != c2.id
WHERE c1.name = 'Taylor 205'
ORDER BY distance
LIMIT 3;