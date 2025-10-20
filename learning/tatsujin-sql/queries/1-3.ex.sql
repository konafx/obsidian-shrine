-- 3-1：重複組合せ
SELECT P1.name AS name_1, P2.name AS name_2,
FROM 'Products.csv' P1 INNER JOIN 'Products.csv' P2
ON P1.name >= P2.name;

-- 3-2：ウィンドウ関数で重複削除
DROP TABLE IF EXISTS Products_NoRedundant;

CREATE TABLE Products_NoRedundant
AS
SELECT ROW_NUMBER() OVER (PARTITION BY name, price ORDER BY name) AS row_num,
	name,
	price,
FROM 'ProductsDuplicated.csv';

DELETE FROM Products_NoRedundant
WHERE row_num > 1;

SELECT * FROM Products_NoRedundant;
