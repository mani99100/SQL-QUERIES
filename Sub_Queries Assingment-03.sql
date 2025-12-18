CREATE DATABASE company_db;
USE company_db;

CREATE TABLE Employee (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50),
  department_id VARCHAR(10),
  salary INT
);

INSERT INTO Employee VALUES
	(101, 'Abhishek', 'D01', 62000),
	(102, 'Shubham', 'D01', 58000),
	(103, 'Priya', 'D02', 67000),
	(104, 'Rohit', 'D02', 64000),
	(105, 'Neha', 'D03', 72000),
	(106, 'Aman', 'D03', 55000),
	(107, 'Ravi', 'D04', 60000),
	(108, 'Sneha', 'D04', 75000),
	(109, 'Kiran', 'D05', 70000),
	(110, 'Tanuja', 'D05', 65000);

CREATE TABLE Department (
  department_id VARCHAR(10) PRIMARY KEY,
  department_name VARCHAR(50),
  location VARCHAR(50)
);

INSERT INTO Department VALUES
	('D01', 'Sales', 'Mumbai'),
	('D02', 'Marketing', 'Delhi'),
	('D03', 'Finance', 'Pune'),
	('D04', 'HR', 'Bengaluru'),
	('D05', 'IT', 'Hyderabad');

CREATE TABLE Sales (
  sale_id INT PRIMARY KEY,
  emp_id INT,
  sale_amount INT,
  sale_date DATE,
  FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

INSERT INTO Sales VALUES
	(201, 101, 4500, '2025-01-05'),
	(202, 102, 7800, '2025-01-10'),
	(203, 103, 6700, '2025-01-14'),
	(204, 104, 12000, '2025-01-20'),
	(205, 105, 9800, '2025-02-02'),
	(206, 106, 10500, '2025-02-05'),
	(207, 107, 3200, '2025-02-09'),
	(208, 108, 5100, '2025-02-15'),
	(209, 109, 3900, '2025-02-20'),
	(210, 110, 7200, '2025-03-01');

-- Basic Level
-- Employees earning more than average salary

SELECT name
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

-- Employees in department with highest average salary

SELECT name
FROM Employee
WHERE department_id = (
  SELECT department_id
  FROM Employee
  GROUP BY department_id
  ORDER BY AVG(salary) DESC
  LIMIT 1
);

-- Employees who made at least one sale
SELECT name
FROM Employee
WHERE emp_id IN (SELECT DISTINCT emp_id FROM Sales);

-- Employee with highest sale amount
SELECT name
FROM Employee
WHERE emp_id = (
  SELECT emp_id
  FROM Sales
  ORDER BY sale_amount DESC
  LIMIT 1
);

-- Employees earning more than Shubham
SELECT name
FROM Employee
WHERE salary > (
  SELECT salary
  FROM Employee
  WHERE name = 'Shubham'
);

-- Intermediate Level
-- Employees in same department as Abhishek
SELECT name
FROM Employee
WHERE department_id = (
  SELECT department_id
  FROM Employee
  WHERE name = 'Abhishek'
)
AND name != 'Abhishek';

-- Departments with at least one employee earning > ₹60,000
SELECT DISTINCT department_name
FROM Department
WHERE department_id IN (
  SELECT department_id
  FROM Employee
  WHERE salary > 60000
);

-- Department of employee with highest sale
SELECT department_name
FROM Department
WHERE department_id = (
  SELECT department_id
  FROM Employee
  WHERE emp_id = (
    SELECT emp_id
    FROM Sales
    ORDER BY sale_amount DESC
    LIMIT 1
  )
);

-- Employees with sales above average sale amount
SELECT name
FROM Employee
WHERE emp_id IN (
  SELECT emp_id
  FROM Sales
  WHERE sale_amount > (
    SELECT AVG(sale_amount)
    FROM Sales
  )
);

-- Total sales by employees earning above average salary
SELECT SUM(sale_amount) AS total_sales
FROM Sales
WHERE emp_id IN (
  SELECT emp_id
  FROM Employee
  WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
  )
);

-- Advanced Level

-- Employees who have not made any sales
SELECT name
FROM Employee
WHERE emp_id NOT IN (
  SELECT DISTINCT emp_id
  FROM Sales
);

-- Departments with average salary > ₹55,000
SELECT department_name
FROM Department
WHERE department_id IN (
  SELECT department_id
  FROM Employee
  GROUP BY department_id
  HAVING AVG(salary) > 55000
);

-- Departments with total sales > ₹10,000
SELECT department_name
FROM Department
WHERE department_id IN (
  SELECT E.department_id
  FROM Employee E
  JOIN Sales S ON E.emp_id = S.emp_id
  GROUP BY E.department_id
  HAVING SUM(S.sale_amount) > 10000
);

-- Employee with second-highest sale
SELECT name
FROM Employee
WHERE emp_id = (
  SELECT emp_id
  FROM Sales
  ORDER BY sale_amount DESC
  LIMIT 1 OFFSET 1
);

-- Employees earning more than highest sale amount
SELECT name
FROM Employee
WHERE salary > (
  SELECT MAX(sale_amount)
  FROM Sales
);
	