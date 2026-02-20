--Staging Table

CREATE TABLE StagingRetail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10,2),
    CustomerID INT,
    Country VARCHAR(100)
);

SELECT * FROM STAGINGRETAIL;

--load data 

COPY  StagingRetail
FROM 'C:\Program Files\PostgreSQL\18\Data.csv'
WITH (
    FORMAT csv,
    HEADER true,
    ENCODING 'WIN1252'
);

--cleaning data	

--Remove cancelled invoices
DELETE FROM StagingRetail
WHERE InvoiceNo LIKE 'C%';

--Remove NULL customers
DELETE FROM StagingRetail
WHERE CustomerID IS NULL;

--Load Dimension Tables

INSERT INTO DimCountry (CountryName)
SELECT DISTINCT Country
FROM StagingRetail;

INSERT INTO DimCustomer (CustomerID, CountryKey)
SELECT DISTINCT s.CustomerID, c.CountryKey
FROM StagingRetail s
JOIN DimCountry c
ON s.Country = c.CountryName;

INSERT INTO DimProduct (StockCode, Description)
SELECT DISTINCT StockCode, Description
FROM StagingRetail;

INSERT INTO DimDate (
    DateKey,
    FullDate,
    Day,
    Month,
    MonthName,
    Quarter,
    Year
)
SELECT DISTINCT
    TO_CHAR(InvoiceDate, 'YYYYMMDD')::INT,
    DATE(InvoiceDate),
    EXTRACT(DAY FROM InvoiceDate),
    EXTRACT(MONTH FROM InvoiceDate),
    TO_CHAR(InvoiceDate, 'Month'),
    EXTRACT(QUARTER FROM InvoiceDate),
    EXTRACT(YEAR FROM InvoiceDate)
FROM StagingRetail;

INSERT INTO FactSales
(
    InvoiceNo,
    ProductKey,
    CustomerKey,
    DateKey,
    Quantity,
    UnitPrice,
    TotalAmount
)
SELECT
    s.InvoiceNo,
    p.ProductKey,
    c.CustomerKey,
    TO_CHAR(s.InvoiceDate, 'YYYYMMDD')::INT,
    s.Quantity,
    s.UnitPrice,
    s.Quantity * s.UnitPrice
FROM StagingRetail s
JOIN DimProduct p
    ON s.StockCode = p.StockCode
JOIN DimCustomer c
    ON s.CustomerID = c.CustomerID;

