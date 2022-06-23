SELECT name             /*1*/
FROM (
    SELECT name , COUNT(tin) AS count
    FROM retalhista NATURAL JOIN responsavel_por
    GROUP BY tin
) AS a
WHERE count >= ALL(SELECT COUNT(tin) AS count
    FROM retalhista NATURAL JOIN responsavel_por
    GROUP BY tin);

/* 2 */
SELECT DISTINCT name
FROM retalhista rd
WHERE NOT EXISTS(
    SELECT nome
    FROM categoria_simples
    EXCEPT
    SELECT nome_cat
    FROM (responsavel_por A JOIN retalhista r 
        on A.tin = r.tin) AC
    WHERE AC.name = rd.name    
);


SELECT ean FROM produto  /*3*/
WHERE ean NOT IN (SELECT ean FROM evento_reposicao);


SELECT ean             /*4*/
FROM (
    SELECT COUNT(tin) AS count, ean
    FROM evento_reposicao
    GROUP BY ean
) AS P
WHERE count = 1;