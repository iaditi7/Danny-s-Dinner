CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

select * from members;
select * from menu;
select * from sales;



-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as Customer_spent from sales s inner join menu m 
	on s.product_id=m.product_id 
	group by s.customer_id 
	order by s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(order_date) from sales 
	group by customer_id 
	order by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
with temp as 
	(select s.customer_id, s.order_date, m.product_name, 
	 row_number() over(partition by s.customer_id order by s.order_date) as rnk
	from menu m inner join sales s 
	on m.product_id = s.product_id
	order by customer_id, order_date)
select customer_id, product_name from temp where rnk=1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
with temp as
	(select m.product_name, count(m.product_id) as order_cnt, 
	dense_rank() over(order by count(m.product_name)  desc) as rnk
	from menu m inner join sales s on s.product_id = m.product_id 
	group by m.product_name)
select product_name, order_cnt from temp where rnk=1;

-- 5. Which item was the most popular for each customer?
with temp as
	(select s.customer_id, m.product_name, count(m.product_name) as cnt, 
	row_number() over(partition by s.customer_id order by count(m.product_name)  desc) as rnk
	from menu m inner join sales s 
	on s.product_id = m.product_id
	group by m.product_name, s.customer_id
	order by s.customer_id)
select customer_id, product_name from temp where rnk=1;

-- 6. Which item was purchased first by the customer after they became a member?
with temp as
	(select s.customer_id, m.product_name, s.order_date, mem.join_date, 
	row_number() over(partition by s.customer_id order by s.order_date) as rnk  
	from menu m join sales s on m.product_id=s.product_id
	join members mem on s.customer_id = mem.customer_id
	where s.order_date>mem.join_date) 
select customer_id, product_name from temp where rnk =1;

-- 7. Which item was purchased just before the customer became a member?
with temp as
	(select s.customer_id, m.product_name, s.order_date, mem.join_date, 
	dense_rank() over(partition by s.customer_id order by s.order_date desc) as rnk  
	from menu m join sales s on m.product_id=s.product_id
	join members mem on s.customer_id = mem.customer_id
	where s.order_date<mem.join_date
	order by s.customer_id)
select customer_id, product_name from temp where rnk =1;

-- 8. What is the total items and amount spent for each member before they became a member?
with temp as
(select s.customer_id, m.product_name, m.price, s.order_date, mem.join_date  
	from menu m 
	join sales s on m.product_id=s.product_id
	join members mem on s.customer_id = mem.customer_id
	where s.order_date<mem.join_date
	order by s.customer_id)
select customer_id, sum(price) from temp group by customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with temp as
(select s.customer_id, m.product_name, m.price, 
	case 
		when m.product_name='sushi' then m.price*10*2
		else m.price*10*1
		end as points_gained
		from menu m inner join sales s on m.product_id=s.product_id)
select customer_id, sum(points_gained) from temp 
	group by customer_id 
	order by customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select mem.customer_id, m.product_name, m.price, s.order_date, mem.join_date,
	case when s.order_date between mem.join_date and DATEADD(day, 7, mem.join_date) then m.price*10*2
		 when m.product_name='sushi' then m.price*10*2
		 else m.price*10*1
	   	end as points_gained
	from menu m join sales s on m.product_id=s.product_id 
	join members mem on mem.customer_id=s.customer_id
	where order_date<='2021-01-31';


-- 11. Determine the name and price of the product ordered by each customer on all order dates and 
-- Find out whether the customer was a member on the order date or not
select s.customer_id, s.order_date, m.product_name, m.price,
	case when s.order_date>=mem.join_date then 'Yes'
	else 'No'
	end as is_member
	from sales s join menu m on s.product_id = m.product_id 
	left join members mem on mem.customer_id = s.customer_id;


-- 12. Rank the previous output from Q11 based on the order_date for each customer. 
-- Display Null if the customer was not a member when the dish was ordered
with temp as (select s.customer_id, s.order_date, m.product_name, m.price,
	case when s.order_date>=mem.join_date then 'Yes'
	else 'No'
	end as is_member
	from sales s join menu m on s.product_id = m.product_id 
	left join members mem on mem.customer_id = s.customer_id)
select *, case 
			when is_member='Yes' then dense_rank() over(partition by customer_id, is_member order by order_date)
			else NULL
			end ranking
			from temp;
