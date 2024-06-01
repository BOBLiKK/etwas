--Task 1 solution 1

with StaffRevenue as (

    select
        s.store_id, 
        p.staff_id, 
        sum(p.amount) as total_revenue
    from 
        payment p
    join rental r on p.rental_id = r.rental_id
    join inventory i on r.inventory_id = i.inventory_id
    join store s on i.store_id = s.store_id
    where 
        extract(year from p.payment_date) = 2017
    group by 
        s.store_id, p.staff_id
),
RankedStaff as (

    select 
        store_id, 
        staff_id, 
        total_revenue,
        row_number() over (partition by store_id order by total_revenue desc) as rank
    from 
        StaffRevenue
)

select 
    rs.store_id, 
    rs.staff_id, 
    concat(st.first_name, ' ', st.last_name) as full_name, 
    rs.total_revenue
from 
    RankedStaff rs
join 
    staff st on rs.staff_id = st.staff_id
where 
    rs.rank = 1;




--Task 1 solution 2
   

with staff_revenue as
( select s.store_id, 
st.first_name || ' ' || st.last_name as full_name, 
p.staff_id, 
sum(p.amount) as total_revenue 
from payment p 
join staff st on p.staff_id = st.staff_id 
join rental r on p.rental_id = r.rental_id 
join inventory i on r.inventory_id = i.inventory_id 
join store s on i.store_id = s.store_id 
where extract(year from p.payment_date) = 2017 
group by s.store_id, st.first_name, st.last_name, p.staff_id ) 
select distinct on (sr.total_revenue) sr.store_id, sr.full_name, sr.total_revenue 
from staff_revenue sr 
order by sr.total_revenue desc 
limit (select count(distinct store_id) from staff_revenue);



--Task 2 solution 1

with top_movies as (
    select f.film_id, 
    f.title, 
    count(r.rental_id) as rental_count, 
    f.release_year
    from rental r
    join inventory i on r.inventory_id = i.inventory_id
    join film f on i.film_id = f.film_id
    group by f.film_id, f.title, f.release_year
    order by rental_count desc
    limit 5
)
select
    film_id,
    title,
    rental_count,
    2024 - release_year as expected_audience_age
from top_movies;


--Task 2 solution 2

select f.film_id, 
f.title, 
count(r.rental_id) as rental_count, 
2024 - f.release_year as expected_audience_age
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.film_id, f.title, f.release_year
order by rental_count desc
limit 5;





--Task 3 solution 1

with last_acting_year as
( select a.actor_id, 
a.first_name, 
a.last_name, 
max(f.release_year) as last_year 
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id = f.film_id 
group by a.actor_id, a.first_name, a.last_name ) 
select actor_id, 
first_name, 
last_name, 
2024 - last_year as years_since_last_acting 
from last_acting_year
order by years_since_last_acting desc;


--Task 3 solution 2

select a.actor_id, 
a.first_name, 
a.last_name, 
2024 - max(f.release_year) as years_since_last_acting
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
group by a.actor_id, a.first_name, a.last_name
order by years_since_last_acting desc;





