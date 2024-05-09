-- Populate Inventory table
INSERT INTO inventory (ItemID, IngredientName) VALUES
(1, 'Radish'),
(2, 'Pasta'),
(3, 'Ground Beef'),
(4, 'Bread'),
(5, 'Tomato');

-- Populate DateOfArrival table
INSERT INTO dateofarrival (ArrivalID, ItemID, ArrivalDate) VALUES
(712, 1, '2024-02-21'), -- Radish
(721, 2, '2024-02-20'), -- Pasta
(782, 3, '2024-02-19'), -- Ground Beef
(777, 4, '2024-02-18'), -- Bread
(420, 5, '2024-02-17'); -- Tomato

-- Populate ExpectedUseByDate table
INSERT INTO expectedusebydate (UseByID, ItemID, UseByDate) VALUES
(4201, 1, '2024-02-28'), -- Radish
(4202, 2, '2024-02-27'), -- Pasta
(4203, 3, '2024-02-26'), -- Ground Beef
(4204, 4, '2024-02-25'), -- Bread
(4205, 5, '2024-02-24'); -- Tomato

-- Populate Amount table
INSERT INTO amount (AmountID, ItemID, Quantity) VALUES
(5678, 1, 5), -- Radish
(5679, 2, 2), -- Pasta
(5680, 3, 3), -- Ground Beef
(5681, 4, 1), -- Bread
(5682, 5, 4); -- Tomato

-- Populate BatchNumber table
INSERT INTO batchnumber (BatchID, ItemID, BatchNumber) VALUES
(0001, 1, 'RAD223'), -- Radish
(0002, 2, 'PAS742'), -- Pasta
(0003, 3, 'BEEF129'), -- Ground Beef
(0004, 4, 'BRD023'), -- Bread
(0005, 5, 'TMT452'); -- Tomato

-- Populate Opened table
INSERT INTO opened (OpenedID, ItemID, IsOpened) VALUES
(4051, 1, false), -- Radish
(7041, 2, true), -- Pasta
(2031, 3, false), -- Ground Beef
(3021, 4, false), -- Bread
(6011, 5, true); -- Tomato

-- Populate SignedBy table
INSERT INTO signedby (SignatureID, ItemID, SigneeName) VALUES
(050282, 1, 'Craig Booly'), -- Radish
(011702, 2, 'Nathan DAgostino'), -- Pasta
(122202, 3, 'Dixie Wright'), -- Ground Beef
(121701, 4, 'Cadence Bakker'), -- Bread
(042004, 5, 'William Davis'); -- Tomato