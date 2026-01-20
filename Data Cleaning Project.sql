-- Data Cleaning 

SELECT *
	INTO layoffs_staging
	FROM layoffs

SELECT 
	*
FROM layoffs_staging

WITH CTE_Duplicates AS
(
SELECT 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
	percentage_laid_off, date, stage, country, funds_raised_millions ORDER BY date) ID,
	*
FROM layoffs_staging
)
DELETE FROM CTE_Duplicates
WHERE ID > 1

SELECT * FROM layoffs_staging
WHERE company = 'Casper'


SELECT * FROM layoffs_staging2

INSERT INTO layoffs_staging2
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
		percentage_laid_off, date, stage, country, funds_raised_millions ORDER BY date) ID,
		*
	FROM layoffs_staging

/********************************************************/

-- Data Stardardizing 

SELECT
	LEN(company), LEN(TRIM(company))
FROM layoffs_staging2

UPDATE layoffs_staging2
SET company = TRIM(company)

SELECT industry FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'  
WHERE industry LIKE 'Crypto%'

SELECT industry FROM layoffs_staging2
WHERE industry LIKE 'Cryp%'

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country = 'United States' 

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%'

SELECT 
    FORMAT(CAST([date] AS DATE), 'yyyy/MM/dd') AS formatted_date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET [date] = TRY_CONVERT(DATE, [date], 111)

SELECT * FROM layoffs_staging2

UPDATE s
SET s.[date] = TRY_CONVERT(DATE, b.[date], 101)
FROM layoffs_staging2 s
JOIN layoffs_staging b
    ON s.company = b.company;

SELECT *, COUNT(*) OVER() FROM layoffs_staging2
WHERE [date] IS NULL

UPDATE layoffs_staging2
SET [date] = GETDATE()
WHERE [date] IS NULL

ALTER TABLE layoffs_staging2
ALTER COLUMN [date] DATE;

SELECT *, COUNT(*) OVER() FROM layoffs_staging2
WHERE [date] IS NULL

SELECT *
FROM layoffs_staging2
ORDER BY industry
WHERE industry IS NULL industry = ''

SELECT *, LEN(industry)
FROM layoffs_staging2
WHERE company = 'Airbnb'

UPDATE a
SET a.industry = b.industry
FROM layoffs_staging2 a
JOIN layoffs_staging2 b
    ON a.company = b.company
	AND a.location = b.location
WHERE a.industry IS NULL
AND b.industry IS NOT NULL

SELECT * FROM layoffs_staging2
WHERE company LIKE 'ca%' 

SELECT * FROM layoffs_staging2 a
JOIN layoffs_staging2 b
	ON a.company = b.company
WHERE a.industry = '' AND b.industry IS NOT NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = 'NULL'
AND percentage_laid_Off = 'NULL'

DELETE FROM layoffs_staging2
WHERE total_laid_off = 'NULL'
AND percentage_laid_Off = 'NULL'
  
ALTER TABLE layoffs_staging2
DROP COLUMN ID;

 SELECT * FROM layoffs_staging2

