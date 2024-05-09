---Queries written by Nathan D'Agostino, Lucas Arena, and Keyan Ridgeway


SELECT i.IngredientName, doa.ArrivalDate, eub.UseByDate
FROM Inventory i
INNER JOIN DateOfArrival doa ON i.Itemid = doa.ItemID
INNER JOIN ExpectedUseByDate eub ON i.Itemid = eub.ItemID
WHERE eub.UseByDate < current_date;


SELECT i.IngredientName, o.IsOpened
FROM Inventory i
INNER JOIN Opened o ON i.Itemid = o.ItemID
WHERE o.IsOpened = TRUE;


SELECT i.IngredientName, a.Quantity
FROM Inventory i
INNER JOIN Amount a ON i.Itemid = a.ItemID
WHERE a.Quantity <= 2;  -- You can adjust the threshold here

SELECT i.IngredientName, doa.ArrivalDate, sb.SigneeName
FROM Inventory i
INNER JOIN DateOfArrival doa ON i.Itemid = doa.ItemID
INNER JOIN SignedBy sb ON i.Itemid = sb.ItemID
WHERE sb.SigneeName = 'Craig Booly';  -- You can change the name here

--Say a restraunt owner thinks that they got an item, but cant seem to
--find the item anywhere; They can run a query to return all items that were
--in the most recent delivery to make sure they got it or not. 
--Query to return all items that were in the last inventory delivery

SELECT i.ItemID, i.IngredientName, da.ArrivalDate
FROM Inventory i
JOIN DateOfArrival da ON i.ItemID = da.ItemID
WHERE da.ArrivalDate = (SELECT MAX(ArrivalDate) FROM DateOfArrival);


--The owner or chef wants to know which items are open if any,
--so they can use the open items first. 
--Query to return all open items, the use by date, and batch number

SELECT i.ItemID, i.IngredientName, e.UseByDate, b.BatchNumber
FROM Inventory i
JOIN ExpectedUseByDate e ON i.ItemID = e.ItemID
JOIN Opened o ON i.ItemID = o.ItemID
JOIN BatchNumber b ON i.ItemID = b.ItemID
WHERE o.IsOpened = true;


--The owner wants to know the price of each item in their inventory,
--to be able to track their expenses.
--Add and populate price table, and query to list all items
--and their price in decreasing order.
CREATE TABLE Price (
    PriceID SERIAL PRIMARY KEY,
    ItemID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

INSERT INTO Price (ItemID, Price) VALUES
(1, 2.99),  -- Radish price
(2, 3.49),  -- Pasta price
(3, 5.99),  -- Ground Beef price
(4, 1.99),  -- Bread price
(5, 0.99);  -- Tomato price

SELECT i.ItemID, i.IngredientName, e.UseByDate, b.BatchNumber
FROM Inventory i
JOIN ExpectedUseByDate e ON i.ItemID = e.ItemID
JOIN Opened o ON i.ItemID = o.ItemID
JOIN BatchNumber b ON i.ItemID = b.ItemID
WHERE o.IsOpened = true
ORDER BY e.UseByDate DESC;

-- A resturant owner wants to know ingredients with a low quantity so he can restock them. 
-- Write a query to find all ingredients with a quantity less than 3 and return the name and quantity.

SELECT i.IngredientName, a.Quantity
FROM Inventory i
INNER JOIN Amount a ON i.ItemID = a.ItemID
WHERE a.Quantity < 3;

-- The stocking staff want to be able to add ingredients to the database. 
-- Write a helper function that inserts into each database the information about an item.

CREATE SEQUENCE dateofarrival_arrivalid_seq;

CREATE SEQUENCE expectedusebydate_usebyid_seq;

CREATE SEQUENCE batchnumber_batchid_seq;

CREATE SEQUENCE opened_openedid_seq;

CREATE SEQUENCE signedby_signatureid_seq;

CREATE OR REPLACE FUNCTION add_item_to_inventory(
    p_ingredient_id INT,
    p_amount_id INT,
    p_ingredient_name VARCHAR(255),
    p_quantity DECIMAL,
    p_arrival_date DATE,
    p_use_by_date DATE,
    p_batch_number VARCHAR(50),
    p_is_opened BOOLEAN,
    p_signee_name VARCHAR(100)
)
RETURNS VOID AS
$$
DECLARE
    item_id INT;
BEGIN
    -- Insert into Inventory table
    INSERT INTO Inventory (ItemID, IngredientName)
    VALUES (p_ingredient_id, p_ingredient_name)
    RETURNING ItemID INTO item_id;

    -- Insert into Amount table
    INSERT INTO Amount (AmountID, ItemID, Quantity)
    VALUES (p_amount_id, p_ingredient_id, p_quantity);

    -- Insert into DateOfArrival table
    INSERT INTO DateOfArrival (ArrivalID, ItemID, ArrivalDate)
    VALUES (nextval('dateofarrival_arrivalid_seq'), p_ingredient_id, p_arrival_date);

    -- Insert into ExpectedUseByDate table
    INSERT INTO ExpectedUseByDate (UseByID, ItemID, UseByDate)
    VALUES (nextval('expectedusebydate_usebyid_seq'), p_ingredient_id, p_use_by_date);

    -- Insert into BatchNumber table
    INSERT INTO BatchNumber (BatchID, ItemID, BatchNumber)
    VALUES (nextval('batchnumber_batchid_seq'), p_ingredient_id, p_batch_number);

    -- Insert into Opened table
    INSERT INTO Opened (OpenedID, ItemID, IsOpened)
    VALUES (nextval('opened_openedid_seq'), p_ingredient_id, p_is_opened);

    -- Insert into SignedBy table
    INSERT INTO SignedBy (SignatureID, ItemID, SigneeName)
    VALUES (nextval('signedby_signatureid_seq'), p_ingredient_id, p_signee_name);

END;
$$

LANGUAGE plpgsql;

SELECT add_item_to_inventory(
    '11243',
    '11355',
    'Chicken',
    10.0,
    '2024-03-15',
    '2024-03-25',
    'E12345',
    FALSE,
    'Jack Dude'
);

-- A resturant owner wants to know what ingredients are expired. 
-- Write a query to return all ingredient names that have an expired UseByDate

SELECT IngredientName
FROM Inventory
WHERE ItemID IN (
    SELECT ItemID
    FROM ExpectedUseByDate
    WHERE UseByDate >= CURRENT_DATE
);

-- A resturant owner wants to know how many ingredients are used each month ordered greatest to least. 
-- Write a query that gets the quantity of ingredients purchased per month in the past year and return the month, year, and quantity ordered by quantity descending.

SELECT 
    EXTRACT(MONTH FROM doa.ArrivalDate) AS month,
    EXTRACT(YEAR FROM doa.ArrivalDate) AS year,
    SUM(amt.Quantity) AS TotalQuantity
FROM 
    DateOfArrival doa
JOIN 
    Amount amt ON doa.ItemID = amt.ItemID
WHERE 
    doa.ArrivalDate >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 
    EXTRACT(MONTH FROM doa.ArrivalDate), EXTRACT(YEAR FROM doa.ArrivalDate)
ORDER BY 
    TotalQuantity
DESC;