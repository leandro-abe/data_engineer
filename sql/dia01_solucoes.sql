-- =====================================================
-- Dia 1 — Exercícios resolvidos
-- =====================================================

-- Exercício 1: Camisetas masculinas ordenadas por preço decrescente
SELECT nome, preco, custo
FROM produtos
WHERE categoria = 'Camiseta' AND genero = 'Masculino'
ORDER BY preco DESC;

-- Exercício 2: Quantidade de pedidos por cliente (incluindo zero)
SELECT 
    c.nome, 
    COUNT(p.pedido_id) AS qtd_pedidos
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.cliente_id
GROUP BY c.cliente_id, c.nome
ORDER BY qtd_pedidos DESC;

-- Exercício 3: Ticket médio por categoria (pedidos entregues)
SELECT 
    pr.categoria, 
    AVG(ip.preco_unitario * ip.quantidade) AS ticket_medio
FROM produtos pr 
INNER JOIN itens_pedido ip ON pr.produto_id = ip.produto_id
INNER JOIN pedidos p ON ip.pedido_id = p.pedido_id
WHERE p.status = 'Entregue'
GROUP BY pr.categoria 
ORDER BY ticket_medio DESC;

-- Exercício 4: Clientes que compraram em mais de um canal
SELECT 
    c.nome, 
    COUNT(DISTINCT p.canal) AS qtd_canais
FROM clientes c 
INNER JOIN pedidos p ON p.cliente_id = c.cliente_id
WHERE p.status = 'Entregue'
GROUP BY c.cliente_id, c.nome
HAVING COUNT(DISTINCT p.canal) > 1
ORDER BY qtd_canais DESC;

-- Exercício 5: Categorias com receita > 50k E pelo menos uma devolução
-- IMPORTANTE: agregar devoluções em subquery para evitar duplicação
SELECT 
    pr.categoria,
    SUM(ip.preco_unitario * ip.quantidade) AS receita_total,
    dev.qtd_devolucoes
FROM produtos pr
INNER JOIN itens_pedido ip ON pr.produto_id = ip.produto_id
INNER JOIN pedidos p ON p.pedido_id = ip.pedido_id
INNER JOIN (
    SELECT pr2.categoria, COUNT(*) AS qtd_devolucoes
    FROM devolucoes d
    INNER JOIN produtos pr2 ON pr2.produto_id = d.produto_id
    GROUP BY pr2.categoria
) dev ON dev.categoria = pr.categoria
WHERE p.status = 'Entregue'
GROUP BY pr.categoria, dev.qtd_devolucoes
HAVING SUM(ip.preco_unitario * ip.quantidade) > 50000
ORDER BY receita_total DESC;