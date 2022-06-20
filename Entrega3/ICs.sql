(RI-1) Uma Categoria não pode estar contida em si própria

/* RECURSIVO */
RI-1
CREATE OR REPLACE FUNCTION	chk_cat_names_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		WITH RECURSIVE categorias AS (
			SELECT
				categoria,
				super_categoria
			FROM
				tem_outra
			WHERE
				categoria = super_categoria
			UNION
				SELECT
					c.categoria,
					c.super_categoria
				FROM
					tem_outra c
				INNER JOIN categorias cat ON cat.categoria = c.super_categoria
		) SELECT
			*
		FROM
			categorias;	
		AS
			final
		IF	(SELECT count(*) AS nr_col FROM final) > 0 THEN
			RAISE   EXCEPTION	'Error'
		END IF;
		RETURN categorias;
END;
$$	

/* PRIMERIO IF USAR NATURAL JOIN */

(RI-4) O número de unidades repostas num Evento de Reposição não pode exceder o número de
unidades especificado no Planograma
RI-4
CREATE OR REPLACE FUNCTION	chk_uni_number_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		IF (SELECT num_serie, unidades AS uni FROM evento_reposicao) NATURAL JOIN planograma AS A THEN
            IF A.uni > A.unidades
				RAISE   EXCEPTION	'Error'
            END IF;
		END IF;	
		RETURN A;
END;
$$	

(RI-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das
Categorias desse produto
RI-5
CREATE OR REPLACE FUNCTION	chk_cat_names_proc()	
RETURNS TRIGGER AS
$$
BEGIN	
		IF	prateleria.nome != (SELECT cat FROM Produto WHERE Produto.ean IN evento_reposicao) AS ProdCat THEN
			WITH RECURSIVE categorias AS (
				SELECT
					categoria,
					super_categoria
				FROM
					tem_outra
				WHERE
					categoria = prateleria.nome
				UNION
					SELECT
						c.categoria,
						c.super_categoria
					FROM
						tem_outra c
					INNER JOIN categorias cat ON cat.categoria = c.super_categoria
			) SELECT
				*
			FROM
				categorias;	
			AS
				final
			IF	(SELECT count(*) AS nr_col FROM final)  == 0 THEN
				RAISE   EXCEPTION	'Error'
			END IF;
		END IF;	
		RETURN categorias;
END;
$$	