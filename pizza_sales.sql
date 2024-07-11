-- Retrieve the total number of orders placed.
	
select count(order_id) as total_orders
from orders;

-- Calculate the total revenue generated from pizza sales.

select sum(orders_details.quantity * pizzas.price) as total_sales
from orders_details
inner join pizzas
on orders_details.pizza_id = pizzas.pizza_id

-- Identify the highest-priced pizza.

select pizza_types.name,pizzas.price
from pizza_types
inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

-- Identify the most common pizza size ordered.

select pizzas.size,count (orders_details.order_details_id)as total_count
from pizzas
inner join orders_details
on pizzas.pizza_id = orders_details.pizza_id
group by pizzas.size
order by total_count desc

-- List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name,sum(orders_details.quantity)
from pizza_types
inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details
on orders_details .pizza_id=pizzas.pizza_id
group by pizza_types.name
order by sum(orders_details.quantity) desc
limit 5

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select sum(orders_details.quantity),pizza_types.category
from orders_details
inner join pizzas
on orders_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.category
order by sum(orders_details.quantity) desc

-- Join relevant tables to find the category-wise distribution of pizzas.

select pizza_types.category ,count(name)pizza_types
from pizza_types
group by category

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,sum(orders_details.quantity * pizzas.price) as total_sales
from orders_details
inner join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.name
order by total_sales desc
limit 3

-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,sum(orders_details.quantity * pizzas.price)
	/(select
	sum(orders_details.quantity * pizzas.price)
	from orders_details
	inner join pizzas
	on orders_details.pizza_id = pizzas.pizza_id)*100 as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by revenue desc;

-- Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue)over (order by order_date)as cum_revenue
from
(select orders.order_date,
sum(orders_details.quantity*pizzas.price)as revenue
from orders_details join pizzas
on orders_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=orders_details.order_id
group by orders.order_date)as sales



