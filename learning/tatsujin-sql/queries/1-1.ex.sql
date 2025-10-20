-- 1-1:複数列の最大値
-- x,y
SELECT
	key,
	CASE WHEN x > y THEN x
	ELSE y END AS greatest
FROM 'Greatests.csv';

-- x,y,z
SELECT
	key,
	CASE WHEN x > y THEN
		CASE WHEN x > z THEN x
		ELSE z END
	ELSE CASE WHEN y > z THEN y
		ELSE z END
	END AS greatest
FROM 'Greatests.csv';

-- 1-2:合計と再掲を表頭に出力する行列変換
SELECT
	CASE WHEN PT.sex = 1 THEN '男'
		 WHEN PT.sex = 2 THEN '女'
	ELSE NULL END AS 's',
	SUM(population) AS '全国',
	SUM(CASE WHEN pref_name = '徳島' THEN population
	ELSE NULL END) AS '徳島',
	SUM(CASE WHEN pref_name = '香川' THEN population
	ELSE NULL END) AS '香川',
	SUM(CASE WHEN pref_name = '愛媛' THEN population
	ELSE NULL END) AS '愛媛',
	SUM(CASE WHEN pref_name = '高知' THEN population
	ELSE NULL END) AS '高知',
	SUM(CASE WHEN pref_name IN ('徳島', '香川', '愛媛', '高知') THEN population
	ELSE NULL END) AS '四国',
FROM 'PopTbl2.csv' PT
GROUP BY PT.sex
ORDER BY PT.sex;

-- 1-3:ORDER BYでソート列を作る
SELECT
	key,
	CASE WHEN x > y THEN
		CASE WHEN x > z THEN x
		ELSE z END
	ELSE CASE WHEN y > z THEN y
		ELSE z END
	END AS greatest
FROM 'Greatests.csv'
ORDER BY CASE
	WHEN key = 'A' THEN 2
	WHEN key = 'B' THEN 1
	WHEN key = 'C' THEN 4
	WHEN key = 'D' THEN 3
	ELSE NULL END ASC;
