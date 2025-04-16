use classicmodels;
SELECT p.productLine, COUNT(od.orderNumber) AS order_count
FROM products p
INNER JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY p.productLine
HAVING COUNT(od.orderNumber) > 100;

select m.firstname as manager, m.lastname as manager,
COUNT(e.employeeNumber) AS employee_count
from employees e
join employees m on e.reportsTo = m.employeeNumber
GROUP BY m.employeeNumber, m.firstName, m.lastName;

SELECT 
    c.city, 
    COUNT(CASE WHEN o.status = 'Shipped' THEN o.orderNumber END) AS shipped_orders,
    COUNT(CASE WHEN o.status = 'Cancelled' THEN o.orderNumber END) AS cancelled_orders,
    COUNT(CASE WHEN o.status = 'Resolved' THEN o.orderNumber END) AS resolved_orders,
    COUNT(CASE WHEN o.status = 'On Hold' THEN o.orderNumber END) AS on_hold_orders,
    COUNT(CASE WHEN o.status = 'Disputed' THEN o.orderNumber END) AS disputed_orders,
    COUNT(CASE WHEN o.status = 'In Process' THEN o.orderNumber END) AS in_process_orders
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.city;

SELECT o.city AS office_city, COUNT(ord.orderNumber) AS total_orders
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders ord ON c.customerNumber = ord.customerNumber
GROUP BY o.city;

SELECT e.employeeNumber, e.firstName, e.lastName, COUNT(o.orderNumber) AS total_orders
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE e.officeCode NOT IN (
    SELECT officeCode FROM offices WHERE country = 'USA'
)
GROUP BY e.employeeNumber, e.firstName, e.lastName;


WITH RankedSales AS (  
    SELECT  
        p.productLine,  
        p.productCode,  
        SUM(od.quantityOrdered) AS total_orders,  
        RANK() OVER (PARTITION BY p.productLine ORDER BY SUM(od.quantityOrdered) DESC) AS rnk  
    FROM orderdetails od  
    JOIN products p ON od.productCode = p.productCode  
    GROUP BY p.productLine, p.productCode  
)  
SELECT productLine, productCode, total_orders  
FROM RankedSales  
WHERE rnk = 2;





