update film
set rental_duration = 3, rental_rate = 9.99
where title = 'DICTATOR';



with selected_customer as(
select c.customer_id, c.first_name, c.last_name, c.email , c.address_id, 
count(p.payment_id) as payment_record, 
count(r.rental_id) as rental_record
from customer c
join payment p on c.customer_id = p.customer_id
join rental r on c.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
group by c.customer_id
having count(p.payment_id) >= 10 and count(r.rental_id) >= 10
limit (1)
),

selected_address as(
select address_id
from address
limit(1)
)

update customer
set first_name = 'Denis',
last_name = 'Dudinskij',
email = 'myemail@.com',
address_id = (select address_id from selected_address)
where customer_id = (select customer_id from selected_customer);


update customer 
set create_date = current_date 
where first_name = 'Denis' and last_name = 'Dudinskij';










