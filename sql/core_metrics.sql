-- Calculate core metrics using the tables subscriptions_final and events_final
WITH months AS (
  SELECT DISTINCT
  -- Use DATE_FORMAT(start_date, '%Y-%m-01') for Mysql
  STRFTIME('%Y-%m-01', start_date) AS month
  FROM subscriptions_final
),
active_subs AS (
  SELECT
    m.month,
    s.customer_id,
    s.monthly_price
  FROM months m
  JOIN subscriptions_final s
    -- Use ON s.start_date <= LAST_DAY(m.month) for Mysql
  ON s.start_date <= date(m.month, 'start of month', '+1 month', '-1 day')
   AND (s.end_date IS NULL OR s.end_date >= m.month)
),
-- calculate monthly MRR
mrr_calc AS (
  SELECT
    month,
    SUM(monthly_price) AS mrr
  FROM active_subs
  GROUP BY month
),
-- Active customers at the start of month
active_start AS (
  SELECT
    STRFTIME('%Y-%m-01', m.month) AS month,
    COUNT(DISTINCT s.customer_id) AS active_start_customers
  FROM months m
  JOIN subscriptions_final s
    ON s.start_date < m.month
   AND (s.end_date IS NULL OR s.end_date >= m.month)
  GROUP BY m.month
),
-- calculate customer churn
churned_month AS (
  SELECT
    STRFTIME('%Y-%m-01', ch.event_date) AS month,
    COUNT(DISTINCT ch.customer_id) AS churned_customers
  FROM events_final ch
  WHERE ch.event_type = 'churned'
  GROUP BY month
),
start_mrr AS (
  SELECT
    month,
    SUM(monthly_price) AS mrr_start
  FROM active_subs
  GROUP BY month
),
-- calculate revenue churn
churn_mrr AS (
  SELECT
    STRFTIME('%Y-%m-01', e.event_date) AS month,
    SUM(s.monthly_price) AS lost_mrr
  FROM events_final e
  JOIN subscriptions_final s
    ON e.customer_id = s.customer_id
   AND e.event_type = 'churned'
  GROUP BY month
),
-- Active customers per month
active_customers AS (
  SELECT
    m.month,
    COUNT(DISTINCT s.customer_id) AS num_customers
  FROM months m
  JOIN subscriptions_final s
    ON s.start_date <= date(m.month, 'start of month', '+1 month', '-1 day')
   AND (s.end_date IS NULL OR s.end_date >= m.month)
  GROUP BY m.month
)
SELECT
  a.month,
  b.mrr,
  (b.mrr * 12) AS arr,
  churned_customers,
  active_start_customers,
  (churned_customers * 1.0 / active_start_customers) AS customer_churn_rate,
  lost_mrr,
  mrr_start,
  (lost_mrr * 1.0 / mrr_start) AS revenue_churn_rate,
  num_customers,
  (mrr / num_customers) AS arpc
FROM active_subs a 
LEFT JOIN mrr_calc b
  ON a.month = b.month
LEFT JOIN active_start ac
  ON a.month = ac.month
LEFT JOIN churned_month c
  ON a.month = c.month
LEFT JOIN start_mrr sm
  ON a.month = sm.month
LEFT JOIN churn_mrr cm
  ON a.month = cm.month
LEFT JOIN active_customers an
  ON a.month = an.month
GROUP BY a.month
ORDER BY a.month; 
