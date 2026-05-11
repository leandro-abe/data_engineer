# Dia 1 — SELECT, JOIN e GROUP BY

## Schema usado
- clientes (cliente_id, nome, email, cidade, estado, data_cadastro)
- produtos (produto_id, nome, categoria, genero, preco, custo)
- pedidos (pedido_id, cliente_id, data_pedido, status, canal)
- itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
- devolucoes (devolucao_id, pedido_id, produto_id, data_devolucao, motivo)

## Conceitos-chave

### Ordem de execução do SQL
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

Por isso:
- Não dá para usar alias do SELECT no WHERE (WHERE roda antes do SELECT)
- Dá para usar alias no ORDER BY (ORDER BY roda depois)
- PostgreSQL não aceita alias no HAVING (MySQL aceita)

### Tipos de JOIN
- INNER JOIN: só linhas que casam dos dois lados
- LEFT JOIN: todas da esquerda + match da direita (NULL onde não casa)
- RIGHT JOIN: o inverso (evitar, prefira LEFT)
- FULL JOIN: tudo dos dois lados
- CROSS JOIN: produto cartesiano (cuidado com explosão)

### Armadilha clássica: filtro em LEFT JOIN
- ON = condição de junção (linha sobrevive como NULL se não casar)
- WHERE = filtro pós-junção (linha com NULL é descartada)
- Filtro sobre tabela direita no WHERE transforma LEFT em INNER

### GROUP BY
- Toda coluna no SELECT precisa estar no GROUP BY ou em função de agregação
- Agrupar por PK + colunas descritivas (nunca só por nome — risco de duplicidade)

### WHERE vs HAVING
- WHERE filtra linhas antes da agregação
- HAVING filtra grupos depois da agregação
- Para condições sobre COUNT/SUM/AVG, sempre HAVING

### COUNT(*) vs COUNT(coluna)
- COUNT(*) conta todas as linhas
- COUNT(coluna) ignora NULLs
- Crítico em LEFT JOIN: use COUNT(coluna_direita) para contar 0 corretamente

### Agregações e NULL
- COUNT retorna 0 quando vazio
- SUM, AVG, MAX, MIN retornam NULL quando vazio (use COALESCE)

### Bug crítico: JOIN entre tabelas-filhas duplica linhas
Quando duas tabelas-filhas (ex: itens_pedido e devolucoes) compartilham a mesma chave-pai (pedido_id), juntá-las diretamente multiplica linhas e infla agregações. Solução: agregar separadamente cada filha e juntar os resultados (subquery ou CTE).

## Lições do dia
1. Sempre prefixar colunas com alias da tabela
2. Sempre usar ; no fim das queries
3. ORDER BY precisa de DESC explícito para decrescente
4. Operações dentro de AVG/SUM, não fora
5. Validar JOINs com COUNT(*) antes de SUMAR