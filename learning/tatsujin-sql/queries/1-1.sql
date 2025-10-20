-- 既存のコード体系を新しい体系に変換して集計する {{{
-- 県名を地方名に再分類する
SELECT CASE pref_name
	WHEN '徳島' THEN '四国'
	WHEN '香川' THEN '四国'
	WHEN '愛媛' THEN '四国'
	WHEN '高知' THEN '四国'
	WHEN '福岡' THEN '九州'
	WHEN '佐賀' THEN '九州'
	WHEN '長崎' THEN '九州'
ELSE 'その他' END AS district,
SUM(population)
FROM 'PopTbl.csv'
GROUP BY CASE pref_name
	WHEN '徳島' THEN '四国'
	WHEN '香川' THEN '四国'
	WHEN '愛媛' THEN '四国'
	WHEN '高知' THEN '四国'
	WHEN '福岡' THEN '九州'
	WHEN '佐賀' THEN '九州'
	WHEN '長崎' THEN '九州'
ELSE 'その他' END;

-- 人口階級ごとに都道府県を分類する
SELECT CASE WHEN population < 100 THEN '01'
	WHEN population >= 100 AND population < 200 THEN '02'
	WHEN population >= 200 AND population < 300 THEN '03'
	WHEN population >= 300 THEN '04'
	ELSE NULL END AS pop_class,
		COUNT(*) AS cnt
FROM 'PopTbl.csv'
GROUP BY CASE WHEN population < 100 THEN '01'
	WHEN population >= 100 AND population < 200 THEN '02'
	WHEN population >= 200 AND population < 300 THEN '03'
	WHEN population >= 300 THEN '04'
	ELSE NULL END
ORDER BY pop_class;

-- 地方単位にコードを再分類する その2:Case式を一か所にまとめる
SELECT CASE pref_name
	WHEN '徳島' THEN '四国'
	WHEN '香川' THEN '四国'
	WHEN '愛媛' THEN '四国'
	WHEN '高知' THEN '四国'
	WHEN '福岡' THEN '九州'
	WHEN '佐賀' THEN '九州'
	WHEN '長崎' THEN '九州'
ELSE 'その他' END AS district,
SUM(population)
FROM 'PopTbl.csv'
GROUP BY district;
-- }}}

-- 異なる条件の集計を1つのSQLで行う {{{
-- 男性の人口
SELECT
	pref_name,
	population
FROM 'PopTbl2.csv'
WHERE sex = '1';

-- 女性の人口
SELECT
	pref_name,
	population
FROM 'PopTbl2.csv'
WHERE sex = '2';

SELECT
	pref_name,
	-- 男性の人口
	SUM( CASE WHEN sex = '1' THEN population ELSE 0 END) AS cnt_m,
	-- 女性の人口
	SUM( CASE WHEN sex = '2' THEN population ELSE 0 END) AS cnt_f,
FROM 'PopTbl2.csv'
GROUP BY pref_name;

SELECT
	pref_name,
	-- 男性の人口
	CASE WHEN sex = '1' THEN population ELSE 0 END AS cnt_m,
	-- 女性の人口
	CASE WHEN sex = '2' THEN population ELSE 0 END AS cnt_f,
FROM 'PopTbl2.csv';

-- }}}

-- 条件を分岐させたUPDATED {{{
-- duckdb
DROP TABLE IF EXISTS Personnel;
CREATE TABLE Personnel AS SELECT * FROM 'Personnel.csv';

-- 条件1
UPDATE Personnel
SET salary = salary * 0.9
WHERE salary >= 300000;

-- 条件2
UPDATE Personnel
SET salary = salary * 1.2
WHERE salary >= 250000 AND salary < 280000;

-- show result (wrong)
SELECT * FROM Personnel;

-- duckdb
DROP TABLE IF EXISTS Personnel;
CREATE TABLE Personnel AS SELECT * FROM 'Personnel.csv';

UPDATE Personnel
SET salary = CASE
	WHEN salary >= 300000 THEN salary * 0.9
	WHEN salary >= 250000 AND salary < 280000 THEN salary * 1.2
	ELSE salary END;

-- show result (correct)
SELECT * FROM Personnel;
-- }}}

-- テーブル同士のマッチング {{{
-- テーブルのマッチング：IN述語の利用
SELECT
	course_name,
	CASE WHEN course_id IN
		(SELECT course_id FROM 'OpenCourses.csv'
			WHERE month = 201806) THEN '🔵'
	ELSE '❌️' END AS '6月',
	CASE WHEN course_id IN
		(SELECT course_id FROM 'OpenCourses.csv'
			WHERE month = 201807) THEN '🔵'
	ELSE '❌️' END AS '7月',
	CASE WHEN course_id IN
		(SELECT course_id FROM 'OpenCourses.csv'
			WHERE month = 201808) THEN '🔵'
	ELSE '❌️' END AS '8月',
FROM 'CourseMaster.csv';

-- テーブルのマッチング：EXISTS述語の利用
SELECT
	CM.course_name,
	CASE WHEN EXISTS
		(SELECT OC.course_id FROM 'OpenCourses.csv' OC
			WHERE OC.month = 201806
			AND OC.course_id = CM.course_id) THEN '🔵'
	ELSE '❌️' END AS '6月',
	CASE WHEN course_id IN
		(SELECT OC.course_id FROM 'OpenCourses.csv' OC
			WHERE OC.month = 201807
			AND OC.course_id = CM.course_id) THEN '🔵'
	ELSE '❌️' END AS '7月',
	CASE WHEN course_id IN
		(SELECT OC.course_id FROM 'OpenCourses.csv' OC
			WHERE OC.month = 201808
			AND OC.course_id = CM.course_id) THEN '🔵'
	ELSE '❌️' END AS '8月',
FROM 'CourseMaster.csv' CM;
-- }}}

--CASE式の中で集約関数を使う {{{
-- 条件1：1つのクラブに専念している学生を選択
SELECT std_id, MAX(club_id) AS main_club
FROM 'StudentClub.csv'
GROUP BY std_id
HAVING COUNT(*) = 1
ORDER BY std_id;

-- 条件2：クラブを掛け持ちしている学生を選択
SELECT std_id, club_id AS main_club
FROM 'StudentClub.csv'
WHERE main_club_flg = 'Y'
ORDER BY std_id;

SELECT
	std_id,
	CASE WHEN COUNT(*) = 1 THEN MAX(club_id)
	ELSE MAX(CASE WHEN main_club_flg = 'Y'
			THEN club_id
		ELSE NULL END) END AS main_club
FROM 'StudentClub.csv'
GROUP BY std_id
ORDER BY std_id;
-- }}}
