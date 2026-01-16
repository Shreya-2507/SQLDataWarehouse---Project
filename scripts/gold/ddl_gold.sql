-- =============================================================================
-- Create Dimension: gold.Dim_Customers
-- =============================================================================
IF OBJECT_ID('gold.Dim_Customers', 'V') IS NOT NULL
    DROP VIEW gold.Dim_Customers;
GO

CREATE VIEW gold.Dim_Customers AS
SELECT 
		ROW_NUMBER() OVER (ORDER BY cst_id) AS Customer_Key,
		ci.cst_id                AS Customer_ID,
		ci.cst_key               AS Customer_Number,
		ci.cst_firstname         AS FirstName,
		ci.cst_lastname          AS LastName,
		la.cntry                 AS Country,
		ci.cst_material_status   AS Martial_status,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  --CRM contains primary info of customer then ERP
				ELSE COALESCE(ca.gen , 'N/A')
		END                       AS Gender,
		ca.bdate                 AS BirthDate,
		ci.cst_create_date       AS Create_Date
	FROM silver.crm_cust_info AS ci
	LEFT JOIN silver.erp_cust_az12  ca
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.Dim_Products', 'V') IS NOT NULL
    DROP VIEW gold.Dim_Products;
GO

CREATE VIEW gold.Dim_Products AS
SELECT
		ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt,pi.prd_key) AS Product_key ,
		pi.prd_id              AS Product_ID,
		pi.prd_key             AS Product_Number,
		pi.prd_nm              AS Product_Name,
		pi.cat_id              AS Category_ID,
		pcg.cat                AS Category,
		pcg.subcat             AS SubCategory,
		pcg.maintenance        AS Maintenance,
		pi.prd_cost            AS Cost,
		pi.prd_line            AS Product_Line,	
		pi.prd_start_dt        AS Start_Date
	FROM silver.crm_prod_info AS pi
	LEFT JOIN silver.erp_px_cat_g1v2  pcg
	ON  pi.cat_id = pcg.id
	WHERE prd_end_dt IS NULL  -- FILTERATION FROM HISTORICAL DATA
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.Fact_Sales', 'V') IS NOT NULL
    DROP VIEW gold.Fact_Sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
		sls_ord_num AS Order_Number,
		pro.Product_Key,
		cust.Customer_Key,
		sls_order_dt AS Order_Date,
		sls_ship_dt AS Shipping_Date,
		sls_due_dt AS Due_Date,
		sls_sales AS Sales_Amount,
		sls_quantity AS Quantity,
		sls_price AS Price
	FROM silver.crm_sales_details AS sd
	LEFT JOIN gold.Dim_Products pro
	ON sd.sls_prd_key = pro.Product_Number
	LEFT JOIN gold.Dim_Customers cust
	ON sd.sls_cust_id = cust.Customer_ID
GO
