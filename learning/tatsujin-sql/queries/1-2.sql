-- 必ずわかるウィンドウ関数
-- ウィンドウとは何か {{{
-- 無名ウィンドウ構文
SELECT shohin_id, shohin_mei, hanbai_tanka,
AVG(hanbai_tanka) OVER (ORDER BY shohin_id
					ROWS BETWEEN 2 PRECEDING
							AND CURRENT ROW) AS moving_avg
FROM 'Shohin.csv';

-- named window
SELECT shohin_id, shohin_mei, hanbai_tanka,
AVG(hanbai_tanka) OVER W AS moving_avg
FROM 'Shohin.csv'
WINDOW W AS (ORDER BY shohin_id
					ROWS BETWEEN 2 PRECEDING
							AND CURRENT ROW);

SELECT shohin_id, shohin_mei, hanbai_tanka,
AVG(hanbai_tanka) OVER W AS moving_avg,
SUM(hanbai_tanka) OVER W AS moving_sum,
COUNT(hanbai_tanka) OVER W AS moving_count,
MAX(hanbai_tanka) OVER W AS moving_max,
FROM 'Shohin.csv'
WINDOW W AS (ORDER BY shohin_id
					ROWS BETWEEN 2 PRECEDING
							AND CURRENT ROW);
-- }}}

-- フレーム句を使って違う行を自分の行に持ってくる {{{
SELECT sample_date AS cur_date,
	MIN(sample_date)
		OVER (ORDER BY sample_date ASC
			  ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS latest_date,
FROM 'LoadSample.csv';

SELECT sample_date AS cur_date,
	load_val AS cur_load,
	MIN(sample_date) OVER W AS latest_date,
	MIN(load_val) OVER W AS latest_load,
FROM 'LoadSample.csv'
WINDOW W AS (ORDER BY sample_date ASC
				ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING);

-- FOLLOWING
SELECT sample_date AS cur_date,
	load_val AS cur_load,
	MIN(sample_date) OVER W AS next_date,
	MIN(load_val) OVER W AS next_load,
FROM 'LoadSample.csv'
WINDOW W AS (ORDER BY sample_date ASC
				ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING);

-- これでも結果はMINと同じ
SELECT sample_date AS cur_date,
	load_val AS cur_load,
	MAX(sample_date) OVER W AS latest_date,
	MAX(load_val) OVER W AS latest_load,
FROM 'LoadSample.csv'
WINDOW W AS (ORDER BY sample_date ASC
				ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING);

-- 列の値に基づいたフレーム
SELECT sample_date AS cur_date,
	load_val AS cur_load,
	MIN(sample_date) OVER W AS day1_before,
	MIN(load_val) OVER W AS load_day1_before,
FROM 'LoadSample.csv'
WINDOW W AS (ORDER BY sample_date ASC
				RANGE BETWEEN interval '1' day PRECEDING
							AND interval '1' day PRECEDING);

-- UNBOUNDED
SELECT sample_date AS cur_date,
	load_val AS cur_load,
	MIN(sample_date) OVER W AS future_date,
	MIN(load_val) OVER W AS future_load,
FROM 'LoadSample.csv'
WINDOW W AS (ORDER BY sample_date ASC
				ROWS BETWEEN UNBOUNDED FOLLOWING AND UNBOUNDED FOLLOWING);
-- Parser Error:
-- frame start cannot be UNBOUNDED FOLLOWING

-- UNBOUNDED
SELECT sample_date AS cur_date,
	load_val AS cur_load,
	MIN(sample_date) OVER W AS latest_date,
	MIN(load_val) OVER W AS future_min_load,
FROM 'LoadSample.csv'
WINDOW W AS (ORDER BY sample_date ASC
				ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING);

-- 行間比較の一般化
SELECT sample_date AS cur_date,
	MIN(sample_date)
		OVER (ORDER BY sample_date ASC
			ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS latest_1,
	MIN(sample_date)
		OVER (ORDER BY sample_date ASC
			ROWS BETWEEN 2 PRECEDING AND 2 PRECEDING) AS latest_2,
	MIN(sample_date)
		OVER (ORDER BY sample_date ASC
			ROWS BETWEEN 3 PRECEDING AND 3 PRECEDING) AS latest_3,
FROM 'LoadSample.csv';
-- }}}

-- ウィンドウ関数の内部動作 {{{
EXPLAIN SELECT shohin_id, shohin_mei, hanbai_tanka,
AVG(hanbai_tanka) OVER (ORDER BY shohin_id
					ROWS BETWEEN 2 PRECEDING
							AND CURRENT ROW) AS moving_avg
FROM 'Shohin.csv';
-- }}}
