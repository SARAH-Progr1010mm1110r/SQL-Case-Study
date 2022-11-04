use employees ;

select employees.gender,avg(salaries.salary)
from salaries
inner join employees on employees.emp_no = salaries.emp_no
where   to_date >='2000-12-31' 
group by gender; 
/*
I would like to mention that I set the condition here according to the current and future employees according to the mentioned date. According to this condition, it appears that the average salaries for female are lower than that of male.
After the previous query, it appears that boys are higher in terms of salaries, so I will increase 50 for female*/

/*Here, I created a query that increases salaries by 50 dollars, provided that gender is a female and that she is currently employed or in the future, according to the date
*/
Select salaries.salary+85 , employees.gender,employees.emp_no
from salaries
inner join employees on employees.emp_no = salaries.emp_no 
where gender= 'F' AND  to_date >= '2000-12-31' ;

/*So the total amount (bonus) paid here is 85 x (87307 the number of females) = 7421095 
*/
Select  employees.gender,count(employees.emp_no)
from salaries
inner join employees on employees.emp_no = salaries.emp_no 
where  to_date >= '2000-12-31' 
group by gender;

/*Here I created a query that increases the salary of 150 dollars for employees who have worked for the company for 10 years or more
*/
select salaries.salary+150 ,employees.emp_no , DATEDIFF('2000-12-31', from_date)/365 as YEARS 
from salaries
inner join employees on employees.emp_no = salaries.emp_no 
where DATEDIFF('2000-12-31', from_date)/365 >= 10; 
/*Therefore, the total amount (bonus) paid here is 150 x (136,124 the number of employees with 10 years of service or more) = 20418600
*/
Select  count(employees.emp_no)
from salaries
inner join employees on employees.emp_no = salaries.emp_no 
where DATEDIFF('2000-12-31', from_date)/365 >= 10;

/*Here I created a query to increase the salary of $200 for employees whose contracts will expire on 2001-2-1 
*/
select salaries.salary+200 ,employees.emp_no ,salaries.to_date 
from salaries
inner join employees on employees.emp_no = salaries.emp_no 
where to_date= '2001-2-1'; 

Select  count(employees.emp_no), salaries.to_date 
from salaries
inner join employees on employees.emp_no = salaries.emp_no 
where to_date= '2001-2-1'; 


-- The total amount of all bonus plans is 7421095$ + 20418600$ + 50000$ =27889695$ and it is still under 50$ million



