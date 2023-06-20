SELECT
  *
FROM
  sql-project-14194.dataanalyst.salary;


-- 1. Apakah ada data yang NULL?

SELECT
  *
FROM
  sql-project-14194.dataanalyst.salary
WHERE
  work_year IS NULL
  OR experience_level IS NULL
  OR employment_type IS NULL
  OR job_title IS NULL
  OR salary IS NULL
  OR salary_currency IS NULL
  OR salary_in_usd IS NULL
  OR employee_residence IS NULL
  OR remote_ratio IS NULL
  OR company_location IS NULL
  OR company_size IS NULL;


-- 2. Melihat ada job title apa saja

SELECT
	DISTINCT job_title
FROM
  sql-project-14194.dataanalyst.salary
ORDER BY
	job_title;


-- 3. Job title apa saja yang berkaitan dengan data analyst

SELECT
	DISTINCT job_title
FROM
	sql-project-14194.dataanalyst.salary
WHERE
	CONTAINS_SUBSTR((job_title), 'data analyst')
ORDER BY
	job_title;


-- 4. Berapa rata-rata gaji data analyst?

SELECT
	AVG(salary_in_usd) AS avg_salary_in_usd
FROM
	sql-project-14194.dataanalyst.salary
WHERE
	CONTAINS_SUBSTR((job_title), 'data analyst');


-- 4.1 Berapa rata-rata gaji data analyst berdasarkan experience levelnya?

SELECT
	experience_level,
	(AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM
	sql-project-14194.dataanalyst.salary
WHERE
	CONTAINS_SUBSTR((job_title), 'data analyst')
GROUP BY
	experience_level;


-- 4.2 Berapa rata-rata gaji data analyst berdasarkan experience level dan jenis employment?

SELECT
	experience_level,
	employment_type,
	(AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM
	sql-project-14194.dataanalyst.salary
WHERE
	CONTAINS_SUBSTR((job_title), 'data analyst')
GROUP BY
	experience_level,
	employment_type
ORDER BY
	experience_level,
	employment_type;


-- 5. Negara dengan gaji yang menarik untuk posisi data analyst, full time, exp kerjanya entry level dan menengah / mid
SELECT
	company_location,
	AVG(salary_in_usd) avg_sal_in_usd
FROM
	sql-project-14194.dataanalyst.salary
WHERE
	CONTAINS_SUBSTR((job_title), 'data analyst')
	AND employment_type = 'FT'
	AND experience_level IN ('MI', 'EN')
GROUP BY
	company_location
HAVING
	avg_sal_in_usd >= 20000;


-- 6. Di tahun berapa, kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi? 
-- (untuk pekerjaan yang berkaitan dengan data analyst yang penuh waktu
WITH ds_1 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_ex
	FROM
		sql-project-14194.dataanalyst.salary
	WHERE
		employment_type = 'FT'
		AND experience_level = 'EX'
		AND CONTAINS_SUBSTR((job_title), 'data analyst')
	GROUP BY
		work_year
),
ds_2 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_mi
	FROM
		sql-project-14194.dataanalyst.salary
	WHERE
		employment_type = 'FT'
		AND experience_level = 'MI'
		AND CONTAINS_SUBSTR((job_title), 'data analyst')
	GROUP BY
		work_year
),
t_year AS (
	SELECT
		DISTINCT work_year
	FROM
		sql-project-14194.dataanalyst.salary
)
SELECT
	t_year.work_year,
	ds_1.sal_in_usd_ex,
	ds_2.sal_in_usd_mi,
	ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi differences
FROM
	t_year
	LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
	LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;