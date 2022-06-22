/* OLAP QUERIES */
/* olap 1*/

SELECT dia_semana, concelho, SUM ( unidades ) AS Vendido
FROM Vendas
WHERE instante BETWEEN "31/09/2021" AND "17/06/2022"
GROUP BY
/*GROUPING SETS ( (dia_semana), (concelho) , () )*/
CUBE ((dia_semana), (concelho));

/* olap 2*/

SELECT dia_semana, distrito, concelho, categoria, SUM ( unidades ) AS Vendido
FROM Vendas
WHERE distrito = "Lisboa"
GROUP BY
/*GROUPING SETS ( (concelho), (categoria) , (dia_semana), () )*/
CUBE ((concelho), (categoria) , (dia_semana));

/* INDICES */

/* 7.1 */

CREATE INDEX RPP
on responsavel_por
USING HASH(nome_cat);

/* 7.2 */

CREATE INDEX P
on Produto
USING BTREE(descr);