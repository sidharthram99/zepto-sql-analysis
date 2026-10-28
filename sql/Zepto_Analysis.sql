Drop Table if exists zepto;

CREATE TABLE zepto(
sku_id serial PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);
--Data Exploration

SELECT COUNT(*) FROM zepto;

--Sample Data

SELECT * FROM zepto Limit 10;

--NULL VALUES
SELECT * FROM zepto 
WHERE name is NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

---Different product Categories

SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Products in stock vs out of stock

SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--Product Names present multiple times

SELECT name, count(sku_id)as "Number of SKUs"
FROM zepto
GROUP BY name 
Having COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--Data Cleaning

SELECT * FROM zepto
Where mrp=0 OR
discountedSellingPrice=0;

--we have one product with mrp zero thats not right which needs to be removed

DELETE FROM zepto 
WHERE mrp=0;

--Converting Paise into Rupees
-- Run only once re-running divides prices again

UPDATE zepto 
SET mrp= mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

--Lets check

SELECT mrp, discountedSellingPrice From Zepto
LIMIT 10;

--Q1.Find the top 10 best value products based on discounted percentage

SELECT DISTINCT name, mrp , discountPercent FROM
zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2.What are the products with High MRP but out of stock

SELECT DISTINCT NAME ,mrp FROM  zepto
WHERE outOfStock = TRUE AND mrp>300
ORDER BY mrp DESC;

--Q3.Calculate Estimated revenue for each category

SELECT category, SUM(discountedSellingPrice*availableQuantity) AS Total_Revenue
FROM ZEPTO
GROUP BY CATEGORY
ORDER BY Total_Revenue;

--Q4.Find all products where MRP is greater than 500 and discount is less than 10%

SELECT DISTINCT NAME , mrp , discountPercent FROM zepto
WHERE mrp >500 AND discountPercent <10
ORDER BY mrp DESC ,discountPercent DESC;

--Q5.Identify the top 5 categories offering the highest average discount percentage

SELECT category, Round(AVG(discountPercent),2) AS AVG_Discount
FROM zepto
GROUP BY category
ORDER BY AVG_Discount DESC
LIMIT 5;

--Q6.Find the price per gram for products 100g and sort by best value

SELECT DISTINCT name, weightInGms,discountedSellingPrice,
Round(discountedSellingPrice/weightInGms,2) AS Price_Per_Gm
FROM zepto
WHERE weightInGms >=100
ORDER BY Price_Per_Gm;

--Q7.Group the products in categories like Low,Medium,Bulk

Select DISTINCT name,weightInGms,
Case when weightInGms <1000 then 'Low'
     when weightInGms <5000 then 'Medium'
	 else 'Bulk' 
	 End AS Weight_Category
From zepto;

--Q8.What is the total Inventory weight per category

SELECT category, SUM(weightInGms*availableQuantity) AS Total_Weight
FROM ZEPTO
GROUP BY category
ORDER BY Total_Weight;