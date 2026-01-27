# Emergence-Data-analyst-assessment

# Overview of the Analysis
This analysis examines the Subscription and Event data to measure business health via key SaaS metrics:
* Monthly MRR
* Annual Recurring Revenue (ARR)
* Customer Churn Rate (Monthly)
* Revenue Churn Rate (Monthly)
* Average Revenue per Customer (ARPC)
* Funnel & Source Performance
I computed month-by-month snapshots of recurring revenue and customer behavior to assess growth and retention.

# Tools Used

* Google Colab notebook (Python)
* SQLlite (SQL Queries)
* Tableau (Visualization)

# Data Issues Identified

* Duplicate records in events and subscriptions table.
* Missing segment data in customer table for customers who have churned.

# Metric Definitions

* Monthly MRR : Counts raw recurring revenue from active subscriptions.
  MRR = ∑ (monthly subscription fees from active users)
* Annual Recurring Revenue (ARR) : Gives you a yearly revenue forecast, assuming current monthly revenue recurs uniformly.
  ARR = MRR × 12
* Customer Churn Rate (Monthly) : This calculates churn as the proportion of customers lost relative to those active at the start of the period.
  Customer Churn = Customers Lost / Customers at Start​ × 100%
* Revenue Churn Rate (Monthly) : This measures the value lost relative to total recurring revenue.
  Revenue Churn = MRR Lost​ / MRR at Start × 100%
* Average Revenue per Customer (ARPC) : Shows how much revenue each active customer generates on average in that period.
  ARPC = MRR / (number of active customers in that month)

# Key Insights
