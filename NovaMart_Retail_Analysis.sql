-- NOVAMART RETAIL & LOGISTICS ANALYSIS
-- DATA EXPLORATION OVERVIEW
SELECT
	`Order ID`,
    `Quantity`,
    `Unit Price`,
    `Revenue`,
    `Cost`,
    `Profit`,
    `Returned`
FROM sales
WHERE `Revenue`<0
;

-- Data Validity --
SELECT
    `Order ID`,
    `Order Date`,
    `Ship Date`,
    `Customer Type`,
    `Category`,
    `Product Name`,
    `Quantity`,
    `Unit Price`,
    `Discount %`,
    `Revenue`,
    `Cost`,
    `Profit`,
    `Returned`,
    `Date Validity`
FROM sales
WHERE Revenue < 0
ORDER BY Revenue ASC;

SELECT
    COUNT(*) AS Negative_Revenue,
    SUM(CASE WHEN Cost < 0 THEN 1 ELSE 0 END) AS Negative_Cost,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS Negative_Profit
FROM sales
WHERE Revenue < 0;

SELECT
    COUNT(DISTINCT `Order ID`) AS Returned_With_Positive_Revenue
FROM sales
WHERE `Returned` = 'Yes'
  AND Revenue >= 0;
        
	
    SELECT
    `Returned`,
    `Date Validity`,
    COUNT(*) AS Transaction_Count,
    SUM(`Revenue`) AS Total_Revenue,
    SUM(`Profit`) AS Total_Profit
FROM sales
WHERE Revenue < 0
GROUP BY
    `Returned`,
    `Date Validity`
ORDER BY
    `Returned`,
    `Date Validity`;


-- What was NovaMart's total revenue ?
SELECT 
	SUM(Revenue) AS Total_Revenue
FROM sales
WHERE `Revenue` > 0;

-- Which Product Category Generated the Most Revenue?
SELECT 
	Category,
    SUM(Revenue) AS Total_Revenue
FROM
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	Category
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Top 5 Products By Revenue
SELECT 
`Product Name`,
    SUM(Revenue) As Total_Revenue
FROM
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	`Product Name`
ORDER BY 
	Total_Revenue DESC
LIMIT 5;

-- Total Monthly Revenue
SELECT
	DATE_FORMAT(`Order Date`,'%Y-%m') AS Sales_Month,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(`Quantity`) AS Total_Units_Sold,
    SUM(`Revenue`) AS Total_Revenue
FROM sales
WHERE `Revenue` > 0
GROUP BY Sales_Month
ORDER BY Sales_Month;


-- Total Sales Made by SalesPersons
SELECT 
	`Salesperson`,
    SUM(`Revenue`) AS Total_Revenue
FROM 
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	`Salesperson`
ORDER BY Total_Revenue DESC;

-- Average Order Value (AOV)
SELECT 
	ROUND(SUM(`Revenue`)/ COUNT(DISTINCT `Order ID`),2) AS AOV
FROM sales
WHERE `Revenue` > 0;

-- Which Customer Type has The Highest AOV?
SELECT 
	`Customer Type`,
    ROUND(SUM(`Revenue`)/ COUNT(DISTINCT `Order ID`),2) AS AOV
FROM 
	sales
WHERE
	`Revenue` > 0
GROUP BY
	`Customer Type`
ORDER BY AOV DESC;

-- Which Customer Type Generates More Total Revenue, How Many Orders Does Each Customer Type Make?
SELECT
	`Customer Type`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(`Revenue`) AS Total_Revenue
FROM 
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	`Customer Type`
ORDER BY Total_Revenue DESC;

-- Which Category Generates The Highest Profit and What Is The Profit Margin?
SELECT
	`Category`,
    SUM(`Revenue`) AS Total_Revenue,
    SUM(`Profit`) AS Total_Profit,
    ROUND((SUM(`Profit`)/ SUM(`Revenue`)) * 100,2) AS Profit_Margin
FROM 
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	`Category`
ORDER BY Total_Profit DESC;    

-- How Does Discount Percentage Affect profit Margins Accross?
SELECT
	`Category`,
    ROUND(AVG(`Discount %`),2) AS Avg_Discount,
    SUM(`Quantity`) AS Total_Units_Sold,
    SUM(`Revenue`) AS Total_Revenue,
    SUM(`Profit`) AS Total_Profit,
    ROUND((SUM(`Profit`)/ SUM(`Revenue`)) * 100,2) AS Profit_Margin
FROM 
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	`Category`
ORDER BY 
	Avg_Discount DESC;
    
-- Which Store Has Longest Shipping Lead Time?
SELECT
	`Store Branch`,
    ROUND(AvG(DATEDIFF(`Ship Date`,`Order Date`)),1) AS Avg_Shipping_Days
FROM
	sales
WHERE 
	`Date Validity` = 'Valid'
GROUP BY 
	`Store Branch`
ORDER BY 
	Avg_Shipping_Days DESC;
    
-- Which Product Category Has The Highest Return Rate?
SELECT
    `Category`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,

    COUNT(DISTINCT CASE
        WHEN `Returned` = 'Yes' THEN `Order ID`
    END) AS Total_Returns,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN `Returned` = 'Yes' THEN `Order ID`
        END)
        / COUNT(DISTINCT `Order ID`) * 100,
        2
    ) AS Return_Rate

FROM sales

GROUP BY `Category`

ORDER BY Return_Rate DESC;

-- Which Payment Method Was used The Most, And Does it Generate The Highest Average Order Value(AOV)?
SELECT
	`Payment Method`,
	COUNT(DISTINCT `Order ID`) AS Total_Order,
    SUM(`Revenue`) AS Total_Revenue,
    ROUND(SUM(`Revenue`)/ COUNT(DISTINCT `Order ID`),2) AS AOV
FROM 
	sales
WHERE
	`Revenue` > 0
GROUP BY 
	`Payment Method`
ORDER BY 
	Total_Order DESC;
    
    -- Order Classification Based On Revenue
SELECT
	    CASE
			WHEN `Revenue`>=5000 THEN 'High'
			WHEN `Revenue` >=2000 THEN 'Medium'
			ELSE 'Low'
		END AS Revenue_Category,
	COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(`Revenue`) AS Total_Revenue,
    ROUND(
    (COUNT(DISTINCT `Order ID`)/
				(SELECT COUNT(DISTINCT `Order ID`)
					FROM 
						sales
							WHERE 
								`Revenue`>0)
								)*100,3) AS Percentage_Of_Orders
FROM 
	sales
WHERE 
	`Revenue`>0
GROUP BY 
	Revenue_Category
ORDER BY 
	Total_Revenue DESC;

-- Product Categories That Generated More Than 1M Cedis In Revenue
SELECT
	`Category`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(`Revenue`) AS Total_Revenue
FROM 
	sales
WHERE 
	`Revenue`>0
GROUP BY
	`Category`
HAVING
	Total_Revenue>1000000
ORDER BY Total_Revenue DESC;


-- Which products generated more revenue than the average product revenue
WITH Avg_Product_Revenue AS (
		SELECT
			SUM(`Revenue`)/COUNT(DISTINCT `Product Name`) AS  Avg_Revenue_Per_Product 
		FROM sales
        WHERE `Revenue`>0
)
SELECT 
	s.`Product Name`,
    SUM(s.`Revenue`) AS Total_Revenue
FROM 
	sales s, Avg_Product_Revenue APR
WHERE 
	s.`Revenue`> 0
GROUP BY
	s.`Product Name`, APR.Avg_Revenue_Per_Product
HAVING 
	Total_Revenue > APR.Avg_Revenue_Per_Product
ORDER BY
	Total_Revenue DESC;

-- Regions with Total Revenue Greater than Average Revenue Per Region
WITH Avg_Region_Revenue AS (
	SELECT
		SUM(`Revenue`)/COUNT(DISTINCT `Region`) AS Avg_Revenue_Per_Region
	FROM sales
    WHERE `Revenue`> 0
)
SELECT
	`Region`,
    SUM(`Revenue`) AS Total_Revenue
FROM
	sales s, Avg_Region_Revenue ARR
WHERE 
	s.`Revenue`> 0
GROUP BY 
	`Region`, ARR.Avg_Revenue_Per_Region
HAVING 
	Total_Revenue > ARR.Avg_Revenue_Per_Region
ORDER BY 
	Total_Revenue DESC;
    
    -- Which customers have spent more than the average customer spending at NovaMart?
WITH Customer_Revenue AS(
	SELECT 
		  `Customer Name`,
		  SUM(`Revenue`) AS Total_Revenue_By_Customer
	FROM sales
    WHERE `Revenue` > 0
    GROUP BY `Customer Name`
),
Avg_Customer_Revenue AS(
	SELECT 
		AVG(Total_Revenue_By_Customer) AS Avg_Revenue_By_Customer
    FROM Customer_Revenue
)
SELECT
	CR.`Customer Name`,
    CR.Total_Revenue_By_Customer
FROM 
	  Customer_Revenue CR 
CROSS JOIN      
      Avg_Customer_Revenue ACR
WHERE
	CR.Total_Revenue_By_Customer > ACR.Avg_Revenue_By_Customer
ORDER BY 
	CR.Total_Revenue_By_Customer DESC;
    
  
    -- What are the top products within each product category?  
WITH Ranked_Products AS(
	SELECT	
		`category`,
        `Product Name`,
        SUM(`Revenue`) AS Total_Revenue,
        ROW_NUMBER()OVER(
			PARTITION BY `Category`
				ORDER BY SUM(`Revenue`) DESC
        ) AS Revenue_Rank_With_Category
	FROM sales
    WHERE `Revenue` > 0
    GROUP BY `Product Name`,`Category`
        
)
SELECT
	RK.`Category`,
    RK.`Product Name`,
    RK.Total_Revenue,
    RK.Revenue_Rank_With_Category
FROM
	Ranked_Products RK
WHERE
	RK.Revenue_Rank_With_Category <=3
ORDER BY
	RK.`Category`,RK.Total_Revenue DESC;
    
    
    -- MoM Percentage Growth
WITH Monthly_Revenue AS(
	 SELECT 
		DATE_FORMAT(`Order Date`,'%Y-%m') AS Sales_Month,
        SUM(`Revenue`) AS Total_Revenue
	FROM sales
    WHERE `Revenue` > 0
    GROUP BY Sales_Month
),
Previous_Month AS(
	SELECT
		Sales_Month,
        LAG(Total_Revenue)OVER(
			ORDER BY Sales_Month 
        ) AS Previous_Monthly_Revenue
	FROM Monthly_Revenue
)
SELECT
	MR.Sales_Month,
    MR.Total_Revenue,
    PM.Previous_Monthly_Revenue,
    ROUND(((MR.Total_Revenue - PM.Previous_Monthly_Revenue)/ PM.Previous_Monthly_Revenue) * 100,2) AS MoM_Percentage
FROM
	 Monthly_Revenue MR
JOIN
	Previous_Month PM
ON 
	MR.Sales_Month = PM.Sales_Month
ORDER BY
	MR.Sales_Month;
    

    -- Which customers are the most valuable to NovaMart based on their total spending?
SELECT
	`Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Total_Order,
    SUM(`Revenue`) AS Total_Revenue,
    SUM(`Revenue`)/COUNT(DISTINCT `Order ID`) AS AOV,
   ROUND(( SUM(`Revenue`)/
   (SELECT
		SUM(`Revenue`) AS Total_NovaMart_Revenue
		FROM sales
		WHERE `Revenue` > 0)
	)*100,2) AS Revenue_Percentage

FROM
	sales
WHERE 
	`Revenue` > 0
GROUP BY
	`Customer Name`
ORDER BY
	Total_Revenue DESC
LIMIT 10;

-- Total Percentage of Revenue By top 1-0 customers
WITH Top_10_Customer AS(
	SELECT
		`Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Total_Order,
    SUM(`Revenue`) AS Total_Revenue,
    SUM(`Revenue`)/COUNT(DISTINCT `Order ID`) AS AOV,
   ROUND(( SUM(`Revenue`)/
   (SELECT
		SUM(`Revenue`) AS Total_NovaMart_Revenue
		FROM sales
		WHERE `Revenue` > 0)
	)*100,2) AS Revenue_Percentage

FROM
	sales
WHERE 
	`Revenue` > 0
GROUP BY
	`Customer Name`
ORDER BY
	Total_Revenue DESC
LIMIT 10
)
SELECT
	SUM(Total_Revenue) AS Top_10_Customer_Revenue,
    SUM(Revenue_Percentage) AS Percentage_Of_Total_Revenue
FROM Top_10_Customer

ORDER BY Percentage_Of_Total_Revenue;

