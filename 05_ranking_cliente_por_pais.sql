-- Quem é o cliente número 1 (o maior comprador) de cada país em termos de receita total gerada?
-- Payment > Customer > Address > city > Country

WITH tab_sumario AS (
SELECT *
FROM Payment AS t1
LEFT JOIN Customer AS t2 -- join com a tabela de clientes
ON t1.customer_id = t2.customer_id
JOIN address AS t3 -- join com a tabela endereço
ON t2.address_id = t3.address_id
JOIN city AS t4 -- join com a tabela cidade
ON t3.city_id = t4.city_id
JOIN country AS t5 -- join com a tabela país
ON t4.country_id = t5.country_id
),

tab_ranking AS (
SELECT first_name || ' ' || last_name  AS cliente, -- nome completo cliente
       ROUND(SUM(amount), 2) AS receita, -- cálculo da receita total
       country AS país,
       ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(amount) DESC) AS ranking_pais -- ranking dos melhores por país
FROM tab_sumario

GROUP BY customer_id -- agrupando por clientes

ORDER BY receita DESC
)

SELECT *
FROM tab_ranking
WHERE ranking_pais = 1 -- filtrando apenas os melhores por país