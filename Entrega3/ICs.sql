(RI-1) Uma Categoria não pode estar contida em si própria
RI-1
CREATE OR REPLACE FUNCTION	chk_cat_names_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		IF	tem_outra.super_categoria.name == tem_outra.categoria.name	THEN			
			RAISE	EXCEPTION	'Error'
		END IF;	
		RETURN tem_outra;
END;
$$	

(RI-4) O número de unidades repostas num Evento de Reposição não pode exceder o número de
unidades especificado no Planograma
RI-4
CREATE OR REPLACE FUNCTION	chk_uni_number_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		IF	evento_reposicao.num_serie == planograma.num_serie  THEN
            IF evento_reposicao.unidades > planograma.unidades 			
				RAISE   EXCEPTION	'Error'
            END IF;
		END IF;	
		RETURN evento_reposicao;
END;
$$	

(RI-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das
Categorias desse produto
RI-5
CREATE OR REPLACE FUNCTION	chk_cat_names_proc()	
RETURNS TRIGGER AS
$$
BEGIN			
		IF	evento_reposicao.ean == produto.ean  THEN
            IF evento_reposicao.unidades > planograma.unidades
				RAISE   EXCEPTION	'Error'
            END IF;
		END IF;	
		RETURN tem_outra;
END;
$$	