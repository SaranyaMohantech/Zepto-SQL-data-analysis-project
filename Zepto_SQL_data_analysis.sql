
CREATE DATABASE zepto_SQL_Projecct;
USE zepto_SQL_Projecct;

DROP TABLE IF EXISTS zepto_SQL_Projecct;

CREATE TABLE zepto(
sku_id int AUTO_INCREMENT,
category VARCHAR(120),
name varchar(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INT,
discountedSellingPrice NUMERIC(8,2),
weightInGms INT,
outOfStock BOOLEAN,
quantity INT,
PRIMARY KEY (sku_id)
);

ALTER TABLE zepto MODIFY sku_id int NOT NULL;

ALTER TABLE zepto MODIFY outOfStock VARCHAR(10);

#------count of rows------
SELECT COUNT(*) FROM zepto;

#-----sample data
SELECT * FROM zepto
LIMIT 10;

#------Checking on null
SELECT * FROM zepto
WHERE name IS NULL
OR 
category IS NULL
OR
mrp IS NULL
OR 
discountPercent IS NULL
OR 
availableQuantity IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
outOfStock IS NULL
OR 
quantity IS NULL;

#-----Different prod categories
SELECT distinct(category) FROM zepto
ORDER BY category;

#---Prods in stock VS out of stock
SELECT outOfStock, count(*) FROM zepto
GROUP BY outOfStock;

#----Prod name present multiple times
SELECT name, count(*) as 'Number of repeats' FROM zepto
GROUP BY name
HAVING count(*)> 1
ORDER BY count(*) DESC;

#----data cleaning------- Where price is 0
SELECT * FROM zepto
WHERE mrp = 0;

SET SQL_SAFE_UPDATES=0;
DELETE FROM zepto
WHERE mrp =0;
SET SQL_SAFE_UPDATES=1;

#-----convert paise to rupees
SET SQL_SAFE_UPDATES=0;
UPDATE zepto 
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;
SET SQL_SAFE_UPDATES=1;

#----Find top 10 best- valued products based on the discount percentage
SELECT distinct name, discountPercent, mrp FROM zepto
ORDER BY discountPercent DESC LIMIT 10;

#---what are the products with high mrp but out of stock
SELECT distinct name, mrp 
FROM zepto
WHERE outOfStock= 0 and mrp>300
ORDER BY mrp DESC;

#---Calculate the estimated revenue for each category
SELECT category, sum(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


#---Find all the products where MRP is greater than 500/- and discount is less than 10%
SELECT * FROM zepto
WHERE mrp>500 AND discountPercent<10;

#---Identify the top 5 categories offering the highest average discount percentage
SELECT category, ROUND(avg(discountPercent),2) AS avg_price
FROM zepto
GROUP BY category
ORDER BY avg(discountPercent) DESC LIMIT 5;

#---Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram FROM zepto
WHERE weightInGms >=100
ORDER BY price_per_gram; 

#---Group the products into categories like Low, Medium, Bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGmS >= 1000 THEN 'Bulk' 
	WHEN weightInGms >=500 AND weightInGms <= 1000 THEN 'Medium'
    ELSE 'Low'
END AS Weight_Measure 
FROM zepto;

#---What is the total inventory weight per category
SELECT DISTINCT category, SUM(weightInGms * availableQuantity) AS Category_Weight
FROM zepto
GROUP BY category
ORDER BY Category_Weight;
