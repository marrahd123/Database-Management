Geospatial Data
In this assignment, you are going to work with spatial data - you will create (generate/sample) some data, visualize it, do queries on it, and visualize the query results.. Hope you have fun with this!
The exercise will give you a taste of working with spatial data, use of a spatial file format and spatial query functions, all of which are quite useful from a real-world (or job interview) perspective.
Step 1
You need to create (generate) latitude, longitude pairs (i.e. spatial/gps coordinates) for 12 locations. One of those will be where your home/apartment/dorm room is. The other 11 would have to be spread out - use your judgment, try to span the campus area, choose locations inside and outside, nearby - we don't want to cover a 'huge' region, or at the other extreme, sample just parts of a single building!

How would you obtain (lat,long) spatial coordinates at a location? You can scan the following QR code with your phone and it will take you to a webpage with your location marked on a Google map (refresh the page to update your location on map).

Also, be sure to write down the location names as well (you will use them to label your points when displaying). AND, take a selfie (!) that clearly shows the location you're sampling - this step is to ensure that you're not simply reading off the coords from a map, sitting at home!
Step 2
Now that you have 12 coordinates and their label strings (e.g. "Home", "Library", "Walmart"), you are going to create a KML file (.kml format, which is XML) out of them using a text editor. Specifically, each location will be a 'placemark' in your .kml file (with a label, and coords). The .kml file with the 12 placemarks is going to be your starter file, for doing visualizations and queries. Here is a .kml skeleton to get you started (just download, rename and edit it to put in your coords and labels). NOTE - keep your labels to be 15 characters or less (including spaces). Here is the same .kml skeleton in .txt format. Note too that in .kml, you specify (long,lat), instead of the expected (lat,long) (after all, longitude is what corresponds to 'x', and latitude, to 'y')!
You are going to use Google Earth to visualize the data in your KML file (see step 3 below). FYI, as a quick check, you can also visualize it using this page - simply copy and paste your KML data into the textbox on the left, and click 'Show it on the map' to have it be displayed on a map on the right.
Step 3
Download Google Earth on your laptop, install it, bring it up. Load your .kml file into it - that should show you your sampled locations, on Google Earth's globe :) Take a snapshot (screengrab) of this, for submitting.
Step 4
Create a Postgres database on GCP (Google Cloud Platform) by following this guide.
You will need to run the following commands in the console to add PostGIS extension and verify.
CREATE EXTENSION postgis;
SELECT postgis_full_version();

Store you data points in the database in the proper format and compute the following:
Compute the convex hull for your 12 points [a convex hull for a set of 2D points is the smallest convex polygon that contains the point set]. Please read this doc and this article. Use the query's result polygon's coords, to create a polygon in your .kml file (edit the .kml file, add relevant XML to specify the KML polygon's coords). Load this into Google Earth, visually verify that all your points are on/inside the convex hull, then take a screenshot. Note that even your data points happen to have a concave perimeter and/or happen to be self-intersecting, the convex hull, by definition, would be a tight, enclosing boundary (hull) that is a simple convex polygon. The convex hull is a very useful object - eg. see this discussion. Note: be sure to specify your polygon's coords as '...-118,34 -118,34.1...' for example, and not '...-118, 34 -118, 34.1...' [in other words, do not separate long,lat with a space after the comma, ie it can't be long, lat].
Compute the four nearest neighbors of your home/apt/dormroom location [look up the spatial function of your DB, to do this]. Use the query's results, to create four line segments in your .kml file: line(home,neighbor1), line(home,neighbor2), line(home,neighbor3), line(home,neighbor4). Verify this looks correct, using Google Earth, take a snapshot.

Resources

https://www.db-fiddle.com/

https://itnext.io/playing-with-geometry-spatial-data-type-in-mysql-645b83880331
https://dev.mysql.com/doc/refman/8.0/en/spatial-operator-functions.html
https://medium.com/@pascal.sommer.ch/a-gentle-introduction-to-the-convex-hull-problem-62dfcabee90c

Google Cloud Platform https://cloud.google.com/sql/docs/postgres/quickstart
https://postgis.net/workshops/postgis-intro/geometries.html

https://medium.com/@tjukanov/why-should-you-care-about-postgis-a-gentle-introduction-to-spatial-databases-9eccd26bc42b

https://postgis.net/workshops/postgis-intro/index.html

Postgres Commands http://postgresguide.com/utilities/psql.html

PostGIS
http://www.postgis.org/files/OSDB2_PostGIS_Presentation.pdf
Introduction to PostGIS (PostgresConf South Africa) https://youtu.be/hMn74o11wdk
https://youtu.be/SEj6fjfF114
ST_ConvexHull https://postgis.net/docs/ST_ConvexHull.html
Beginner Tutorial
https://www.vertabelo.com/blog/technical-articles/getting-started-with-postgis-your-first-steps-with-the-geography-data-type
code:
CREATE TABLE artwork (
  artwork_name TEXT,
  category VARCHAR(20),
  artist_name VARCHAR (50),
  showed_at_latitude FLOAT,
  showed_at_longitude FLOAT,
  where_is GEOGRAPHY
);

INSERT INTO artwork VALUES ('Giaconda','painting','Leonardo Da Vinci', 48.860547, 2.338513,NULL);
INSERT INTO artwork VALUES ('David','sculpture','Michelangelo Buonarroti', 43.776709, 11.258887,NULL);
INSERT INTO artwork VALUES ('Sunflowers','painting','Vincent Van Gogh', 48.149966, 11.570856,NULL);
INSERT INTO artwork VALUES ('Guernica',' painting','Pablo Picasso', 40.407561, -3.694042,NULL);

UPDATE artwork SET where_is = ST_POINT(showed_at_latitude, showed_at_longitude);

SELECT * FROM artwork;

SELECT artwork1.artwork_name, artwork2.artwork_name,
  ST_DISTANCE(artwork1.where_is, artwork2.where_is)
FROM
  artwork artwork1, artwork artwork2;

SELECT artwork1.artwork_name, artwork2.artwork_name,
  ST_DISTANCE(artwork1.where_is, artwork2.where_is) * 3.2808399
FROM artwork artwork1, artwork artwork2;

CREATE TABLE museum (
  museum_name     VARCHAR(20),
  country         VARCHAR(20),
  perimeter       GEOGRAPHY(POLYGON)
);
INSERT INTO museum VALUES ('Munich Pinakotek','Deuschtland',ST_GeogFromText('POLYGON((11 48,11 49,12 49,12 48,11 48))'));
INSERT INTO museum VALUES ('Accademia Gallery','Italy',ST_GeogFromText('POLYGON((11 43,11 44,12 44,12 43,11 43))'));
INSERT INTO museum VALUES ('Musee du Louvre','France',ST_GeogFromText('POLYGON((2 48,2 49,3 49,3 48,2 48))'));
INSERT INTO museum VALUES ('Museo Reina Sofia','Spain',ST_GeogFromText('POLYGON((-4 40,-4 41,-3 41,-3 40,-4 40))'));

SELECT  museum_name, st_area(perimeter)
FROM museum
ORDER BY 2 DESC;

SELECT artwork_name, museum_name
FROM museum, artwork
WHERE ST_INTERSECTS(where_is, perimeter);

