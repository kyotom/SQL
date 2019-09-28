With table_tmp AS (
    SELECT
        s.id AS s_id
        , s.event_id
        , e.name
        , s.due_date
        , e.id AS e_id
        --締切日以降、スケジュール未定のイベントのみを表示対象とする。
        , CASE WHEN s.due_date >= (SELECT MAX(sysdate) FROM sysdate_dummy) OR due_date IS NULL THEN 1 ELSE 0 END AS flg_output
    FROM
        events e
    LEFT JOIN
        schedules s
    ON
        e.id = s.event_id
)

SELECT
    id AS event_id
    , name
    , schedule_id
    , due_date
FROM (
    SELECT
        e_id AS  id
        , name
        , s_id AS schedule_id
        , due_date
        --スケジュールが複数あるイベントはシステム日付に最も近い締め切り日を算出する。
        , MIN(due_date) OVER (PARTITION BY e_id) AS min_duedate
    FROM
        table_tmp
    WHERE
        flg_output = 1
) a
WHERE
    (min_duedate = due_date OR min_duedate IS NULL)
--締切日順に並び替える、ただしスケジュール未定であれば一番下に表示する。
--締切日が同じであれば、イベントID順に並び替える。
ORDER BY due_date   NULLS LAST , id
;
