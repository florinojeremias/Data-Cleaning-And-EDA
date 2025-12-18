use world_layoffs;


set sql_safe_updates=0;

select * from layoffs limit 50;

-- 1.Remove duplicates
-- 2.Standardize the data
-- 3.Null values or blank values
-- 4.Remove any Columns

--  criamos uma tabela parecida com a original para fazer o data cleaning
-- cria uma tabela com a estrutura parecida com a tabela mencionada
create table layoffs_stagging
like layoffs;

select count(*) from layoffs_stagging;

-- insert layoffs_stagging
-- select * from layoffs;
 
with duplicate_cte as(
 select *,
 row_number() over(
 partition by company,location,industry, total_laid_off,percentage_laid_off,`date`,
 stage,country,funds_raised_millions) as row_num
 from layoffs_stagging
)
select* from duplicate_cte
where row_num > 1;

select * from layoffs_stagging
where company='yahoo';




CREATE TABLE `layoffs_staggin2` (
  `company` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `industry` text DEFAULT NULL,
  `total_laid_off` int(11) DEFAULT NULL,
  `percentage_laid_off` text DEFAULT NULL,
  `date` text DEFAULT NULL,
  `stage` text DEFAULT NULL,
  `country` text DEFAULT NULL,
  `funds_raised_millions` int(11) DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


select * from layoffs_staggin2;
/*
 insert into layoffs_staggin2
 select *,
 row_number() over(
 partition by company,location,industry, total_laid_off,percentage_laid_off,`date`,
 stage,country,funds_raised_millions) as row_num
 from layoffs_stagging;
 
 */

select * from layoffs_staggin2
where row_num >1;

Delete 
from layoffs_staggin2
where row_num >1;

select * from layoffs_staggin2
where row_num >1;
-- Standardizing data

update layoffs_staggin2
set company = trim(company);

select  distinct industry
from layoffs_staggin2 order by 1;

select * 
from layoffs_staggin2 where industry like 'crypto%';

update layoffs_staggin2
set industry = 'Crypto' 
where industry like 'Crypto%';

select  distinct country
from layoffs_staggin2 order by 1;

update layoffs_staggin2
set country ='United States'
where country like 'United States%';

-- Trailing elemina o que for especificado dentro das aspas e de seguida
-- especificamos a coluna

select
distinct company
from layoffs_stagging order by 1;

update layoffs_staggin2
set country = trim(trailing '.' from country)
where country like 'United States%';

select
distinct company,
trim(trailing 'P' from company) from layoffs_staggin2
where company like '%Paid';




-- convertendo texto para date

select `date`
 from layoffs_staggin2;
 
 -- update layoffs_staggin2 set
  -- `date` = str_to_date(`date`,'%m/%d/%Y');
 
 -- alterando o tipo de dados de text para date
 
 -- alter table layoffs_staggin2
 -- modify column `date` date;
 
 /*insert into layoffs_staggin2(date)
 
 */
-- select `date` from layoffs_staggin2;
 
 /*insert into layoffs_staggin2(date)
 select date from layoffs_stagging;
 */


select * from  layoffs_staggin2;


-- remove null and blank values

select * from layoffs_staggin2
where industry is null 
or industry ='';


update layoffs_staggin2
set industry= null
where industry= '';



select * from layoffs_staggin2 t1
join layoffs_staggin2 t2
on t1.company=t2.company 
and t1.location=t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staggin2 t1
join layoffs_staggin2 t2
on t1.company = t2.company 
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

select * from layoffs_staggin2;


delete from layoffs_staggin2
where total_laid_off is null
and percentage_laid_off is null;
 
alter table layoffs_staggin2
 drop column row_num;

