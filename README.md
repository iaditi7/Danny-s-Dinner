# Restaurent Customer Analysis through SQL
This is a case study based project that uses a restaurant's data to gain insights of the customers' visiting patterns, their most liked dishes, monthly visits etc.

# Case Study 1: Danny's Dinner
![image](https://github.com/user-attachments/assets/c66129f3-85f9-4202-a0a8-12181286d6a2)

# Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.
Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

# Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

1.sales
2.menu
3.members

# Entity Relationship Diagram
![image](https://github.com/user-attachments/assets/e11d991b-03da-4657-bef6-275e5666c573)

# Table 1: Sales
The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
![image](https://github.com/user-attachments/assets/ef2202a0-631a-40af-8717-93529722f087)

# Table 2: Menu
The menu table maps the product_id to the actual product_name and price of each menu item.
![image](https://github.com/user-attachments/assets/0dbecd16-8093-4903-985c-d2d0ae6ad0d4)

# Table 3: Members
The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.
![image](https://github.com/user-attachments/assets/fb6216c8-925a-4ccc-bff3-789419925b36)

# Case Study Questions
1.What is the total amount each customer spent at the restaurant?
2.How many days has each customer visited the restaurant?
3.What was the first item from the menu purchased by each customer?
4.What is the most purchased item on the menu and how many times was it purchased by all customers?
5.Which item was the most popular for each customer?
6.Which item was purchased first by the customer after they became a member?
7.Which item was purchased just before the customer became a member?
8.What is the total items and amount spent for each member before they became a member?
9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?






