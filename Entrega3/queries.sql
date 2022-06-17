SELECT name             /*1*/
FROM (
    SELECT name , COUNT(tin) AS count
    FROM retalhista NATURAL JOIN responsavel_por
    GROUP BY tin
) AS a
WHERE count = max(a.count);


SELECT name             /*2*/
FROM ((
    SELECT tin
    FROM responsavel_por NATURAL JOIN categoria_simples
    GROUP BY tin)
    NATURAL JOIN retalhista
);


SELECT ean FROM product  /*3*/
WHERE ean NOT IN evento_reposicao;


SELECT ean             /*4*/
FROM (
    SELECT COUNT(tin) AS count, ean
    FROM evento_reposicao
    GROUP BY ean;
)
WHERE count = 1;