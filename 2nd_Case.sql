use employees;

select * from employees;
select * from dept_emp;
select * from dept_manager;
select * from departments;
select * from titles;
select * from salaries
order by emp_no desc;

create table all_emp (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
  FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)  ON DELETE CASCADE
  );
  
select * from all_emp;
   insert into all_emp
   select  * from dept_manager
   union 
   select  * from dept_emp ;

-- the total amount of salaries last year
select sum(salaries.salary) 
from salaries
where salaries.to_date > '1999-12-31' && salaries.to_date <= '2000-12-31'; -- Total = '5914584280' ~ 6 milion

-- total amount of salaries paid to each department last year
select all_emp.dept_no,departments.dept_name,count(all_emp.emp_no) as emp_count,sum(salaries.salary) as dept_amount
from all_emp
inner join salaries on salaries.emp_no = all_emp.emp_no
inner join departments on departments.dept_no = all_emp.dept_no
where salaries.to_date > '1999-12-31' && salaries.to_date <= '2000-12-31'
group by dept_no 
order by sum(salaries.salary) desc;

# 'Development', '1580097790'
# 'Production', '1364480859'
# 'Sales', '1290619775'
# 'Marketing', '440950470'
# 'Customer Service', '433738224'
# 'Research', '390864771'
# 'Finance', '372302687'
# 'Quality Management', '354625211'
# 'Human Resources', '309020676'

-- reduce the cost of all contracts expiring within a year
select count(emp_no) from all_emp 
where to_date < '2000-12-31' and to_date > '1999-12-31';

-- employee’s information plan to reduce 
select all_emp.emp_no, employees.first_name, employees.last_name, 
employees.gender, year(all_emp.to_date)-year(employees.hire_date) as exp,
employees.birth_date, employees.hire_date from employees 
inner join all_emp on employees.emp_no = all_emp.emp_no
where to_date < '2000-12-31' and to_date > '1999-12-31';

select salaries.emp_no ,salaries.salary ,departments.dept_name 
from all_emp
inner join salaries on all_emp.emp_no = salaries.emp_no
inner join departments on departments.dept_no = all_emp.dept_no
where departments.dept_name = 'Human Resources' && salaries.to_date > '1999-12-31' && salaries.to_date <= '2000-12-31'
order by salaries.salary desc
;
-- all employess salary + years of experience
drop view exp_year;
create view exp_year AS

select all_emp.emp_no,
departments.dept_name,
employees.hire_date,
2000-year(employees.birth_date) as age,
year(all_emp.to_date)-year(employees.hire_date) as exp,
salaries.from_date,salaries.to_date,salaries.salary
from all_emp
inner join salaries on salaries.emp_no = all_emp.emp_no
inner join departments on departments.dept_no = all_emp.dept_no
inner join employees on employees.emp_no = all_emp.emp_no
where salaries.from_date > '2000-1-1' AND salaries.to_date <= '2000-12-31'; -- means he still work in the company ;

select * from exp_year
order by dept_name;

-- or by mention department name 
select * from exp_year
where dept_name = 'Human Resources'
order by salary and exp;

-- -- create a view of older employees  
drop view old_emp;
create view old_emp AS
select all_emp.emp_no,
departments.dept_name,
2000-year(employees.birth_date) as age,
year(all_emp.to_date)-year(employees.hire_date) as exp,
salaries.salary AS salary
from all_emp
inner join salaries on salaries.emp_no = all_emp.emp_no
inner join departments on departments.dept_no = all_emp.dept_no
inner join employees on employees.emp_no = all_emp.emp_no
where salaries.from_date > '2000-1-1' AND salaries.to_date <= '2000-12-31'; -- means he still work in the company ;

-- percentage of total of salaries of older employees  
	select sum(salary) as total,
	(sum(salary)* 100 / (Select sum(salary) From old_emp)) as percentage
	from old_emp
	where age >= 47 or exp =15
	order by salary and exp;

-- average salary for males and females 
Select 
employees.gender, AVG(salaries.salary) AS AVERAGE_SALARY
from employees 
inner join salaries on  employees.emp_no = salaries.emp_no
group by gender

