-- exploratory data analysis

select*
from layoffs_staging2;

select company, max(total_laid_off)
from layoffs_staging2
group by company;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select max(total_laid_off) max_laid_off, max(percentage_laid_off)max_percentage_laid_off
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off >= 0.5
order by total_laid_off desc;

select min(`date`), max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off) sum_laid_off
from layoffs_staging2
group by industry
order by sum_laid_off desc;

select country, sum(total_laid_off) sum_laid_off
from layoffs_staging2
group by country
order by sum_laid_off desc;

select YEAR(`date`), sum(total_laid_off) sum_laid_off
from layoffs_staging2
group by YEAR(`date`)
order by 1 desc;

select stage, sum(total_laid_off) sum_laid_off
from layoffs_staging2
group by stage
order by sum_laid_off desc;

-- percentage was not really relavent

-- its now going to be a little bit challenging
-- we are going to do it based on the month

-- use that substrin because if you use the aliase it wont work
select substring(`date`,1,7) month_order, sum(total_laid_off) sum_laid_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by month_order 
order by 1 asc; 

-- lets do a rolling sum

with Rolling_Total as
(
select substring(`date`,1,7) month_order, sum(total_laid_off) sum_laid_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by month_order 

)
select month_order, sum_laid_off, sum(sum_laid_off) over(order by month_order) rolling_total
from Rolling_Total;

-- look at how much people where being laid off per year

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company, year(`date`) date_order, sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

-- now we want to rank these according to the year  

with Company_Year (company,years,sumForTotalLaidOff)as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(
select*, dense_rank()over(partition by years order by sumForTotalLaidOff desc) Ranking
from Company_Year
where years is not null
-- with ths when you add order by rankin before making it a cte you can also see the company ranking per year a company with the most lay of fo the 2020 year 2021 year n so on
)
select *
from Company_Year_Rank
where Ranking<=5;





























































































































