-- Qual é a distribuição geográfica da nossa base de clientes por país 
-- e quantos estão ativos versus inativos em cada região?
-- Customer > Address > city > country

WITH tab_country AS (
SELECT *
FROM customer AS t1
LEFT JOIN address AS t2 -- join para interligar com a tabela endereço
ON t1.address_id = t2.address_id
JOIN city AS t3 -- join para interligar com a tabela cidade
ON t2.city_id = t3.city_id
JOIN country AS t4 --join para interligar com a tabela país
ON t3.country_id = t4.country_id
)

SELECT country,
       COUNT(customer_id) AS qtd_clientes, -- cálculo quantidade total de clientes
       SUM(CASE WHEN active = 1 THEN 1 ELSE 0 END) AS cliente_ativo, -- separando e somando quem são ativos
       SUM(CASE WHEN active = 0 THEN 1 ELSE 0 END) AS clientes_inativos -- separando e somando quem são negativos
FROM tab_country

GROUP BY country

ORDER BY qtd_clientes DESC