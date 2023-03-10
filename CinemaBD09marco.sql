-- DELIMITER é executado e finalizado quando inicia-se com os sinais usados e 
-- encerrado com os sinais utilizados também
-- ver && na linha 11, encerrando o delimiter
DELIMITER &&
CREATE PROCEDURE nomeFilme(varF int)
	begin
		select concat('Nome', titulo)
        from filme
        where idfilme = varF;
	end;
&&
DELIMITER ;

-- Chamar procedure
CALL nomeFilme(11);
CALL nomeFilme(15);
CALL nomeFilme(13);

-- Excluindo procedures. Dropa, altera e depois cria de novo:
DROP PROCEDURE nomeFilme;


-- Atividade 2:
-- Acesse informações das sessões que estão ocorrendo em determinada sala.
-- Crie uma stored procedure para esse acesso.
-- Teste e verifique se a stored procedure funciona.
DELIMITER $$
CREATE PROCEDURE sessaoSala(sala int)
	begin
		select sala_idsala, filme_idFilme, dataHora as 'Sessões nesta Sala:'
        from sessao se
        inner join filme fi
        on se.filme_idFilme = fi.idFilme
        where sala_idsala = sala;
    end;
$$
DELIMITER ;

DROP PROCEDURE sessaoSala;

CALL sessaoSala(51);


-- Atividade 3:
-- Acesse informações das sessões que estão ocorrendo para determinado filme, mostre além das informações
-- da tabela sessão o 'nome da sala e o nome do filme'. ** você utilizará inner join nessa procedure.

-- Precisou fazer 3 inner join para juntar as três tabelas
DELIMITER %% 
CREATE PROCEDURE sessaoFilme(varFilme int)
	begin
		select sala_idsala as 'Sala' , dataHora as 'Data e Hora', titulo as 'Sessões'
        from sessao se
		inner join filme fi
		on se.filme_idFilme = fi.idFilme
        inner join sala sa
        on sala_idsala = idsala
		where idFilme = varFilme;
    end;
%%
DELIMITER ;

DROP PROCEDURE sessaoFilme;
CALL sessaoFilme(10);



-- 4 fa uma stored procedure para obter Flmes de determinado gênero
-- que estão com sessões agendadas.
-- ver se esta certo
DELIMITER $$
CREATE PROCEDURE genFilme(gen varchar(60))
	begin
		SELECT titulo as 'Título', descricao as 'Gênero'
		from genero ge
		inner join filme fi
		on ge.filme_idFilme = fi.idFilme
		inner join sessao se
		on filme_idFilme = idFilme
		where ge.descricao = gen;
	end;
$$
DELIMITER ; 


-- 5. A) Crie uma procedure para inserir um gênero novo 
-- Gênero: Ficção e Infantil
DELIMITER %%
CREATE PROCEDURE insertGen(descri varchar(60))
	begin
		insert into cinema.genero (idgenero, descricao)
        values ((select MAX(gen.idgenero) + 1 from genero gen), descri);
    end;
%%
DELIMITER ;
-- PRECISA AUTOINCREMENTAR, então deve-se usar um MAX no id para que isso ocorra
-- O select no Value vai aumentar apenas um valor
DROP PROCEDURE insertGen;
CALL insertGen('Terror');


-- 5.B)Crie uma procedure para inserir um filme de sua preferência.
-- Filmes: O Dilema das Redes, 2hrs, documentário 
-- O Projeto Adam,1h46,ficção
 DELIMITER $$
 CREATE PROCEDURE insertFilme(id int, nome varchar(200), dur time, gen int)
	begin
		insert into cinema.filme (idFilme, titulo, duracao, genero_idgenero)
        values (id, nome, dur, gen);
    end;
 $$
 DELIMITER ; 
 
 CALL insertFilme(16, 'O Dilema das Redes', '2:00', 7);
 CALL insertFilme(17, 'O Projeto Adam', '1:46', 8);


-- 5. C)Utiliza um select simples com left e/ou right join
-- C.1-Exibir lista de filmes que não tem sessões agendadas.
SELECT * FROM filme as f
LEFT JOIN sessao AS s
ON f.idFilme = s.filme_idFilme
WHERE s.filme_idfilme is null;

-- C.2-Exibir gêneros que não tem filmes associados.
SELECT g.descricao, f.titulo, f.duracao FROM filme AS f
RIGHT JOIN genero AS g
ON g.idgenero = f.genero_idgenero
WHERE f.genero_idgenero IS NULL;

