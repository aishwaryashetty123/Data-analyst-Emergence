# Emergence-Data-analyst-assessment

## Overview of the Analysis
This analysis examines the Subscription and Event data to measure business health via key SaaS metrics:
* Monthly MRR
* Annual Recurring Revenue (ARR)
* Customer Churn Rate (Monthly)
* Revenue Churn Rate (Monthly)
* Average Revenue per Customer (ARPC)
* Funnel & Source Performance
  
I computed month-by-month snapshots of recurring revenue and customer behavior to assess growth and retention.

## Tools Used

* Google Colab notebook (Python)
* SQLlite (SQL Queries)
* Tableau (Visualization)

## Data Issues Identified

* Duplicate records in events and subscriptions table.
* Missing segment data in customer table for customers who have churned.

## Metric Definitions

* __Monthly MRR :__ Counts raw recurring revenue from active subscriptions.
  MRR = ∑ (monthly subscription fees from active users)
* __Annual Recurring Revenue (ARR) :__ Gives you a yearly revenue forecast, assuming current monthly revenue recurs uniformly.
  ARR = MRR × 12
* __Customer Churn Rate (Monthly) :__ This calculates churn as the proportion of customers lost relative to those active at the start of the period.
  Customer Churn = Customers Lost / Customers at Start​ × 100%
* __Revenue Churn Rate (Monthly) :__ This measures the value lost relative to total recurring revenue.
  Revenue Churn = MRR Lost​ / MRR at Start × 100%
* __Average Revenue per Customer (ARPC) :__ Shows how much revenue each active customer generates on average in that period.
  ARPC = MRR / (number of active customers in that month)

## Key Insights

* MRR grew sharply from January through March, indicating strong customer acquisition or expansion early in the cycle. But, there was a huge decline in April.
* April’s churn approaching 50% is a strong red flag. Roughly half of the active customers are being lost monthly.
* Revenue churn mirrors customer churn, but at lower levels initially. This indicates that early churners were lower-value customers.
* All sources (ads, organic, outbound, referral) convert signup to trial at rates around 60–70%. Outbound and organic appear slightly stronger.
* Organic has the highest activation from trial while Ads have the lowest.
* Ads seem to have a high proportion churning whereas organic has the lowest churn among the segments.
* The biggest drop-off in the funnel occurs after trial, at the activation stage. This suggests there could be onboarding friction.

## Dashboard explanation

* The dashboard contains monthly MRR, Customer churn rate and Revenue churn rate on the left with a 'month' filter to select all or some months.
* The bar graphs on the right show the overall funnel analysis by source.

## Assumptions & Limitations

* Active subscriptions are counted if status='active' in the month.
* 'end_date' or 'churned' events reliably indicate cancellations.
* Missing end dates imply ongoing subscriptions.
* All prices in 'monthly_price' field are in the same currency.
* All dates are in the same timezone.

## Instructions to Reproduce Results

* Upload all csv files to Google drive.
* Open a new Google colab notebook and run the 'data_validation.ipynb' file.
* Upload the new tables into SQLlite. Run the sql files 'core_metrics.sql', 'Funnel_analysis.sql' and 'Funnel_analysis_by_source.sql' to obtain the final aggregated results.
* Download the results of sql queries and upload them to Tableau.

