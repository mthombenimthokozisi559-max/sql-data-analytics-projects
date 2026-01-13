SELECT * FROM world_life_expectancy.worldlifeexpectancy;

delete from world_life_expectancy
where row_id in
(
select row_id
from(
select row_id, country, year, concat(year,country), row_number()
over (partition by concat(year,country) order by country desc) as row_num
from world_life_expectancy) as table1
where row_num > 1);

select distinct(country)
from world_life_expectancy
where status = 'developing' ;

select t1.country, t1.status, t2.country, t2.status
from world_life_expectancy t1
join world_life_expectancy t2
 on t1.country = t2.country
 where t1.status = ''
 and t2.status = 'developing';
 
 update world_life_expectancy t1
 join world_life_expectancy t2
 on t1.country = t2.country
 set t1.status = 'Developed'
 where t1.status = ''
 and t2.status != ''
 and t2.status = 'developed'
 ;
 
  update world_life_expectancy t1
 join world_life_expectancy t2
 on t1.country = t2.country
 set t1.status = 'Developing'
 where t1.status = ''
 and t2.status != ''
 and t2.status = 'developing'
 ;
	
select *
from world_life_expectancy 
where status = '';

select t1.country, t1.year, t1.`life expectancy`, t2.country, t2.year, t2.`life expectancy`, t3.country, t3.year, t3.`life expectancy`,
ROUND((t1.`life expectancy` + t2.`life expectancy`)/2,1)
from world_life_expectancy t1
JOIN world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year-1
JOIN world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year+1 ;
    
    update world_life_expectancy t1
    JOIN world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year-1
JOIN world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year+1
    set t1.`life expectancy` = ROUND((t1.`life expectancy` + t2.`life expectancy`)/2,1)
    where t1.`life expectancy` = '' ;
    
    select * 
    from world_life_expectancy;
    
    select country, 
    max(`life expectancy`), 
    min(`life expectancy`), 
    round(max(`life expectancy`) - min(`life expectancy`),1) as Life_Increase_15_years
    from world_life_expectancy
    group by country
    having max(`life expectancy`) != 0
    and min(`life expectancy`) != 0
    order by  Life_Increase_15_years asc;
    
    select year, round(avg(`life expectancy`),1) as Yearly_Avg
    from world_life_expectancy
    where `life expectancy` != 0
    group by year
    order by year;
    
    select country, ROUND(AVG(`life expectancy`),1) as life_exp, ROUND(avg(gdp),1)as gdp
    from world_life_expectancy
    group by country
    HAVING life_exp > 0
    AND gdp > 0
    order by gdp asc;
    
    
   select country, round(avg(`life expectancy`),1) as avg_life_exp , round(avg(bmi),1) as avg_bmi, round(avg(gdp),1) as avg_gdp
	from world_life_expectancy
    where gdp is not null
    and bmi is not null
    and gdp >
   (SELECT AVG(gdp) AS avg_global_gdp
	FROM world_life_expectancy
    where gdp is not null)
group by country
order by avg_gdp desc
;


select
case 
when gdp > (SELECT AVG(gdp) AS avg_global_gdp
	FROM world_life_expectancy
    where gdp is not null) Then 'Above average gdp'
    else 'Below average gdp' end as gdp_group,
    round(avg(`life expectancy`),1) as avg_life_exp , 
    round(avg(bmi),1) as avg_bmi, 
    round(avg(gdp),1) as avg_gdp
	from world_life_expectancy
    where gdp is not null
    and bmi is not null
    group by gdp_group;
    
    #Countries with above-average GDP consistently show higher 
    #life expectancy and higher average BMI compared to countries below the global GDP average. 
    #This suggests that economic strength is strongly associated with improved access to 
    #healthcare, nutrition, and overall living conditions. However, 
    #the increase in BMI among higher-GDP countries may also reflect a shift 
    #toward over-nutrition, highlighting the importance of balancing economic growth with public health outcomes.
    
    
    



