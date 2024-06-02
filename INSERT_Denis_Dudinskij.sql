--check if the film is already present


select film_id, title
from film 
where upper(title) = 'DICTATOR';


--adding film

insert into film (title, description, release_year, language_id, original_language_id, rental_duration, 
rental_rate, length, rating, special_features, fulltext)
values ('DICTATOR', 'comedy about dictator', 2012, 
(select language_id from language where name = 'English'), 
(select language_id from language where name = 'English'), 
2, 4.99, 83, 'R', '{some special feature}',
to_tsvector('english', 'comedy about dictator') );




--adding actors to actor, film_actor



--checking if already in the database

select actor_id, first_name, last_name
from actor 
where first_name = 'JASON' and last_name = 'MANTZOUKAS';

select actor_id, first_name, last_name
from actor 
where first_name = 'ANNA' and last_name = 'FARIS';

insert into actor (first_name, last_name)
values ('JASON', 'MANTZOUKAS'),
('ANNA', 'FARIS');

insert into film_actor (actor_id, film_id)
values 
((select actor_id from actor where first_name = 'JASON' and last_name = 'MANTZOUKAS'),
(select film_id from film where title = 'DICTATOR') ),
((select actor_id from actor where first_name = 'ANNA' and last_name = 'FARIS'),
(select film_id from film where title = 'DICTATOR') );

--checking if added

select actor_id
from film_actor
where film_id = (select film_id from film where title = 'DICTATOR');


--add to any's shop inventory

insert into inventory (film_id, store_id)
values ((select film_id from film where title = 'DICTATOR'), 1);

--check

select * from inventory
where film_id = (select film_id from film where title = 'DICTATOR');



















