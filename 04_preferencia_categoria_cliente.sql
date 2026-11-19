-- Quais são as categorias de filmes preferidas pelos nossos clientes VIPs 
-- e onde a locadora concentra o maior volume de aluguel por género.
-- Customer > rental > inventory > film_category > category

WITH tab_sumario AS (
SELECT *
FROM Customer AS t1
LEFT JOIN rental AS t2 -- join para interligar com a tabela locacoes
ON t1.customer_id = t2.customer_id
JOIN inventory AS t3 -- join com a tabela inventário
ON t2.inventory_id = t3.inventory_id
JOIN film_category AS t4 -- join com a tabela dos filmes
ON t3.film_id = t4.film_id
JOIN category AS t5 -- join com a tabela de categoria
ON t4.category_id = t5.category_id
)

SELECT name AS categoria,
       COUNT(rental_id) AS qtd_locacoes, -- total de locacoes
       COUNT(DISTINCT customer_id) AS clientes_distintos_envolvidos 
FROM tab_sumario

GROUP BY categoria

ORDER BY qtd_locacoes DESC