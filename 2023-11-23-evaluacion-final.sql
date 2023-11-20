-- Evaluación final

/*
/*1- Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/


SELECT DISTINCT title
FROM film;



/*2- Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT title
FROM film
WHERE rating = "PG-13";


/*3- Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- poniendo entre %palabra%  > nos mustra si ésta se encuentra en cualquier sitio de descripción

/* 4- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT title
FROM film
WHERE length > 120;



/* 5- Recupera los nombres de todos los actores.*/

SELECT first_name AS nombre_actor, last_name As apellido_actor
FROM actor;



/* 6- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT first_name AS nombre_actor, last_name As apellido_actor
FROM actor
WHERE last_name LIKE "%Gibson%";



/* 7- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

			SELECT actor_id, first_name AS nombre_actor, last_name As apellido_actor
			FROM actor
			WHERE actor_id BETWEEN 10 AND 20;

-- QRY FINAL:

SELECT first_name AS nombre_actor, last_name As apellido_actor
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/* 8- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/


SELECT title, rating
FROM film
WHERE rating <> "R" AND rating <> "PG-13";


/* 9- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/


SELECT rating AS clasificacion, COUNT(title) AS numero_total_pelis
FROM film
GROUP BY rating;



/*10 -Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/

-- customer > rental 

SELECT c.customer_id AS id_cliente, c.first_name AS nombre_cliente, c.last_name AS apellido_cliente, COUNT(rental_id) AS total_alquileres
FROM customer as c
INNER JOIN rental as r ON c.customer_id = r.customer_id
GROUP BY c.customer_id ;



/* 11- Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.*/


/* la ruta:

	category - (category_id) - film_category
    film_category (film_id) - inventory
-- film (film_id) inventory -- puede saltarse uno? --
    inventory (inventory_id) - rental
    */


			SELECT c.name AS categoria, COUNT(r.rental_id) AS numero_peliculas_alquiladas
			FROM rental AS r
			INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
			INNER JOIN film AS f ON i.film_id = f.film_id
			INNER JOIN film_category AS fc ON f.film_id = fc.film_id
			INNER JOIN category AS c ON fc.category_id = c.category_id
			GROUP BY c.name;

-- QRY FINAL: 
SELECT c.name AS categoria, COUNT(r.rental_id) AS numero_peliculas_alquiladas
FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film_category AS fc ON i.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name;

/* 12 - Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.*/

SELECT * FROM film;

SELECT rating AS clasificacion, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;




/* 13 - Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/
-- film > (film_id) > film_actor (actor_id) > actor



SELECT a.first_name AS nombre_actor, a.last_name AS apellido_actor 
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
WHERE title = "Indian Love";



/* 14 - Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/


SELECT title, description
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';



/* 15 - Hay algún actor que no aparecen en ninguna película en la tabla film_actor.*/

			SELECT COUNT(actor_id)
			FROM actor;

			SELECT COUNT(distinct actor_id)
			FROM film_actor;

-- QRY FINAL:
SELECT a.actor_id, a.first_name as nombre_actor, a.last_name as apellido_actor
FROM actor as a
LEFT JOIN film_actor as fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

-- con left join mostramos todos los actores de la tabla actor y con fa.actor_id IS NULL ponemos la condicion que nos muestre los actores que no aparecen en la tabla film_actor
-- la respuesta es: no hay ningún actor que no aparezca en la tabla film_actor.


/* 16 - Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/


SELECT title AS Titulo, release_year AS Año_lanzamiento
FROM film
WHERE release_year BETWEEN 2005 AND 2010;



/* 17 - Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

			SELECT * FROM film;

			-- para visualizar la query con la columna categoria Family:
			SELECT c.name AS categoria, f.title AS titulo
			FROM film AS f
			INNER JOIN film_category AS fc ON f.film_id = fc.film_id
			INNER JOIN category AS c ON fc.category_id = c.category_id
			WHERE c.name = "Family";

-- QRY FINAL: 

SELECT f.title AS titulo
	FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = "Family";				

/* 18 - Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/

	SELECT * FROM film;


	SELECT title AS titulo
    FROM film
    WHERE rating = "R" AND length > 120;



/* 19 - Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/

SELECT * FROM category;

SELECT c.name AS categoria_pelicula, AVG(f.length) AS promedio_duracion
FROM category AS c
INNER JOIN film_category as fc ON c.category_id = fc.category_id
INNER JOIN film as f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;



/* 20 - Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/

SELECT * FROM film_actor;


SELECT a.first_name AS nombre_actor, a.last_name AS apellido_actor, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor as a
JOIN film_actor as fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id) >=5;


/* 21 - Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/

			-- para mirar cuantos días de alquiler ha estado cada pelicula:

			SELECT *, DATEDIFF(return_date, rental_date) AS dias_alquiler
			FROM rental;
            
            -- Peliculas alquiladas más de 5 días:
            SELECT *, DATEDIFF(return_date, rental_date) AS dias_alquiler
			FROM rental
            WHERE DATEDIFF(return_date, rental_date) > 5;

			-- rental > (inventory_id) > inventory > (film_id)film 
			SELECT * FROM film;

            -- sacamos aquellos film_id que cumplen la condición de haber sido alquilados más de 5 días

			SELECT  i.film_id, rental_id, DATEDIFF(return_date, rental_date) AS dias_alquiler
			FROM rental AS r
			INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
			GROUP BY i.film_id, r.rental_id, r.return_date, r.rental_date
			HAVING DATEDIFF(return_date, rental_date) > 5;


-- QRY FINAL: 

SELECT title
FROM film
WHERE film_id IN 
			(SELECT  i.film_id
			FROM rental AS r
			INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
			GROUP BY i.film_id, r.rental_id, r.return_date, r.rental_date
			HAVING DATEDIFF(return_date, rental_date) > 5);

 



/* 22 - Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

-- ruta: actor (actor_id) > film_actor (film_id) > film (film_id) > film_category (category_id) > category

			-- Necesito saber los actores que han actuado en la categoría horror

			-- 1. Identifico el id de la categoria Horror

			SELECT c.category_id 
			FROM category AS c
			WHERE c.name = "Horror";
            
            -- 2. Saco todos los actores que han participado en una peli de Horror (aquí un actor puede haber participado más de una vez)
            SELECT a.actor_id, a.first_name as nombre_actor, a.last_name as apellido_actor, c.category_id 
				FROM category AS c
            INNER JOIN film_category AS fc ON c.category_id = fc.category_id
            INNER JOIN film AS f ON fc.film_id = f.film_id
            INNER JOIN film_actor as fa ON fc.film_id = fa.film_id
            INNER JOIN actor as a ON fa.actor_id = a.actor_id
			WHERE c.name = "Horror";


		   -- 3. Saco los actor_id de la tabla film_actor que han actuado en pelis de horror    
			SELECT fa.actor_id
					FROM film_category AS fc
					INNER JOIN category AS c ON fc.category_id = c.category_id
					INNER JOIN film AS f ON fc.film_id = f.film_id
					INNER JOIN film_actor AS fa ON fc.film_id = fa.film_id
					WHERE c.name = "Horror"; 




-- 3. Subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" , buscando el id del actor
                
 
SELECT a.first_name AS nombre_actor, a.last_name AS apellido_actor, a.actor_id
			FROM actor AS a
			WHERE a.actor_id IN (
				SELECT fa.actor_id
				FROM film_category AS fc
				INNER JOIN category AS c ON fc.category_id = c.category_id
				INNER JOIN film AS f ON fc.film_id = f.film_id
				INNER JOIN film_actor AS fa ON fc.film_id = fa.film_id
				WHERE c.name = "Horror"
			); 
 
 -- 4: Excluir los actores que salen en Horror del resto de actores 
			   -- Convertimos la SQR en CTE             

				WITH actores_horror
				AS (
				SELECT a.first_name AS nombre_actor, a.last_name AS apellido_actor, a.actor_id
							FROM actor AS a
							WHERE a.actor_id IN (
								SELECT fa.actor_id
								FROM film_category AS fc
								INNER JOIN category AS c ON fc.category_id = c.category_id
								INNER JOIN film AS f ON fc.film_id = f.film_id
								INNER JOIN film_actor AS fa ON fc.film_id = fa.film_id
								WHERE c.name = "Horror"
							)
							)
				SELECT * 
					FROM actores_horror;
        
-- QRY FINAL:
     
	WITH actores_horror AS (
    SELECT a.actor_id
    FROM actor AS a
    WHERE a.actor_id IN (
        SELECT fa.actor_id
        FROM film_category AS fc
        INNER JOIN category AS c ON fc.category_id = c.category_id
        INNER JOIN film AS f ON fc.film_id = f.film_id
        INNER JOIN film_actor AS fa ON fc.film_id = fa.film_id
        WHERE c.name = 'Horror'
    )
)
SELECT a.first_name AS nombre_actor, a.last_name AS apellido_actor
FROM actor AS a
WHERE actor_id NOT IN (SELECT actor_id FROM actores_horror); -- si los id de actor no estan en actores_horror significa que no han acctiado en una peli de horror







/* 23 - BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.*/
-- film (film_id) > film_category (category_id) > category

SELECT *
FROM film;

SELECT f.title, c.name
	FROM film as f
INNER JOIN film_category as fc ON f.film_id = fc.film_id
INNER JOIN category as c ON fc.category_id = c.category_id
WHERE c.name = "Comedy" AND f.length > 180;








/* 24 - BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado junto
*/
-- self join? - una tabla que se une consigo misma
-- actor (actor_id) > film_actor (film_id) > film 

SELECT *
FROM film_actor;


-- 1 . combinacion de actores que han trabajado en las mismas peliculas_

			SELECT 	a1.first_name as nombre_actor_1,
					a1.last_name as apellido_actor_1, 	
					fa1.film_id,
					a2.first_name as nombre_actor_2,
					a2.last_name as apellido_actor_2, 	
					fa2.film_id
					
			FROM actor AS a1
			INNER JOIN film_actor as fa1 ON a1.actor_id = fa1.actor_id
			INNER JOIN film AS f1 ON fa1.film_id = f1.film_id

			INNER JOIN film_actor as fa2 ON f1.film_id = fa2.film_id
			INNER JOIN actor as a2 ON fa2.actor_id = a2.actor_id

			WHERE a1.actor_id < a2.actor_id;   -- < evitamos duplicados. solo tiene en cuenta la combinación donde el ID del primer actor es menor que el ID del segundo actor.



-- 2  Pares de actores que han coincidido en peliculas y Nº de peliculas en las que han actuado juntos 

			SELECT 	a1.first_name as nombre_actor_1,
					a1.last_name as apellido_actor_1, 	
					
					a2.first_name as nombre_actor_2,
					a2.last_name as apellido_actor_2, 	
					COUNT(DISTINCT fa2.film_id) AS "Nº peliculas dónde han trabajado junstos"
					
			FROM actor AS a1
			INNER JOIN film_actor as fa1 ON a1.actor_id = fa1.actor_id
			INNER JOIN film AS f1 ON fa1.film_id = f1.film_id

			INNER JOIN film_actor as fa2 ON f1.film_id = fa2.film_id
			INNER JOIN actor as a2 ON fa2.actor_id = a2.actor_id
			GROUP BY    a1.actor_id, a2.actor_id
            HAVING nombre_actor_1 < nombre_actor_2; -- < evitamos duplicados. 
	










