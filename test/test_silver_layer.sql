-- Expectation no result :

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key)

--Data Standarization & Consistency

SELECT DISTINCT cst_material_status
FROM bronze.crm_cust_info


-- CHECK FOR ANY DUPLICATE AND NULL

SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL

--CHECK FOR UNEXPECTED RESULT

SELECT 
		cst_firstname,
		cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname)

SELECT DISTINCT(cst_gndr)
FROM silver.crm_cust_info


SELECT *
FROM silver.crm_cust_info

-- Check for nulls or duplicates in primary key
-- Expectation no result

Select 
	prd_id,
	COUNT(*)
--From bronze.crm_prod_info
FROM silver.crm_prod_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL

Select 
	prd_key,
	COUNT(*)
--From bronze.crm_prod_info
FROM silver.crm_prod_info
GROUP BY prd_key
HAVING COUNT(*) >1 OR prd_key IS NULL

-- CHECK FOR UNWANTED SPACES
-- EXPECTATION : NO RESULT

SELECT 
	prd_nm
--FROM bronze.crm_prod_info
FROM silver.crm_prod_info
WHERE prd_nm != TRIM(prd_nm)


-- CHECK FOR NULLS AND NEGATIVE NUMBERS
-- EXPECTATION NO RESULT

SELECT 
	prd_cost
--FROM bronze.crm_prod_info
FROM silver.crm_prod_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--DATA STANDARIZATION & CONSISTENCY

SELECT DISTINCT prd_line
--FROM bronze.crm_prod_info
FROM silver.crm_prod_info

-- Check for invalid date orders

SELECT * 
--FROM bronze.crm_prod_info
FROM silver.crm_prod_info
WHERE prd_start_dt > prd_end_dt


SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt <= 0 OR  LEN(sls_order_dt) != 8 THEN NULL
	     ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_order_dt <= 0 OR  LEN(sls_order_dt) != 8 THEN NULL
	     ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 OR  LEN(sls_due_dt) != 8 THEN NULL
	     ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <=0  OR sls_sales != sls_quantity * ABS(sls_price)
	          THEN sls_quantity * ABS(sls_price)
	     ELSE sls_sales
	END sls_sales ,
	sls_quantity,
	CASE WHEN sls_price  IS NULL OR  sls_price <= 0 THEN sls_sales/NULLIF(sls_quantity , 0)
	     ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prod_info)
--WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)
--WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prod_info)

-- Check for invalid dates

SELECT
   sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) !=8 OR sls_order_dt >20500101 OR sls_order_dt < 19000101 

SELECT
   sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR sls_ship_dt IS NULL

-- same validation for sls_due_dt

-- Check for invalid date order
-- Check Data Consistency between sales.Quantity and price
--- =) Sales = Quantity * price
--  =)values must not be null , negative or zero

SELECT DISTINCT
	sls_quantity,
	sls_sales AS old_sls_sales,
	sls_price AS old_sls_price,
	CASE WHEN sls_sales IS NULL OR sls_sales <=0  OR sls_sales != sls_quantity * ABS(sls_price)
	          THEN sls_quantity * ABS(sls_price)
	     ELSE sls_sales
	END sls_sales ,

	CASE WHEN sls_price  IS NULL OR  sls_price <= 0 THEN sls_sales/NULLIF(sls_quantity , 0)
	     ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL OR
sls_sales <=0 OR sls_price <=0 OR sls_quantity <=0
ORDER BY sls_quantity,
	old_sls_sales,
	old_sls_price


SELECT * FROM silver.crm_sales_details



-- Identify out of range dates

SELECT DISTINCT 
      bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standarization and consistency

SELECT DISTINCT 
         gen,
	      CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			 WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'			 
		  ELSE 'N/A'
		END AS gen
FROM bronze.erp_cust_az12

-- Identify out of range dates

SELECT DISTINCT 
      bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standarization and consistency

SELECT DISTINCT 
gen,
	      CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			 WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'			 
		  ELSE 'N/A'
		END AS gen
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12


EXEC bronze.load_bronze
GO
EXEC silver.load_silver
