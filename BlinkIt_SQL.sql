/* Create Database */
CREATE DATABASE blinkitdb

/* Create Table */
CREATE TABLE BLINKIT(
	Item_Fat_Content VARCHAR(20),
	Item_Identifier	VARCHAR(20),
	Item_Type VARCHAR(50),
	Outlet_Establishment_Year INT,
	Outlet_Identifier VARCHAR(20),
	Outlet_Location_Type VARCHAR(20),
	Outlet_Size	VARCHAR(20),
	Outlet_Type	VARCHAR(30),
	Item_Visibility	DECIMAL(10,9),
	Item_Weight	DECIMAL(10,5),
	Sales DECIMAL(10,5),
	Rating DECIMAL(5,4)
);

/* Show all data in the table */
SELECT * FROM BLINKIT

/* Copy/Import All data from excel(csv) file in sql */

COPY BLINKIT FROM 'D:/BlinkIT_Grocery_Data.csv' DELIMITER ',' CSV HEADER;

/* Again select all data inside a table */
SELECT COUNT(*) FROM BLINKIT

/* Clean the data */
UPDATE BLINKIT
SET Item_Fat_Content=
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT * FROM BLINKIT

SELECT DISTINCT(Item_Fat_Content) FROM BLINKIT

/* Part 1 : Business requrement - KPI's */

/* FIRST KPI AS TOTAL SALES*/

SELECT SUM(Sales) AS TOTAL_SALES 
FROM BLINKIT 

SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)) AS TOTAL_SALES_MILLIONS
FROM BLINKIT 

/* SECOND KPI AS AVERAGE SALES*/

SELECT AVG(Sales) AS AVERAGE_SALES 
FROM BLINKIT 

SELECT CAST(AVG(Sales) AS DECIMAL(10,0)) AS AVERAGE_SALES_MILLIONS
FROM BLINKIT 

/* THIRD KPI AS NUMBER OF ITEMS*/

SELECT COUNT(*) AS NUMBER_OF_ITEMS
FROM BLINKIT

/* FOURT KPI AS AVERAGE RATING*/

 SELECT AVG(Rating) AS AVERAGE_RATING
 FROM BLINKIT

 SELECT CAST(AVG(Rating) AS DECIMAL(10,2))AS AVERAGE_RATING
 FROM BLINKIT

/* Part 2 : Business Requriment - Granular Requrirement */
/* Total sale by fat content */

SELECT Item_Fat_Content, CAST(SUM(Sales) AS DECIMAL(10,2)) AS SUM_oF_SALES
FROM BLINKIT
GROUP BY Item_Fat_Content

/* Total sale by Item Type*/

SELECT Item_Type, CAST(SUM(Sales) AS DECIMAL(10,2)) AS SUM_oF_SALES_by_Item_type
FROM BLINKIT
GROUP BY Item_Type
ORDER BY SUM_oF_SALES_by_Item_type DESC

/* Fat content by outlet for Total sales*/

SELECT OUTLET_LOCATION_TYPE, ITEM_FAT_CONTENT,
	CAST(SUM(SALES) AS DECIMAL(10,2)) AS TOTAL_SALES
	FROM BLINKIT
	GROUP BY OUTLET_LOCATION_TYPE, ITEM_FAT_CONTENT
	ORDER BY TOTAL_SALES ASC



SELECT
  Outlet_Location_Type,
  COALESCE(SUM(Sales) FILTER (WHERE Item_Fat_Content = 'Low Fat'), 0) AS Low_Fat,
  COALESCE(SUM(Sales) FILTER (WHERE Item_Fat_Content = 'Regular'), 0) AS Regular
FROM BLINKIT
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;


/* Total Sales by Outlet Establishment */

SELECT Outlet_Establishment_Year,
	CAST(SUM(SALES) AS DECIMAL(10,2)) AS TOTAL_SALES
	FROM BLINKIT
	GROUP BY Outlet_Establishment_Year
	ORDER BY TOTAL_SALES ASC

/* Part 3 : Business Requriment - Charts Requriment */

/* Percentage of Sales by Outlet Size */

SELECT
Outlet_Size,
CAST (SUM(Sales) AS DECIMAL (10,2)) AS Total_Sales,
CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL (10,2)) AS Sales_Percentage
FROM BLINKIT
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

/* Sales by Outlet Location */

SELECT Outlet_Location_Type,
	CAST(SUM(SALES) AS DECIMAL(10,2)) AS TOTAL_SALES
	FROM BLINKIT
	GROUP BY Outlet_Location_Type
	ORDER BY TOTAL_SALES DESC

 /* All Matricx by Outlet Type */

SELECT Outlet_Type,
	CAST(SUM(SALES) AS DECIMAL(10,2)) AS TOTAL_SALES,
	CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL (10,2)) AS Sales_Percentage,
	CAST(AVG(SALES) AS DECIMAL(10,1)) AS Average_SALES,
	COUNT(*) AS NUMBER_oF_ITEM,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS average_Rating
FROM BLINKIT
GROUP BY Outlet_Type
ORDER BY TOTAL_SALES DESC

 

 
