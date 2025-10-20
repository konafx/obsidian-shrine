-- 年齢が20歳か、20歳でない生徒を選択せよ
SELECT *
FROM 'Students.csv'
WHERE age = 20 OR age != 20;

-- 第三の条件を追加：「年齢が20歳か、20歳でないか、または年齢がわからない」
SELECT *
FROM 'Students.csv'
WHERE age = 20 OR age != 20
OR age IS NULL;

-- Bクラスの東京在住の生徒と年齢が一致しないAクラスの生徒を選択するSQL？
SELECT *
FROM 'Class_A.csv'
WHERE age NOT IN (
	SELECT age
	FROM 'Class_B.csv'
	WHERE city = '東京'
);

-- 正しいSQL：ラリーとボギーが選択される
SELECT *
FROM 'Class_A.csv' A
WHERE NOT EXISTS (
	SELECT age
	FROM 'Class_B.csv' B
	WHERE A.age = B.age
	AND B.city = '東京'
);
