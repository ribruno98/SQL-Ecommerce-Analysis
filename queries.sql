-- =====================================
-- 1. Quais foram os produtos comprados por cada cliente?
-- =====================================

SELECT nome, produto_nome
FROM clientes c
INNER JOIN pedidos p
ON p.cliente_id = c.cliente_id
INNER JOIN produtos pr
ON pr.produto_id = p.produto_id;

-- 2.Que clientes nunca fizeram compras?

SELECT nome
FROM clientes c
LEFT JOIN pedidos p
ON p.cliente_id = c.cliente_id
WHERE p.cliente_id IS NULL;

-- 3.Quantos pedidos cada cliente realizou?

SELECT nome, COUNT(pedido_id) as quantidade_pedido
FROM clientes c
LEFT JOIN pedidos p
ON p.cliente_id = c.cliente_id
GROUP BY nome;

-- 4.Qual é o produto mais caro da loja?

SELECT produto_nome
FROM produtos
WHERE preco =
(
  SELECT MAX(preco)
  From produtos
);

-- 5.Qual é o preço médio dos produtos?

SELECT AVG(preco) as preco_medio
FROM produtos

-- 6.Quais os produtos com preço acima da média?

SELECT produto_nome
FROM produtos
Where preco >
(
  SELECT AVG(preco)
  FROM produtos
);

-- 7.Quais os clientes que compraram produtos acima da média de preço?

SELECT nome
FROM clientes c
INNER JOIN pedidos p
On p.cliente_id = c.cliente_id
INNER JOIN produtos pr
ON pr.produto_id = p.produto_id
Where preco >
(
  SELECT AVG(preco)
  FROM produtos
);

-- 8.Qual cliente gastou mais dinheiro?

SELECT nome
FROM pedidos p
INNER JOIN produtos pr
ON pr.produto_id = p.produto_id
INNER JOIN clientes c
ON c.cliente_id = p.cliente_id
GROUP BY nome
HAVING SUM(preco * quantidade) = 
(
  SELECT MAX(dinheiro_gasto)
  FROM (
    SELECT SUM(preco * quantidade) AS dinheiro_gasto
    FROM pedidos p2
    INNER JOIN produtos pr2 ON pr2.produto_id = p2.produto_id
    GROUP BY p2.cliente_id )
);

-- 9.Quanto cada cliente gastou no total?

SELECT nome, SUM(preco * quantidade) AS dinheiro_gasto
FROM pedidos p
INNER JOIN produtos pr
ON pr.produto_id = p.produto_id
INNER JOIN clientes c
ON c.cliente_id = p.cliente_id
GROUP BY nome;

-- 10.Quais clientes gastaram acima da média dos clientes?

SELECT nome, SUM(preco * quantidade) AS dinheiro_gasto
FROM pedidos p
INNER JOIN produtos pr
ON pr.produto_id = p.produto_id
INNER JOIN clientes c
ON c.cliente_id = p.cliente_id
GROUP BY nome
HAVING dinheiro_gasto >
(
  SELECT AVG(dinheiro_gasto)
  FROM (  SELECT SUM(preco * quantidade) AS dinheiro_gasto
    FROM pedidos p2
    INNER JOIN produtos pr2 ON pr2.produto_id = p2.produto_id
    GROUP BY p2.cliente_id )
);

-- 11.Qual categoria vendeu mais produtos?

SELECT categoria_nome, SUM(quantidade) as produto_vendido
FROM categorias c
INNER JOIN produtos p ON p.categoria_id = c.categoria_id
INNER JOIN pedidos pe ON pe.produto_id = p.produto_id
GROUP BY categoria_nome 
HAVING SUM(quantidade) =
(
  SELECT MAX(produto_vendido)
  FROM (
    SELECT SUM(quantidade) as produto_vendido
    FROM categorias c2
    INNER JOIN produtos p2 ON p2.categoria_id = c2.categoria_id
    INNER JOIN pedidos pe2 ON pe2.produto_id = p2.produto_id
    GROUP BY c2.categoria_id 
  ) 
);

-- 12.Qual categoria gerou mais faturação?

SELECT categoria_nome, SUM(quantidade * preco) as faturacao
FROM categorias c
INNER JOIN produtos p ON p.categoria_id = c.categoria_id
INNER JOIN pedidos pe ON pe.produto_id = p.produto_id
GROUP BY categoria_nome 
HAVING SUM(quantidade * preco) =
(
  SELECT MAX(faturacao)
  FROM (
    SELECT SUM(quantidade * preco) as faturacao
    FROM categorias c2
    INNER JOIN produtos p2 ON p2.categoria_id = c2.categoria_id
    INNER JOIN pedidos pe2 ON pe2.produto_id = p2.produto_id
    GROUP BY c2.categoria_id 
  ) 
