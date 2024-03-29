-- using SQL Server syntax
-- question 1

SELECT 
	r.ACCT_NUM,
	r.PRODUCT,
	CASE
		WHEN r.PRODUCT = 'VEG' THEN 'Vegetable'
		WHEN r.PRODUCT = 'HOT DOG' THEN 'Hot Dog'	
		WHEN r.PRODUCT = 'COOKIE' THEN 'Cookie'
		ELSE 'other' END as PROD2,
	r.MONTH,
	r.REVENUE

FROM FINANCE.REVENUE as r

-- question 2

SELECT 
	r.ACCT_NUM,
	r.PRODUCT,
	r.MONTH,
	r.REVENUE

FROM FINANCE.REVENUE

WHERE r.ACCT_NUM = 9994523 and r.MONTH = "Feb"

-- question 3

SELECT
	r.ACCT_NUM,
	r.PRODUCT,
	ag.GENDER,
	r.MONTH,
	r.REVENUE	

FROM FINANCE.REVENUE as r
	LEFT OUTER JOIN FINANACE.ACCOUNT_GENDER as ag on r.ACCT_NUM = ag.ACCT_NUM

-- question 4

WITH REVENUE_CTE as (

	SELECT 
		r1.MONTH,
		r1.ACCT_NUM,
		r1.PRODUCT,
		r1.REVENUE

	FROM FINANCE.REVENUE as r1

	UNION ALL

	SELECT
		r2.MONTH,
		r2.ACCT_NUM,
		r2.PRODUCT,
		r2.REVENUE

	FROM FINANCE.REVENUE as r2


)

SELECT 
	ACCT_NUM,
	SUM(REVENUE) as REVENUE_TOTAL

	FROM REVENUE_CTE

	GROUP BY ACCT_NUM

-- question 5

SELECT
	wl.MONTH,
	wl.LOCATION,
	count(distinct ACCT_NUM) as UNIQUE_VIEWERS

FROM FINANCE.WIFI-LOGIN

GROUP BY wl.MONTH, wl.LOCATION

-- question 6

SELECT 
	r.ACCT_NUM,
	r.PRODUCT,
	r.Date_local,
	r.CURRENTDAY,
	LAG(r.CURRENTDAY, 1, NULL) OVER (ORDER BY Date_local) as PREVIOUSDAY,
	LEAD(r.CURRENTDAY, 1, NULL) OVER (ORDER BY Date_local) as NEXTDAY

FROM FINANCE.REVENUE01 as r

-- question 7

SELECT
	r.ACCT_NUM,
	EOMONTH(r.DATE) as MONTH_END,
	r.REVENUE,
	ROW_NUMBER() OVER (PARTITION BY EOMONTH(r.DATE) ORDER BY r.REVENUE) as Rank

FROM FINANCE.REVENUE01 as r

WHERE ROW_NUMBER() OVER (PARTITION BY EOMONTH(r.DATE) ORDER BY r.REVENUE) IN (1, 2, 3)

-- question 8

SELECT
	a.ACCT_NUM,
	a.CALL_DATE,
	CASE
		WHEN m.PURCHASE_DATE IS NOT NULL THEN 'Y'
		ELSE 'N' END as PRIOR_MONTH_PURCHASE

FROM SERVICE.CALLS_APR as a
	LEFT OUTER JOIN FINANCE.PURCHASES_MAR as m on a.ACCT_NUM = m.ACCT_NUM