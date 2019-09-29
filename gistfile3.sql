
--入会日と退会日を合わせた日付一覧テーブルを作成
With date_table AS (
	SELECT
		DISTINCT(joined_on) AS date
	FROM
		users
	--日付が重複させないために、UNION ALLではなくUNIONを用いる。
	UNION
	SELECT
		DISTINCT(left_on) AS date
	FROM
		users
	WHERE
		left_on IS NOT NULL
)



select
	*
	--相関サブクエリを使い、日付毎の入会者数と退会者数を算出する。
	, (SELECT COUNT(joined_on) FROM users u where d1.date = u.joined_on) AS joined_count
	, (SELECT COUNT(left_on) FROM users u where d1.date = u.left_on) AS left_count
	--left_onにNULLがあると、日付比較がうまくいかない。
	--そこでleft_onにNULLが格納されている場合には、3000-01-01という仮の先日付でもって日付計算させる。
	, (SELECT COUNT(*) FROM users u where d1.date >= u.joined_on AND d1.date < COALESCE(left_on,'3000-01-01'::date)) AS users_count
from
	date_table  d1
ORDER BY date
