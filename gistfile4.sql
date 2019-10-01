

With latest_employee_list AS (
    SELECT
        *
    FROM (
        SELECT
            *
            --従業員毎の最新の開始日を出力する
            , MAX(start_date) over (PARTITION BY employee_id) AS employee_latest_date
        FROM
            section_histories
    ) a
    WHERE
        --最新の開始日でない行は削除
        --最新の所属履歴を出力する。
        start_date = employee_latest_date
        --現在、IT部門に所属している社員を出力する。
        AND section_name = 'IT'
)


SELECT
    employee_id
    , name
    , section_name
    , start_date
FROM
    latest_employee_list
INNER JOIN
    employees
ON
    latest_employee_list.employee_id = employees.id
ORDER BY employee_id
