/* OLAP QUERIES */
/* olap 1*/

SELECT dia_semana, concelho, SUM ( unidades ) AS Vendido
FROM Vendas
WHERE Vendas.dia_mes BETWEEN '26' AND '28' AND Vendas.mes BETWEEN '07' AND '09' AND Vendas.ano BETWEEN '2020' AND '2022'
GROUP BY
CUBE ((dia_semana), (concelho));

/* olap 2*/

SELECT dia_semana, concelho, cat, SUM ( unidades ) AS Vendido
FROM Vendas
WHERE Vendas.distrito = 'lisboa'
GROUP BY
CUBE ((concelho), (cat) , (dia_semana));

/* INDICES */

/* 7.1 */

DROP INDEX IF EXISTS RPP;

CREATE INDEX RPP
on responsavel_por
USING HASH(nome_cat);

/* 7.2 */

DROP INDEX IF EXISTS P;

CREATE INDEX P
on Produto
USING BTREE(descr);