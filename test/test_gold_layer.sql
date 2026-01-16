-- ====================================================================
-- Checking 'gold.Dim_Customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    Customer_Key,
    COUNT(*) AS duplicate_count
FROM gold.Dim_Customers
GROUP BY Customer_Key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    Product_Key,
    COUNT(*) AS duplicate_count
FROM gold.Dim_Products
GROUP BY Product_Key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.Fact_Sales F
LEFT JOIN gold.Dim_Customers c
ON c.Customer_Key = F.Customer_Key
LEFT JOIN gold.Dim_Products p
ON P.Product_Key = F.Product_Key
WHERE P.Product_key IS NULL
