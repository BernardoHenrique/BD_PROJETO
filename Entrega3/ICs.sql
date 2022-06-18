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

RI-4
CREATE OR REPLACE FUNCTION	chk_cat_names_proc()	
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