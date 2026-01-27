-- Obtain each customer that signed up
WITH
base AS (
  SELECT customer_id, source
  FROM events_final
  WHERE event_type = 'signup'
),
-- Obtain customers' first signup
signup AS (
  SELECT customer_id, MIN(event_date) AS signup_date
  FROM events_final
  WHERE event_type = 'signup'
  GROUP BY customer_id
),
-- Obtain customers that started the trial
trial AS (
  SELECT customer_id, MIN(event_date) AS trial_date
  FROM events_final
  WHERE event_type = 'trial_start'
  GROUP BY customer_id
),
-- Obtain customers that activated their subscription
activated AS (
  SELECT customer_id, MIN(event_date) AS activated_date
  FROM events_final
  WHERE event_type = 'activated'
  GROUP BY customer_id
),
-- Obtain customers that churned
churned AS (
  SELECT customer_id, MIN(event_date) AS churn_date
  FROM events_final
  WHERE event_type = 'churned'
  GROUP BY customer_id
)
SELECT
  b.source,
  COUNT(DISTINCT b.customer_id) AS signup_count,
  SUM(CASE WHEN t.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS trial_count,
  SUM(CASE WHEN a.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS activated_count,
  SUM(CASE WHEN c.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS churned_count

FROM base b
LEFT JOIN trial t USING (customer_id)
LEFT JOIN activated a USING (customer_id)
LEFT JOIN churned c USING (customer_id)
GROUP BY b.source
ORDER BY signup_count DESC;
