CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) AS
SELECT P.ean, P.cat, extract(YEAR FROM ER.instante), extract(QUARTER FROM ER.instante), extract(MONTH FROM ER.instante),
extract(DAY FROM ER.instante), extract(DOW FROM ER.instante), distrito,
concelho, ER.unidades 
FROM produto P
NATURAL JOIN evento_reposicao ER
NATURAL JOIN IVM I
NATURAL JOIN instalada_em
INNER JOIN ponto_de_retalho
ON instalada_em.local = ponto_de_retalho.nome
GROUP BY P.ean;