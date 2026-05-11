-- clientes (cliente_id, nome, email, cidade, estado, data_cadastro)
-- produtos (produto_id, nome, categoria, genero, preco, custo)
-- pedidos (pedido_id, cliente_id, data_pedido, status, canal)
-- itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
-- devolucoes (devolucao_id, pedido_id, produto_id, data_devolucao, motivo)

-- Exercício 1 (fácil)
-- Liste todos os produtos cujo preço está acima da média de preços da sua categoria. Mostre nome do produto, categoria, preço e preço médio da categoria. 
-- (Dica: você vai precisar da média por categoria, não a média geral. Pode usar subquery correlacionada ou CTE — tente a CTE para praticar.)

WITH media_categoria AS (
    SELECT categoria, AVG(preco) AS preco_medio_categoria
    FROM produtos
    GROUP BY categoria
)
SELECT 
    pr.nome,
    pr.categoria,
    pr.preco,
    mc.preco_medio_categoria
FROM produtos pr 
LEFT JOIN media_categoria mc ON pr.categoria = mc.categoria
WHERE pr.preco > mc.preco_medio_categoria
ORDER BY pr.categoria, pr.preco DESC;

-- Exercício 2 (intermediário)
-- Liste os clientes que fizeram mais pedidos que a média de pedidos por cliente. Mostre nome do cliente, quantidade de pedidos dele, e a média geral. 
-- (Dica: você vai precisar primeiro contar pedidos por cliente, depois calcular a média dessas contagens. Duas etapas → CTE encaixa bem.)

WITH pedidos_por_cliente AS (
    SELECT cliente_id, COUNT(pedido_id) AS qtd_pedidos
    FROM pedidos
    GROUP BY cliente_id
),
media_geral AS (
    SELECT AVG(qtd_pedidos) AS media
    FROM pedidos_por_cliente
)
SELECT 
    c.nome,
    ppc.qtd_pedidos,
    mg.media AS media_geral
FROM clientes c
INNER JOIN pedidos_por_cliente ppc ON c.cliente_id = ppc.cliente_id
CROSS JOIN media_geral mg
WHERE ppc.qtd_pedidos > mg.media
ORDER BY ppc.qtd_pedidos DESC;


-- Exercício 3 (intermediário)
-- Usando CTE, calcule a receita total de cada cliente considerando pedidos entregues, e liste os top 10 clientes por receita. Mostre nome, quantidade de pedidos e receita total. 
-- Inclua clientes mesmo que tenham comprado pouco — mas apenas os que compraram algo.

WITH receita_cliente AS (
    SELECT 
        p.cliente_id,
        COUNT(DISTINCT p.pedido_id) AS qtd_pedidos,
        SUM(ip.quantidade * ip.preco_unitario) AS receita_total
    FROM pedidos p 
    INNER JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id 
    WHERE p.status = 'Entregue'
    GROUP BY p.cliente_id
)
SELECT
    c.nome, 
    rc.qtd_pedidos, 
    rc.receita_total
FROM clientes c
INNER JOIN receita_cliente rc ON rc.cliente_id = c.cliente_id
ORDER BY receita_total DESC 
LIMIT 10;

-- Exercício 4 (difícil)
-- Para cada categoria, calcule a participação percentual dela na receita total da empresa (considerando pedidos entregues). Ordene da maior participação para a menor. 
-- Mostre categoria, receita da categoria e participação (em %). (Dica: você precisa de duas coisas — receita por categoria E receita total geral. 
--Pense em como usar uma CTE para o total geral e referenciar ela depois.)



-- Exercício 5 (difícil — refazer o Exercício 5 do Dia 1 com CTEs)
-- Usando CTEs, refaça o exercício do Dia 1: liste as categorias que tiveram receita total acima de R$ 50.000 considerando apenas pedidos 'Entregue',
--  E ao mesmo tempo tiveram pelo menos uma devolução. Mostre categoria, receita total e quantidade de devoluções. 
-- Compare sua nova versão com a do dia anterior.