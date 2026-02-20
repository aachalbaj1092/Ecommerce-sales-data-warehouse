--SQL Database Schema

CREATE TABLE DimCountry (
    CountryKey SERIAL PRIMARY KEY,
    CountryName VARCHAR(100) UNIQUE
);

SELECT * FROM DIMCOUNTRY;

CREATE TABLE DimCustomer (
    CustomerKey SERIAL PRIMARY KEY,
    CustomerID INT,
    CountryKey INT,
    CONSTRAINT FK_Customer_Country 
        FOREIGN KEY (CountryKey) REFERENCES DimCountry(CountryKey)
);

SELECT * FROM DIMCUSTOMER;

CREATE TABLE DimProduct (
    ProductKey SERIAL PRIMARY KEY,
    StockCode VARCHAR(20),
    Description VARCHAR(255)
);

SELECT * FROM DIMPRODUCT;

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,   -- format YYYYMMDD
    FullDate DATE,
    Day INT,
    Month INT,
    MonthName VARCHAR(20),
    Quarter INT,
    Year INT
);
SELECT * FROM DIMDATE;

CREATE TABLE FactSales (
    SalesKey BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    InvoiceNo VARCHAR(20),
    ProductKey INT,
    CustomerKey INT,
    DateKey INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount DECIMAL(12,2),

    CONSTRAINT fk_sales_product
        FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey),

    CONSTRAINT fk_sales_customer
        FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),

    CONSTRAINT fk_sales_date
        FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
);

SELECT * FROM FACTSALES;

--Indexes

CREATE INDEX idx_fact_product ON FactSales(ProductKey);
CREATE INDEX idx_fact_customer ON FactSales(CustomerKey);
CREATE INDEX idx_fact_date ON FactSales(DateKey);

SELECT * FROM pg_indexes
WHERE tablename = 'factsales';
