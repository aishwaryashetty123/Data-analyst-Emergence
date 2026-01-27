WITH 
-- Obtain source for each customer that signed up
base AS (
  SELECT customer_id, source
  FROM events_final
  WHERE event_type = 'signup'
),
-- Obtain customers that signed up
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
),
-- Obtain total number of signups, trials, activations and churns
counts AS (
  SELECT
  b.source,
    COUNT(DISTINCT s.customer_id) AS signups,
    SUM(CASE WHEN t.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS trials,
    SUM(CASE WHEN a.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS activations,
    SUM(CASE WHEN c.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS churn
  FROM base b
  LEFT JOIN signup s USING (customer_id)
  LEFT JOIN trial t USING (customer_id)
  LEFT JOIN activated a USING (customer_id)
  LEFT JOIN churned c USING (customer_id)
  GROUP BY b.source
)

SELECT
source,
  (trials*1.0) / NULLIF(signups,0)       AS signup_to_trial_rate,
  (activations*1.0) / NULLIF(trials,0)   AS trial_to_activation_rate,
  (churn*1.0) / NULLIF(activations,0)     AS activation_to_churn_rate
FROM counts
ORDER BY signup_to_trial_rate DESC;
