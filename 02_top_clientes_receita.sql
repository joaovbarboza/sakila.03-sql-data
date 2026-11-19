-- Quem são os 15 clientes que mais geram receita para a locadora e 
-- qual é o volume de pagamentos (transações) de cada um deles
-- Customer > payment

SELECT t1.customer_id,
       t1.first_name || ' ' || last_name AS cliente, -- juntando nomes
       ROUND(SUM(t2.amount), 2) AS receita_cliente, -- cálculo da receita
       COUNT(*) AS qtd_transacoes -- quantidade de transações
FROM customer AS t1
LEFT JOIN payment AS t2 -- join para interligar com a tabela de pagamentos
ON t1.customer_id = t2.customer_id

GROUP BY t1.customer_id

ORDER BY receita_cliente DESC

LIMIT 15