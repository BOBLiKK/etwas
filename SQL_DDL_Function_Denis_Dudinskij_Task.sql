CREATE OR REPLACE VIEW sales_revenue_by_category_qtr AS
WITH current_quarter AS (
    SELECT
        EXTRACT(QUARTER FROM NOW()) AS quarter
),
revenue_by_category AS (
    SELECT
        c.name AS category,
        SUM(p.amount) AS total_revenue
    FROM
        payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE
        EXTRACT(QUARTER FROM r.rental_date) = (SELECT quarter FROM current_quarter)
    GROUP BY
        c.name
)
SELECT
    category,
    total_revenue
FROM
    revenue_by_category
WHERE
    total_revenue > 0;
	
SELECT * FROM sales_revenue_by_category_qtr;	
--------------------------------------------------------------------------------
	
CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(current_quarter INTEGER)
RETURNS TABLE(category TEXT, total_revenue NUMERIC) AS $$
BEGIN
    RETURN QUERY
    WITH revenue_by_category AS (
        SELECT
            c.name AS category_name,
            SUM(p.amount) AS total_revenue_sum
        FROM
            payment p
        JOIN rental r ON p.rental_id = r.rental_id
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        WHERE
            EXTRACT(QUARTER FROM r.rental_date) = current_quarter
        GROUP BY
            c.name
    )
    SELECT
        category_name AS category,
        total_revenue_sum AS total_revenue
    FROM
        revenue_by_category
    WHERE
        total_revenue_sum > 0;
END; $$
LANGUAGE plpgsql;


SELECT * FROM get_sales_revenue_by_category_qtr(2);

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION new_movie(movie_title TEXT)
RETURNS VOID AS $$
DECLARE
    new_film_id INT;
    klingon_language_id INT;
BEGIN

    SELECT language_id INTO klingon_language_id
    FROM language
    WHERE name = 'Klingon';
    
    IF klingon_language_id IS NULL THEN
        RAISE EXCEPTION 'Klingon language does not exist';
    END IF;

    new_film_id := (SELECT COALESCE(MAX(film_id), 0) + 1 FROM film);

    INSERT INTO film (
        film_id,
        title,
        description,
        release_year,
        language_id,
        rental_duration,
        rental_rate,
        replacement_cost,
        last_update
    ) VALUES (
        new_film_id,
        movie_title,
        'No description available',
        EXTRACT(YEAR FROM NOW()),
        klingon_language_id,
        3,
        4.99,
        19.99,
        NOW()
    );

    RAISE NOTICE 'Film % added with id %', movie_title, new_film_id;
END; $$
LANGUAGE plpgsql;


--if Klingon languale has not yet added
INSERT INTO language (name, last_update)
VALUES ('Klingon', NOW());
SELECT new_movie('Klingon Movie');

select * from language;

select * from film where title = 'Klingon Movie';







