-- =========================================
-- 修正口径：活动开放日 → 玩家完成时刻
-- 先算每个玩家的日均，再取玩家维度平均值
-- 每个查询同时返回体力和宝石
-- =========================================

-- ① 艾瑞克小车竞速 CoinRacing 6/12-6/15, step>=10
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-12' AND DATE '2026-06-15'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'CoinRacing'
    AND CAST("activity_step_id" AS BIGINT) >= 10
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-12' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-12' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '小车竞速(10轮通关)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ② 杰西卡开车探险 RoadTrip 6/19-6/22, step>=37
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-19' AND DATE '2026-06-22'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'RoadTrip'
    AND CAST("activity_step_id" AS BIGINT) >= 37
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-19' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-19' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '开车探险(37节点通关)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ③ 杰西卡金币募集 CoinCollection 6/26-6/29, step>=10 (10关通关)
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-26' AND DATE '2026-06-29'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'CoinCollection'
    AND CAST("activity_step_id" AS BIGINT) >= 10
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-26' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-26' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '金币募集(10关通关)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ④ 杰西卡金币募集 隐藏关 CoinCollection 6/26-6/29, step>=11
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-26' AND DATE '2026-06-29'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'CoinCollection'
    AND CAST("activity_step_id" AS BIGINT) >= 11
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-26' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-26' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '金币募集(隐藏11关)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ⑤ 露娜玩具拼图 PuzzleToy 6/8-6/12, step>=5 (第5阶段=25块进阶)
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-08' AND DATE '2026-06-12'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'PuzzleToy'
    AND CAST("activity_step_id" AS BIGINT) >= 5
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-08' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-08' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '玩具拼图(25块进阶)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ⑥ 山姆水塘钓鱼 TreasureHunt 6/15-6/19, step>=10 (普通10关通关)
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-15' AND DATE '2026-06-19'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'TreasureHunt'
    AND CAST("activity_step_id" AS BIGINT) >= 10
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-15' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-15' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '水塘钓鱼(普通10关)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ⑦ 凯的食品券兑换 FoodCollection 6/22-6/26, step>=13 (循环档)
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-22' AND DATE '2026-06-26'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'FoodCollection'
    AND CAST("activity_step_id" AS BIGINT) >= 13
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-22' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-22' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '食品券兑换(循环档)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;


-- ⑧ 凯的食品券兑换 FoodCollection 6/22-6/26, step>=12 (12档全通)
WITH completion AS (
  SELECT "#account_id", CAST(MIN("#event_time") AS DATE) AS cd
  FROM ta.v_event_36
  WHERE "$part_date" BETWEEN DATE '2026-06-22' AND DATE '2026-06-26'
    AND "#event_name" = 'ACTIVITY'
    AND CAST("activity_type" AS VARCHAR) = 'FoodCollection'
    AND CAST("activity_step_id" AS BIGINT) >= 12
    AND "common_debug" = false
  GROUP BY "#account_id"
),
daily_energy AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-22' AND c.cd
    AND e."#event_name" = 'ENERGY_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
daily_gem AS (
  SELECT e."#account_id", e."$part_date" AS dt, SUM(e."num") AS val
  FROM ta.v_event_36 e
  INNER JOIN completion c ON e."#account_id" = c."#account_id"
  WHERE e."$part_date" BETWEEN DATE '2026-06-22' AND c.cd
    AND e."#event_name" = 'DIAMOND_CHANGE_USE' AND e."common_debug" = false
  GROUP BY e."#account_id", e."$part_date"
),
pa_energy AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_e
  FROM daily_energy GROUP BY "#account_id"
),
pa_gem AS (
  SELECT "#account_id", ROUND(CAST(SUM(val) AS DOUBLE) / COUNT(DISTINCT dt), 2) AS avg_g
  FROM daily_gem GROUP BY "#account_id"
)
SELECT '食品券兑换(12档全通)' AS 活动,
       (SELECT COUNT(*) FROM pa_energy) AS 人数,
       (SELECT ROUND(AVG(avg_e), 2) FROM pa_energy) AS 日均体力,
       (SELECT ROUND(AVG(avg_g), 2) FROM pa_gem) AS 日均宝石;
