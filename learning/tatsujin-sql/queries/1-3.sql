-- 自己結合の使い方
-- 重複順列・順列・組み合わせ {{{
-- 重複順列を得るSQL
SELECT P1.name AS name_1, P2.name AS name_2,
FROM 'Products.csv' P1 CROSS JOIN 'Products.csv' P2;

-- 順列を得るSQL
SELECT P1.name AS name_1, P2.name AS name_2,
FROM 'Products.csv' P1 INNER JOIN 'Products.csv' P2
ON P1.name <> P2.name;

-- 組み合わせを得るSQL
SELECT P1.name AS name_1, P2.name AS name_2,
FROM 'Products.csv' P1 INNER JOIN 'Products.csv' P2
ON P1.name > P2.name;

-- 組み合わせを得るSQL：3列への拡張版
SELECT P1.name AS name_1, P2.name AS name_2, P3.name AS name_3,
FROM 'Products.csv' P1
INNER JOIN 'Products.csv' P2
ON P1.name > P2.name
INNER JOIN 'Products.csv' P3
ON P2.name > P3.name;
-- }}}

-- 重複行を削除する {{{
-- 重複行を削除するSQLその1：極値関数の利用
DROP TABLE IF EXISTS Products;
CREATE TABLE Products AS SELECT * FROM 'ProductsDuplicated.csv';

DELETE FROM Products P1
WHERE rowid < ( SELECT MAX(P2.rowid)
				FROM Products P2
				WHERE P1.name = P2.name
				AND P1.price = P2.price );

SELECT * FROM Products;

-- 重複行を削除するSQLその2：非等値結合の利用
DROP TABLE IF EXISTS Products;
CREATE TABLE Products AS SELECT * FROM 'ProductsDuplicated.csv';

DELETE FROM Products P1
WHERE EXISTS ( SELECT *
				FROM Products P2
				WHERE P1.name = P2.name
				AND P1.price = P2.price
				AND P1.rowid < P2.rowid );

SELECT * FROM Products;
-- }}}

-- 部分的に不一致なキーの検索 {{{
-- 同じ家族だけど、住所が違うレコードを検索するSQL
SELECT DISTINCT A1.name, A1.address,
FROM 'Addresses.csv' A1 INNER JOIN 'Addresses.csv' A2
ON A1.family_id = A2.family_id
AND A1.address <> A2.address;

-- }}}
