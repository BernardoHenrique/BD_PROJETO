CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) AS
SELECT P.ean, P.cat, extract(ano FROM ER.instante), extract(trimestre FROM ER.instante), extract(mes FROM ER.instante),
extract(dia_mes FROM ER.instante), extract(dia_semana FROM ER.instante),extract(distrito FROM L.local),
extract(concelho FROM L.local), ER.unidades 
FROM produto P
FULL JOIN categoria C
ON  P.cat = C
FULL JOIN evento_reposicao ER
ON  P.ean = ER.ean
FULL JOIN( 
    SELECT num_serie, local
    FROM instalada_em 
    NATURAL JOIN evento_reposicao) AS L
ON  L.num_serie = ER.num_serie
GROUP BY P.ean;