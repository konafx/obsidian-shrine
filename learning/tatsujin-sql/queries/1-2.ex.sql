-- 2-1：ウィンドウ関数の結果予想 その1
SELECT server, sample_date,
	SUM(load_val) OVER () AS sum_load
FROM 'ServerLoadSample.csv';
-- 予想：row, range指定していないが、overするだけなので全部の合計値？

-- 2-2：ウィンドウ関数の結果予想 その2
SELECT server, sample_date,
	SUM(load_val) OVER (PARTITION BY server) AS sum_load
FROM 'ServerLoadSample.csv';
-- 予想：サーバーごとのload_val合計値
