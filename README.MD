# Análise Customer Clientes e Estratégica de Vendas — Banco de Dados Sakila"

##  Abordagem e Estrutura do Repositório

Para responder a este desafio, a análise foi estruturada de forma progressiva, partindo de agregações fundamentais até consultas avançadas com **CTEs** e **Window Functions**.

* **Foco do README:** Apresentação dos resultados, gráficos mentais e recomendações de negócio geradas por cada consulta.
* **Códigos Completos:** Os scripts `.sql` comentados passo a passo estão organizados na pasta `/Sakila` para rápida consulta e auditoria.

---


## 1º Pergunta: Distribuição Geográfica e Status da Base de Clientes (Por País)
* COntexto e objetivo do negócio

> Mapear a concentração geográfica dos clientes da rede de locadoras e avaliar o estado de atividade (active) da base em cada país. Esta análise é essencial para estratégias de CRM, campanhas direcionadas por região e identificação de mercados-chave com maior volume de consumidores.

```sql
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
```

### Resultado:

| country | qtd_clientes | cliente_ativo | clientes_inativos |
| :--- | :--- | :--- | :--- |
| **India** | 60 | 57 | 3 |
| **China** | 53 | 50 | 3 |
| **United States** | 36 | 36 | 0 |
| **Japan** | 31 | 31 | 0 |
| **Mexico** | 30 | 29 | 1 |
| **Brazil** | 28 | 28 | 0 |
| **Russian Federation** | 28 | 27 | 1 |
| **Philippines** | 20 | 20 | 0 |

### Insights Executivos e Leitura de Negócio
**Concentração Asiática** Os dois maiores mercados da rede em volume de clientes são a Índia (60 clientes) e a China (53 clientes).

**Saúde da Base**: A taxa de inatividade é extremamente baixa em praticamente todos os países de maior expressão (por exemplo, EUA, Japão e Brasil registam 0 clientes inativos), demonstrando uma retenção saudável na maioria das praças operacionais.

## 2º Pergunta: Ranking de Receita por Cliente (Top 15 Clientes VIPs)
* COntexto e objetivo do negócio

> Identificar os 15 clientes de maior valor financeiro (High-Value Customers) e analisar a frequência das suas transações. Em estratégias de CRM, mapear esta elite permite estruturar programas de fidelidade, ações de retenção preventiva e campanhas personalizadas para maximizar o Lifetime Value (LTV).

```sql
SELECT t1.first_name || ' ' || last_name AS cliente, -- juntando nomes
       ROUND(SUM(t2.amount), 2) AS receita_cliente, -- cálculo da receita
       COUNT(*) AS qtd_transacoes -- quantidade de transações
FROM customer AS t1
LEFT JOIN payment AS t2 -- join para interligar com a tabela de pagamentos
ON t1.customer_id = t2.customer_id
GROUP BY cliente
ORDER BY receita_cliente DESC
LIMIT 15
```

### Resultado:

| cliente | receita_cliente | qtd_transacoes |
| :--- | :--- | :--- |
| **KARL SEAL** | 221.55 | 45 |
| **ELEANOR HUNT** | 216.54 | 46 |
| **CLARA SHAW** | 195.58 | 42 |
| **MARION SNYDER** | 194.61 | 39 |
| **RHONDA KENNEDY** | 194.61 | 39 |
| **TOMMY COLLAZO** | 186.62 | 38 |
| **WESLEY BULL** | 177.60 | 40 |
| **TIM CARY** | 175.61 | 39 |
| **MARCIA DEAN** | 175.58 | 42 |
| **ANA BRADLEY** | 174.66 | 34 |
| **JUNE CARROLL** | 173.63 | 37 |
| **LENA JENSEN** | 170.67 | 33 |
| **DIANE COLLINS** | 169.65 | 35 |
| **ARNOLD HAVENS** | 167.67 | 33 |
| **CURTIS IRBY** | 167.62 | 38 |

### Insights Executivos e Leitura de Negócio
**Melhores clientes**: Karl Seal e Eleanor Hunt possui as melhores receitas de todos os clientes, e também mais transações, com isso, vale a pena investir em um programa de recompensa, para reter mais ainda os melhores.

**Receita x Quantidade**: Marcia Dean(9º) possui quase a mesma quantidade de transação do Karl Seal(1º), mas a receita bem abaixo, isso significa que os produtos não possuem os mesmos valores, entender o motivo do que falta para Marcia adquirir produtos mais rentáveis.

## 3º Pergunta: Panorama Financeiro e Comportamental por Cliente (Ticket Médio e Volume de Gastos)
* COntexto e objetivo do negócio

> Analisar o perfil financeiro detalhado de cada consumidor da base, medindo individualmente o volume de transações (qtd_transacoes), a receita acumulada (receita_geral) e o valor médio gasto por cada aluguer (ticket_medio). Esta visão macro permite à equipa de CRM segmentar os utilizadores não apenas pelo total gasto, mas pelo comportamento de compra por transação.

```sql
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
```

### Resultado:

| customer_id | cliente | qtd_transacoes | média_geral | receita_geral | ticket_medio |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **526** | KARL SEAL | 45 | 0.20 | 221.55 | 4.92 |
| **148** | ELEANOR HUNT | 46 | 0.21 | 216.54 | 4.71 |
| **144** | CLARA SHAW | 42 | 0.21 | 195.58 | 4.66 |
| **137** | RHONDA KENNEDY | 39 | 0.20 | 194.61 | 4.99 |
| **178** | MARION SNYDER | 39 | 0.20 | 194.61 | 4.99 |
| **459** | TOMMY COLLAZO | 38 | 0.20 | 186.62 | 4.91 |
| **469** | WESLEY BULL | 40 | 0.23 | 177.60 | 4.44 |
| **468** | TIM CARY | 39 | 0.22 | 175.61 | 4.50 |
| **236** | MARCIA DEAN | 42 | 0.24 | 175.58 | 4.18 |
| **181** | ANA BRADLEY | 34 | 0.19 | 174.66 | 5.14 |

### Insights Executivos e Leitura de Negócio
**Consistência do Ticket Médio**: Independentemente do volume total de transações, o custo médio por aluguer (ticket_medio) para os principais clientes mantém-se estável num intervalo estreito entre $4,18 e $5,14, indicando uma tabela de preços uniforme sem grandes distorções promocionais.

**Relação Frequência vs. Receita**: Clientes no topo como Karl Seal e Eleanor Hunt aliam alta frequência (45 e 46 transações respetivamente) a um ticket médio saudável (~$4,80), impulsionando a sua liderança absoluta no acumulado de receita geral

## 4º Pergunta: Análise de Procura por Categoria de Filme (Volume e Engajamento da Base)
* COntexto e objetivo do negócio

> Mapear quais são os géneros cinematográficos com maior volume de saídas e maior amplitude de clientes na rede. Esta visão apoia diretamente a equipa de compras e marketing a entender onde concentrar o investimento em novos títulos e quais categorias movimentam mais a base de consumidores.

```sql
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
```

### Resultado:

| categoria | qtd_locacoes | clientes_distintos_envolvidos |
| :--- | :--- | :--- |
| **Sports** | 1179 | 519 |
| **Animation** | 1166 | 500 |
| **Action** | 1112 | 510 |
| **Sci-Fi** | 1101 | 507 |
| **Family** | 1096 | 501 |
| **Drama** | 1060 | 501 |
| **Documentary** | 1050 | 483 |
| **Foreign** | 1033 | 493 |

### Insights Executivos e Leitura de Negócio
**Liderança Desportiva e de Animação**: Sports (1.179 locações) e Animation (1.166 locações) destacam-se como os géneros mais populares da rede, movimentando mais de 500 clientes cada um.

**Demanda Homogénea no Topo**: As principais categorias (Sports, Animation, Action, Sci-Fi e Family) apresentam uma base de consumo muito equilibrada e massiva, o que sugere um catálogo transversal que agrada a diferentes perfis da base ativa.

## 5º Pergunta: Cliente Número 1 em Receita por País (Window Function com ROW_NUMBER)
* COntexto e objetivo do negócio

> Identificar o cliente de maior receita individual dentro de cada país onde a base atua, permitindo que a área de CRM e marketing crie ações regionais, programas de reconhecimento local e análises de concentração de valor por mercado.

```sql
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
```

### Resultado:

| cliente | receita | país | ranking_pais |
| :--- | :--- | :--- | :--- |
| **KARL SEAL** | 221.55 | United States | 1 |
| **ELEANOR HUNT** | 216.54 | Runion | 1 |
| **CLARA SHAW** | 195.58 | Belarus | 1 |
| **MARION SNYDER** | 194.61 | Brazil | 1 |
| **RHONDA KENNEDY** | 194.61 | Netherlands | 1 |
| **TOMMY COLLAZO** | 186.62 | Iran | 1 |
| **WESLEY BULL** | 177.60 | Spain | 1 |
| **TIM CARY** | 175.61 | India | 1 |
| **MARCIA DEAN** | 175.58 | Philippines | 1 |
| **JUNE CARROLL** | 173.63 | Algeria | 1 |

### Insights Executivos e Leitura de Negócio
**Destaques Globais**: Os maiores clientes de cada país já figuram entre os maiores faturamentos absolutos da rede — como Karl Seal nos Estados Unidos ($221,55), Eleanor Hunt em Reunion ($216,54) e Marion Snyder no Brasil ($194,61).

**Contraste entre Volume de Base e Topo de Receita**: Mesmo em mercados com grande volume de clientes como Índia e China, o líder local fatura na casa de $175,61 (Tim Cary) e $159,68 (Guy Brownlee), mostrando que ter mais clientes num país não significa automaticamente que o campeão local tenha o maior gasto individual da rede.