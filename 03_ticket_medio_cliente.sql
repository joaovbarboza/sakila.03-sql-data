-- Qual é a média geral de gastos, o volume total de pagamentos 
-- e o ticket médio por transação de cada cliente na nossa base?

-- Customer > Payment

SELECT t1.customer_id,
       t1.first_name || ' ' || t1.last_name AS cliente, -- juntei o nome do cliente
       COUNT(*) AS qtd_transacoes, -- total de transações
       ROUND(COUNT(*) / SUM(t2.amount), 2) AS média_geral, -- cálculo da média geral
       ROUND(SUM(t2.amount), 2) AS receita_geral, -- cálculo da receita total
       ROUND(AVG(t2.amount), 2) as ticket_medio -- cálculo ticket médio
FROM Customer AS t1
LEFT JOIN payment AS t2 -- join para interligar com a taabela de pagamentos
ON t1.customer_id = t2.customer_id

GROUP BY t1.customer_id 

ORDER BY receita_geral DESC