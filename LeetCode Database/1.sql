-- @block
-- 1. 175. Combine Two Tables

-- Create table If Not Exists Person (personId int, firstName varchar(255), lastName varchar(255));
-- Create table If Not Exists Address (addressId int, personId int, city varchar(255), state varchar(255));
-- Truncate table Person;
-- insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen');
-- insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob');
-- Truncate table Address;
-- insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
-- insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California');

SELECT firstName, lastName, city, state FROM Person
LEFT JOIN Address
ON Person.personId = Address.personId;

-- @block
-- 2 176. Second Highest Salary

-- create table if not exists Employee(
--     id int, 
--     salary int
-- );
-- truncate table Employee;
-- insert into Employee (id, salary)
-- values (1, 100),
-- (2, 200),
-- (3, 300);

SELECT MAX(salary) AS SecondHighestSalary FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

-- TRUNCATE table Employee;
-- insert into Employee (id, salary)
-- values (1, 100);


-- @block
-- 3 177. Nth Highest Salary

-- SET GLOBAL log_bin_trust_function_creators = 1;
-- CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
-- BEGIN
-- SET N = N - 1;
--   RETURN (
--       SELECT DISTINCT(salary) FROM Employee ORDER BY salary DESC
--       LIMIT 1 OFFSET N
--   );
-- END
SELECT getNthHighestSalary(4);

-- @block
-- 4 178. Rank Scores

-- CREATE TABLE IF NOT EXISTS Scores (
--     id int,
--     score DECIMAL(3, 2)
-- );
-- INSERT INTO Scores (id, score) VALUES 
--     (1, 3.5),
--     (2, 3.65),
--     (3, 4.0),
--     (4, 3.85),
--     (5, 4.0),
--     (6, 3.65);

-- SELECT score, 
--     (
--         SELECT COUNT(DISTINCT score) FROM Scores
--      WHERE score >= s.score
--     ) AS `rank`
--     FROM Scores AS s 
--     ORDER BY score DESC;

SELECT score, DENSE_RANK() OVER (ORDER BY score DESC) AS `rank`
FROM Scores;

-- @block
-- 5 180. Consecutive Numbers

-- create table if not exists Logs (id int, num int);
-- truncate table Logs;
-- insert into Logs (id, num) values 
--     ('1', '1'),
--     ('2', '1'),
--     ('3', '1'),
--     ('4', '2'),
--     ('5', '1'),
--     ('6', '2'),
--     ('7', '2');

SELECT DISTINCT l1.num AS ConsecutiveNums 
FROM Logs l1, Logs l2, Logs l3
WHERE l1.id = l2.id - 1 AND l1.num = l2.num
    AND l2.id = l3.id - 1 AND l2.num = l3.num;

-- @block
-- 6 181. Employees Earning More Than Their Managers

-- Create table If Not Exists Employee1 (id int, name varchar(255), salary int, managerId int);
-- Truncate table Employee1;
-- insert into Employee1 (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
-- insert into Employee1 (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
-- insert into Employee1 (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL);
-- insert into Employee1 (id, name, salary, managerId) values ('4', 'Max', '90000', NULL);

SELECT e1.name AS Employee1 FROM Employee1 e1, Employee1 e2
WHERE e1.managerId = e2.id AND e1.salary > e2.salary;


-- @block
-- 7 182. Duplicate Emails

-- Create table If Not Exists Person1 (id int, email varchar(255));
-- Truncate table Person1;
-- insert into Person1 (id, email) values ('1', 'a@b.com');
-- insert into Person1 (id, email) values ('2', 'c@d.com');
-- insert into Person1 (id, email) values ('3', 'a@b.com');

SELECT email FROM Person1 
GROUP BY email HAVING COUNT(email) > 1;

-- @block
-- 8 183. Customers Who Never Order

-- Create table If Not Exists Customers (id int, name varchar(255));
-- Create table If Not Exists Orders (id int, customerId int);
-- Truncate table Customers;
-- insert into Customers (id, name) values ('1', 'Joe');
-- insert into Customers (id, name) values ('2', 'Henry');
-- insert into Customers (id, name) values ('3', 'Sam');
-- insert into Customers (id, name) values ('4', 'Max');
-- Truncate table Orders;
-- insert into Orders (id, customerId) values ('1', '3');
-- insert into Orders (id, customerId) values ('2', '1');

SELECT name Customers FROM Customers
WHERE id NOT IN (SELECT customerId FROM Orders);

-- @block
-- 9 184. Department Highest Salary

-- Create table If Not Exists Employee2 (id int, name varchar(255), salary int, departmentId int);
-- Create table If Not Exists Department (id int, name varchar(255));
-- Truncate table Employee2;
-- insert into Employee2 (id, name, salary, departmentId) values 
--     ('1', 'Joe', '70000', '1'),
--     ('2', 'Jim', '90000', '1'),
--     ('3', 'Henry', '80000', '2'),
--     ('4', 'Sam', '60000', '2'),
--     ('5', 'Max', '90000', '1');
-- Truncate table Department;
-- insert into Department (id, name) values ('1', 'IT');
-- insert into Department (id, name) values ('2', 'Sales');

SELECT d.name Department, e.name Employee, e.salary Salary 
FROM Department d, Employee2 e 
WHERE e.departmentId = d.id AND (e.departmentId, salary) IN 
(SELECT departmentId, MAX(salary) FROM Employee2 GROUP BY departmentId);

-- @block
-- 10 185. Department Top Three Salaries

-- Create table If Not Exists Employee3 (id int, name varchar(255), salary int, departmentId int);
-- Create table If Not Exists Department (id int, name varchar(255));
-- Truncate table Employee3;
-- insert into Employee3 (id, name, salary, departmentId) values 
--     ('1', 'Joe', '85000', '1'),
--     ('2', 'Henry', '80000', '2'),
--     ('3', 'Sam', '60000', '2'),
--     ('4', 'Max', '90000', '1'),
--     ('5', 'Janet', '69000', '1'),
--     ('6', 'Randy', '85000', '1'),
--     ('7', 'Will', '70000', '1');

-- Truncate table Department;
-- insert into Department (id, name) values ('1', 'IT');
-- insert into Department (id, name) values ('2', 'Sales');

WITH top3 AS(
SELECT d.name as Department, e.name as Employee, e.salary as Salary, DENSE_RANK() OVER (PARTITION BY d.name ORDER BY e.salary desc) row_num
FROM Department d JOIN Employee3 e
ON d.Id = e.departmentId)

SELECT Department, Employee, Salary
FROM top3
WHERE row_num <= 3
ORDER BY Department, Salary DESC;
