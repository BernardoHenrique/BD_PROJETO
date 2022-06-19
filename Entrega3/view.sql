CREATE VIEW Vendas(ean, cat, ano, trimestre, dia_mes, dia_semana, distrito, concelho, unidades) AS
SELECT ean, cat, ano, trimestre, dia_mes, dia_semana, distrito, concelho, unidades 
FROM produto
NATURAL JOIN (
    SELECT cat FROM categoria
)
NATURAL JOIN(
    SELECT unidades, num_serie FROM evento_reposicao
)
NATURAL JOIN(
    SELECT ano, trimestre, dia_mes, dia_semana FROM
)
NATURAL JOIN(
    SELECT distrito, concelho FROM instalada_em
)

