-- Exploratory Data Analysis

SELECT * FROM layoffs_staging2;

UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL'

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'NULL'

SELECT
	MAX(total_laid_off) max_no
FROM layoffs_staging2

SELECT
	MAX(CAST(total_laid_off AS INT)) max_no
FROM layoffs_staging2

ALTER TABLE layoffs_staging2
ALTER COLUMN total_laid_off INT;

SELECT
	company,
	MAX(total_laid_off) max_no
FROM layoffs_staging2
GROUP BY company
ORDER BY MAX(total_laid_off) DESC

SELECT
	company,
	SUM(total_laid_off) Total_no
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT
	MIN([date]) OldestDate, MAX([date]) LatestDate
FROM layoffs_staging2

SELECT
	country,
	SUM(total_laid_off) Total_no
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT
	YEAR([date]) year,
	SUM(total_laid_off) Total_no
FROM layoffs_staging2
GROUP BY YEAR([date])
ORDER BY 2 DESC;

SELECT
	stage,
	SUM(total_laid_off) Total_no
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling Total of Layoffs Per Month

SELECT
	*
FROM layoffs_staging2

WITH Rolling_Total AS
(
SELECT
	LEFT([date],7) Dates,
	SUM(total_laid_off) AS Total_laidoffs
FROM layoffs_staging2
GROUP BY LEFT([date],7)
)
SELECT
	Dates,
	Total_laidoffs,
	SUM(Total_laidoffs) OVER(ORDER BY Dates) AS Rolling_total
FROM Rolling_Total
/******************************************************/
-- Top 5 companies with the highest Laid off by years

WITH company_year AS
(
SELECT 
	company,
	YEAR([date]) years,
	SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR([date])
)
,company_year_rank AS
( 
SELECT
	*,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY Total_laid_off DESC) AS Ranking
FROM company_year
WHERE Total_laid_off IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE Ranking <= 5;
