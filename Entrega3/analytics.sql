/* OLAP QUERIES */
    /* olap 1*/

    SELECT dia_semana, concelho, SUM ( unidades ) AS Vendido
    FROM Vendas
    WHERE instante BETWEEN datas
    GROUP BY
    GROUPING SETS ( (dia_semana), (concelho) , ( ) )

    /* olap 2*/

    SELECT dia_semana, distrito, concelho, categoria, SUM ( unidades ) AS Vendido
    FROM Vendas
    SLICE distrito = "Lisboa"
    GROUP BY
    GROUPING SETS ( (concelho), (categoria) , (dia_semana), () )

/* INDICES */

/* 7.1 */

CREATE UNIQUE INDEX RP
USING HASH
on Reponsavel_por (nome_cat);

/* 7.2 */

CREATE UNIQUE INDEX P
USING BTREE
on Produto (desc);