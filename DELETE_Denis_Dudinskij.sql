with inventory_data as (with film_for_deleting as(
select film_id
from film
where title = 'DICTATOR'
)

select inventory_id
from inventory
where film_id = (select film_id from film_for_deleting))

delete from payment where rental_id = (select rental_id from rental 
where inventory_id = (select inventory_id from inventory_data));




with inventory_data as (with film_for_deleting as(
select film_id
from film
where title = 'DICTATOR'
)

select inventory_id
from inventory
where film_id = (select film_id from film_for_deleting))

delete from rental where inventory_id = (select inventory_id from inventory_data);



with inventory_data as (with film_for_deleting as(
select film_id
from film
where title = 'DICTATOR'
)

select inventory_id
from inventory
where film_id = (select film_id from film_for_deleting))

delete from inventory where inventory_id = (select inventory_id from inventory_data);



delete from payment
where customer_id = (select customer_id from customer where first_name = 'Denis' and last_name = 'Dudinskij');

delete from rental
where customer_id = (select customer_id from customer where first_name = 'Denis' and last_name = 'Dudinskij');










