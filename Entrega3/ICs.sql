/*RI-1*/
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
			categorias	
		AS
			final
		IF	(SELECT count(*) AS nr_col FROM final) > 0 THEN
			RAISE   EXCEPTION	'Error'
		END IF;
		RETURN categorias;
END;
$$ LANGUAGE plpgsql;

/*RI-4*/
CREATE OR REPLACE FUNCTION	chk_uni_number_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		IF SELECT * FROM evento_reposicao.num_serie INNER JOIN planograma.num_serie THEN
            IF evento_reposicao.unidades > planograma.unidades
				RAISE   EXCEPTION	'Error'
            END IF;
		END IF;LANGUAGE plpgsql;	
		RETURN A;
END;
$$	LANGUAGE plpgsql;


/*RI-5*/
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
$$	LANGUAGE plpgsql;