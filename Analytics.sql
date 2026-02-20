--Business Intelligence Queries (Analytics Layer)

--Total Revenue
SELECT SUM(TotalAmount) AS TotalRevenue
FROM FactSales;

--Revenue by Country
SELECT c.CountryName, SUM(f.TotalAmount) AS Revenue
FROM FactSales f
JOIN DimCustomer cu ON f.CustomerKey = cu.CustomerKey
JOIN DimCountry c ON cu.CountryKey = c.CountryKey
GROUP BY c.CountryName
ORDER BY Revenue DESC;

--Top 10 Products
SELECT TOP 10 p.Description,
       SUM(f.Quantity) AS TotalSold
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY TotalSold DESC;

--Monthly Revenue Trend
SELECT d.Year, d.MonthName,
       SUM(f.TotalAmount) AS MonthlyRevenue
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year, d.Month, d.MonthName
ORDER BY d.Year, d.Month;

--Customer Lifetime Value
SELECT cu.CustomerID,
       SUM(f.TotalAmount) AS CustomerRevenue
FROM FactSales f
JOIN DimCustomer cu ON f.CustomerKey = cu.CustomerKey
GROUP BY cu.CustomerID
ORDER BY CustomerRevenue DESC;

--Total Quantity Sold per Product
SELECT 
    p.Description,
    SUM(f.Quantity) AS Total_Quantity_Sold
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Total_Quantity_Sold DESC;

--Current Inventory Estimation
SELECT 
    p.Description,
    SUM(f.Quantity) AS Units_Sold
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Units_Sold DESC;

--Monthly Product Sales Trend
SELECT 
    p.Description,
    d.Year,
    d.Month,
    SUM(f.Quantity) AS Monthly_Sales
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY p.Description, d.Year, d.Month
ORDER BY d.Year, d.Month;

--Low Performing Products
SELECT 
    p.Description,
    SUM(f.Quantity) AS Total_Sold
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
HAVING SUM(f.Quantity) < 50
ORDER BY Total_Sold ASC;

--Revenue per Product
SELECT 
    p.Description,
    SUM(f.TotalAmount) AS Total_Revenue
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Total_Revenue DESC;

--Average Selling Price per Product
SELECT 
    p.Description,
    AVG(f.UnitPrice) AS Avg_Price
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Avg_Price DESC;

--Fast Moving Products (Top 10)
SELECT 
    p.Description,
    SUM(f.Quantity) AS Total_Sold
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Total_Sold DESC
LIMIT 10;

--Inventory Turnover Indicator
SELECT 
    p.Description,
    SUM(f.Quantity) AS Units_Sold,
    COUNT(DISTINCT f.InvoiceNo) AS Number_of_Orders
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Units_Sold DESC;

--Country-wise Inventory Demand
SELECT 
    p.Description,
    SUM(f.Quantity) AS Units_Sold,
    COUNT(DISTINCT f.InvoiceNo) AS Number_of_Orders
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Description
ORDER BY Units_Sold DESC;

--Products Not Sold Recently
SELECT 
    p.Description
FROM DimProduct p
LEFT JOIN FactSales f ON p.ProductKey = f.ProductKey
LEFT JOIN DimDate d ON f.DateKey = d.DateKey
WHERE d.FullDate >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY p.Description
HAVING SUM(f.Quantity) IS NULL;
