select * from employees;
select * from dept_emp;
select * from dept_manager;
select * from departments;
select * from titles;
select * from salaries;
select * from all_emp;



-- -------------------------------------------------------------------
-- ----------------------------CASE #1 ---------------------------------------

-- create tabel for all emp + manager
DROP TABLE IF EXISTS  all_emp;
create table all_emp (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
  FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE
  );
   
   insert into `all_emp`
   select  * from dept_manager
   union 
   select  * from dept_emp ; 
   
   -- ---------------------------------------------------------
   -- ---------------------------------------------------------
   -- for employees whose contracts have not expired yet.
   select count(distinct all_emp.emp_no) ,employees.gender
   from all_emp 
   join employees on employees.emp_no = all_emp.emp_no
   where year(all_emp.to_date) >= 2000
   group by employees.gender;
   -- -------------------------------
   -- '155434', 'M' .. '103552', 'F'
   
-- gender in the last 5 year + ratio --  
#select COUNT(IF(gender = 'M', 1, NULL)) Male ,
 #COUNT(IF(gender = 'F', 1, NULL)) Female, 
 #COUNT(IF(gender = 'M', 1, NULL))/COUNT(IF(gender = 'F', 1, NULL)) as ratio 
 #from employees
 #inner join all_emp on all_emp.emp_no = employees.emp_no
 #where all_emp.to_date> '1995-12-31' && all_emp.to_date <= '2000-12-31' ;

-- * hired in the last 5 years << 
select COUNT(IF(gender = 'M', 1, NULL)) Male ,
 COUNT(IF(gender = 'F', 1, NULL)) Female, 
 COUNT(IF(gender = 'M', 1, NULL))/COUNT(IF(gender = 'F', 1, NULL)) as ratio 
 from employees
 inner join all_emp on all_emp.emp_no = employees.emp_no
 where employees.hire_date > '1995-12-31';
-- ---------------------------------------------------
-- ----------------------------------------------------
-- departments that have the highest gaps in descending order  for last 5 year  ----------------------------------------------------

Select employees.gender,all_emp.dept_no,departments.dept_name,count(distinct all_emp.emp_no) AS male_no
from employees 
join all_emp on  employees.emp_no = all_emp.emp_no
join departments on departments.dept_no = all_emp.dept_no 
where employees.gender = 'M' && all_emp.to_date >= '1995-12-31' -- < incloud hire date 
group by departments.dept_name 
order by count(all_emp.emp_no) desc;

Select employees.gender,all_emp.dept_no,departments.dept_name,count(distinct all_emp.emp_no) AS female_no
from employees 
join all_emp on  employees.emp_no = all_emp.emp_no
join departments on departments.dept_no = all_emp.dept_no 
where employees.gender = 'F' && all_emp.to_date >= '1995-12-31'
group by departments.dept_name 
order by count(all_emp.emp_no) desc;

-- ---------------------------------------------
-- average salary for males and females for last 5 year ---------------------------------------------
-- drop view AVG_Male_Salary ; 

CREATE VIEW AVG_Male_Salary AS
select  "2000" as YEAR ,avg(salary) As salary , employees.gender 
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1999-12-31' AND to_date <'2000-12-31' AND employees.gender = 'M'
union
select "1999" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1998-12-31' AND to_date <'1999-12-31' AND employees.gender = 'M'
union
select "1998" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1997-12-31' AND to_date <'1998-12-31' AND employees.gender = 'M'
union
select "1997" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1996-12-31' AND to_date <'1997-12-31' AND employees.gender = 'M'
union
select "1996" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1995-12-31' AND to_date <'1996-12-31' AND employees.gender = 'M';

-- drop view IF exists AVG_Female_Salary ; 

CREATE VIEW AVG_Female_Salary AS
select  "2000" as YEAR ,avg(salary) As salary , employees.gender 
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1999-12-31' AND to_date <'2000-12-31' AND employees.gender = 'F'
union
select "1999" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1998-12-31' AND to_date <'1999-12-31' AND employees.gender = 'F'
union
select "1998" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1997-12-31' AND to_date <'1998-12-31' AND employees.gender = 'F'
union
select "1997" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1996-12-31' AND to_date <'1997-12-31' AND employees.gender = 'F'
union
select "1996" as YEAR,avg(salary) As year_one , employees.gender
from salaries 
inner join employees on employees.emp_no = salaries.emp_no
where to_date >'1995-12-31' AND to_date <'1996-12-31' AND employees.gender = 'F';


CREATE VIEW AVG__Salary AS
select avg(salary) AS AVG,gender from AVG_Male_Salary
union
select avg(salary)AS AVG ,gender from AVG_Female_Salary;

-- drop view AVG__Salary;
-- select  * from AVG__Salary 


-- -----------------------------------------------------------
-- ----------------------------------------------------------




   