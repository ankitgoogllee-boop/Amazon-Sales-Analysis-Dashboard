create database amazon_analysis;
use amazon_analysis;
select * from amazon_sales;

-- TOP 5 CATEGORIES WITH HIGHEST SALES

SELECT category, SUM(amount) AS Total_sales
FROM amazon_sales
GROUP BY category 
ORDER BY total_sales DESC 
LIMIT 5;

-- ORDER STATUS ANALYSIS

SELECT status,
COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY status;

-- HOW MANY ORDERS ARE SHIPPED VS UNSHIPPED

SELECT courier_status,
COUNT(*) AS Total_orders
FROM amazon_sales
WHERE courier_status IN ('Shipped', 'Unshipped')
GROUP BY courier_status;

-- WHICH ORDERS HAVE QUANTITY GREATER THAN 2 ? 

SELECT order_id, category, qty, amount
FROM amazon_sales 
WHERE qty>2;

-- AVERAGE ORDER VALUE PER CATEGORY 

SELECT category, AVG(amount) 
FROM amazon_sales
GROUP BY category;

-- TOTAL QUANTITY SOLD PER SIZE

SELECT size, COUNT(qty)
FROM amazon_sales
GROUP BY size
ORDER BY 2 DESC;

-- WHICH STATE HAS THE HIGHEST NO. OF ORDERS ?

SELECT ship_state, COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY ship_state
ORDER BY 2 DESC;

-- WHICH CITY HAS THE HIGHEST NO. OF ORDERS ?
SELECT ship_city, COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY ship_city
ORDER BY 2 DESC;

-- CATEGORY VS REVENUE ?

SELECT category, SUM(amount) AS Revenue
FROM amazon_sales
GROUP BY category
ORDER BY 2 DESC;

-- WHICH STATE HAS THE HIGHEST CANCELLATIONS ?

SELECT ship_state, COUNT(*) AS Cancelled_orders
FROM amazon_sales 
WHERE courier_status = "Cancelled"
GROUP BY ship_state
ORDER BY 2 DESC;

-- WHAT PERCENTAGE OF ORDERS ARE CANCELLED ?

SELECT ROUND(100.0*SUM(CASE
WHEN LOWER (status) LIKE '%cancel%' THEN 1 ELSE 0
END)/ COUNT(*), 
2) AS Cancelled_percent
FROM amazon_sales;

-- CATEGORIES AND THEIR CANCELLATION RATE ?

SELECT category,
 ROUND(100.0*SUM(CASE
WHEN LOWER (status) LIKE '%cancel%' THEN 1 ELSE 0
END)/ COUNT(*), 
2) AS Cancellation_rate
FROM amazon_sales
GROUP BY category 
ORDER BY Cancellation_rate DESC;

-- WHICH FULFILLMENT METHOD HANDLES MOST ORDERS ?

SELECT fulfilment, COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY fulfilment
ORDER BY 2 DESC;

-- HOW MANY ORDERS USED PROMOTION IDS ?

SELECT promotion_ids, COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY promotion_ids
ORDER BY 2 DESC;

-- WHICH CATEGORY CONTRIBUTES MOST TO OVERALL REVENUE?

SELECT category, SUM(amount) AS Revenue
FROM amazon_sales
GROUP BY category
ORDER BY 2 DESC
LIMIT 1;

-- DRIVERS OF HIGH-VALUE ORDERS 

SELECT category, 
fulfilment, 
qty, 
COUNT(*) as total_orders, 
ROUND(AVG(amount), 2) as Avg_order_value 
FROM amazon_sales
GROUP BY category, fulfilment, qty
ORDER BY Avg_order_value DESC
LIMIT 10;

SELECT fulfilment, 
status,
COUNT(*) AS Total_cancellations
FROM amazon_sales
WHERE status = "Cancelled"
GROUP BY fulfilment
ORDER BY Total_cancellations DESC;

-- IDENTIFY UNDERPERFORMING CATEGORIES

SELECT category, 
COUNT(*) AS Total_orders,
SUM(amount) AS Total_revenue, 
SUM(CASE WHEN LOWER(status) LIKE '%cancel%' THEN 1 ELSE 0 END) AS Cancelled_orders,
ROUND(100.0*SUM(CASE WHEN LOWER(status) LIKE '%cancel%' THEN 1 ELSE 0 END)/COUNT(*) ,2) AS Cancellation_rate
FROM amazon_sales
GROUP BY category
ORDER BY Total_revenue;

-- ANALYZE IMPACT OF PROMOTION AND NO-PROMOTION ON SALES

SELECT category,
SUM(CASE WHEN LOWER(promotion_ids) != 'no promotion' THEN amount ELSE 0 END) AS promo_revenue,
SUM(CASE WHEN LOWER(promotion_ids) = 'no promotion' THEN amount ELSE 0 END) AS No_promo_revenue,
SUM(amount) AS total_revenue,
ROUND(100.0 * SUM(CASE WHEN LOWER(promotion_ids) != 'no promotion' THEN amount ELSE 0 END) 
/ SUM(amount),2) AS promo_revenue_percent,
ROUND(100.0 * SUM(CASE WHEN LOWER(promotion_ids) = 'no promotion' THEN amount ELSE 0 END) 
/ SUM(amount),2) AS No_promo_revenue_percent
FROM amazon_sales
GROUP BY category;

