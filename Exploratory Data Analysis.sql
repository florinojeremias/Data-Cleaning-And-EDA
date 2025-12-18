use world_layoffs;

select* from layoffs_staggin2;
/*
select *, coalesce(total_laid_off,(select avg(total_laid_off) 
from layoffs_stagging )) as laid_ajustada
from layoffs_staggin2;
*/

select year(`date`), sum(total_laid_off)
from layoffs_staggin2
group by year(`date`)
order by 1 desc;

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staggin2
where substring(`date`,1,7)  is not null
group by `month`
order by 1 asc;


with rolling_total as(
select substring(`date`,1,7) as `Month`,
sum(total_laid_off) as total_off
from layoffs_staggin2
where substring(`date`,1,7)  is not null
group by `month`
order by 1 asc
)
select `month`,total_off,
sum(total_off) over(order by `month`) as rolling_tota
from rolling_total;


select company,sum(total_laid_off)
from layoffs_staggin2
group by company
order by 2 desc;

select * from layoffs_staggin2;

select company,year(`date`),sum(total_laid_off)
from layoffs_staggin2
group by company, year(`date`)
order by  company asc;

with company_year (company,industry, Years, total_laid_off) as (
select company, industry,year(`date`),sum(total_laid_off)
from layoffs_staggin2
group by company, year(`date`)
), company_year_rank as (
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as ranking 
from  company_year
where years is not null
)
select * 
from company_year_rank
where ranking <=5;


