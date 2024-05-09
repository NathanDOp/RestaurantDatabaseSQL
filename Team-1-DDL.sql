---Team 1 Table Creation - Nathan D'Agostino

---Main Table for the Inventory, tracks ingredients.
CREATE TABLE Inventory (
    ItemID INT PRIMARY KEY,
    IngredientName VARCHAR(255) NOT NULL
);

---Table tracks dates of arrival to know when the product was delivered.
CREATE TABLE DateOfArrival (
    ArrivalID INT PRIMARY KEY,
    ItemID INT NOT NULL,
    ArrivalDate DATE NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

---This is the expiration date, to make sure it is known when the item will go bad.
CREATE TABLE ExpectedUseByDate (
    UseByID INT PRIMARY KEY,
    ItemID INT NOT NULL,
    UseByDate DATE NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

---Table tracks the amount of said item within the inventory.
CREATE TABLE Amount (
    AmountID INT PRIMARY KEY,
    ItemID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

---A special ID created to know which shipment it was from to avoid combining of items.
CREATE TABLE BatchNumber (
    BatchID INT PRIMARY KEY,
    ItemID INT NOT NULL,
    BatchNumber VARCHAR(50) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

---To know if the item is opened, so it can be prioritized.
CREATE TABLE Opened (
    OpenedID INT PRIMARY KEY,
    ItemID INT NOT NULL,
    IsOpened BOOLEAN NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

---Table tracks which employee signed off on the shipment, ensuring quality and fresh ingredients, if any questions arise.
CREATE TABLE SignedBy (
    SignatureID INT PRIMARY KEY,
    ItemID INT NOT NULL,
    SigneeName VARCHAR(100) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);
