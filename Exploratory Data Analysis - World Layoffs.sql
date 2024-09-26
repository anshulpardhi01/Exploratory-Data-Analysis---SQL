SELECT *
FROM layoffs_staging2;


-- Some Statistics 
SELECT MIN(total_laid_off), MAX(total_laid_off), AVG(total_laid_off)
FROM layoffs_staging2;

SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;


-- Full Company Laid Off
SELECT company, industry, total_laid_off, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Company Level
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Industry Level
SELECT industry, SUM(total_laid_off) TotalLaidOff
FROM layoffs_staging2
GROUP BY industry
ORDER BY totallaidoff DESC;

-- Country Level 
SELECT country, SUM(total_laid_off) TotalLaidOff
FROM layoffs_staging2
GROUP BY country
ORDER BY TotalLaidOff DESC;

-- Year Level
SELECT YEAR(`date`) , SUM(total_laid_off) TotalLaidOff
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Rolling Sum 
SELECT  SUBSTRING(`date`, 1,7) as `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;

WITH rolling_total as 
(
	SELECT  SUBSTRING(`date`, 1,7) as `Month`, SUM(total_laid_off) total_off
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
	GROUP BY `Month`
	ORDER BY 1
)

SELECT `Month`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS roll_total
FROM rolling_total ;

-- Year Wise Laid off

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 1;

WITH Company_Year (company, years, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
	ORDER BY 1
),
Company_Year_Rank as 
(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS rank_num
	FROM Company_Year
	WHERE years IS NOT NULL

)

SELECT *
FROM Company_Year_Rank
WHERE rank_num <= 5;


