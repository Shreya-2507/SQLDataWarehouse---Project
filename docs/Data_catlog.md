# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| Customer_Key     | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| Customer_ID      | INT           | Unique numerical identifier assigned to each customer.                                        |
| Customer_Number  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| FirstName        | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| LastName         | NVARCHAR(50)  | The customer's last name or family name.                                                     |
| Country          | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                               |
| Marital_Status   | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                              |
| Gender           | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                  |
| BirthDate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).               |
| Create_Date      | DATE          | The date and time when the customer record was created in the system|

---

### 2. **gold.dim_products**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| Product_Key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |
| Product_ID          | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |
| Product_Number      | NVARCHAR(50)  | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| Product_Name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.         |
| Category_ID         | NVARCHAR(50)  | A unique identifier for the product's category, linking to its high-level classification.     |
| Category            | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components) to group related items.  |
| SubCategory         | NVARCHAR(50)  | A more detailed classification of the product within the category, such as product type.      |
| Maintenance         | NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       |
| Cost                | INT           | The cost or base price of the product, measured in monetary units.                            |
| Product_Line        | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).      |
| Start_Date          | DATE          | The date when the product became available for sale or use, stored in|

---

### 3. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| Order_Number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                      |
| Product_Key     | INT           | Surrogate key linking the order to the product dimension table.                               |
| Customer_Key    | INT           | Surrogate key linking the order to the customer dimension table.                              |
| Order_Date      | DATE          | The date when the order was placed.                                                           |
| Shipping_Date   | DATE          | The date when the order was shipped to the customer.                                          |
| Due_Date        | DATE          | The date when the order payment was due.                                                      |
| Sales_Amount    | INT           | The total monetary value of the sale for the line item, in whole currency units (e.g., 25).   |
| Quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                       |
| Price           | INT           | The price per unit of the product for the line item, in whole currency units (e.g., 25).      |
