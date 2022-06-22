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
				NEW.categoria = super_categoria
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
		IF	(SELECT count(categoria) AS nr_col FROM categorias) > 0 THEN
			RAISE   EXCEPTION	'Error';
		END IF;
		RETURN categorias;
END;
$$ LANGUAGE plpgsql;

/*RI-4*/
CREATE OR REPLACE FUNCTION	chk_uni_number_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		IF NEW.evento_reposicao.unidades > (SELECT planograma.unidades FROM NEW.evento_reposicao INNER JOIN planograma ON
		planograma.num_serie = NEW.evento_reposicao.num_serie AND planograma.ean = NEW.evento_reposicao.ean AND
		planograma.nro = NEW.evento_reposicao.nro AND planograma.fabricante = NEW.evento_reposicao.fabricante) THEN
			RAISE   EXCEPTION	'Error';
		END IF;
		RETURN A;
END;
$$	LANGUAGE plpgsql;


/*RI-5*/
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
				categoria = prateleira.nome
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
		IF NEW.produto.nome NOT IN (SELECT categoria FROM categorias) THEN
			RAISE   EXCEPTION	'Error';
		END IF;
		RETURN categorias;
END;
$$	LANGUAGE plpgsql;