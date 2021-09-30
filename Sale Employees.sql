select * from classicmodels.customers;

select * from classicmodels.employees;

select * from classicmodels.offices;

select * from classicmodels.orderdetails;

select * from classicmodels.orders;

select * from classicmodels.payments;

select * from classicmodels.productlines;

select * from classicmodels.products;

/*Get Granularity of all tables in the database and find the connections between them

Using employees table, get a full detail info list of Sales Rep plus 2 extra columns (using ReportTo column to find manager)
   Manager Name
   VP Manager Name
*/
#  1. Get monthly revenue per customer
select  cus.customerName,
		cus.customerNumber,
        date_format(ord.orderDate,'%Y-%m-01') as order_month,
		sum(odd.quantityOrdered * odd.priceEach) as total_sales
from classicmodels.customers cus
	left join classicmodels.orders ord
		on cus.customerNumber = ord.customerNumber
    left join classicmodels.orderdetails odd
		on odd.orderNumber = ord.orderNumber
group by cus.customerName,
		cus.customerNumber,
        date_format(ord.orderDate,'%Y-%m-01')
;

# 2. Get monthly total revenue, total orders by Sales Manager. Sales Manager will get revenue from Sales Rep under
select 
	# SALE MANAGER
    # MONTH
	# TOTAL SALES
-- 	, cus.customerNumber
		mana.employeeNumber as manager_id
        , mana.firstName
        , mana.jobTitle as manager_role
		, date_format(orderDate, '%Y-%m-%01') as order_month
		, sum(odd.priceEach * odd.quantityOrdered) as total_sales
from classicmodels.employees as emp
	left join classicmodels.employees as mana
		on mana.employeenumber = emp.reportsTo
	left join classicmodels.customers as cus
		on cus.salesRepEmployeeNumber = emp.employeeNumber
	left join classicmodels.orders as ord
		on cus.customerNumber = ord.customerNumber
    left join classicmodels.orderdetails as odd
		on odd.orderNumber = ord.orderNumber
where mana.jobTitle like '%Sale%Manager%'
group by mana.employeeNumber 
        , mana.firstName
        , mana.jobTitle 
		, date_format(orderDate, '%Y-%m-%01')
    ;

