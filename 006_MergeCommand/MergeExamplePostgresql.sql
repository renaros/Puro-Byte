/*
@en: 
Script developed by Renato Rossi in 10/27/2020
The objective with this script is to show an example of merge command in Postgresql.

@pt:
Script desenvolvido por Renato Rossi em 27/10/2020
O objetivo desse script é mostrar um exemplo do comando merge em Postgresql.
*/

--@en: Creating the target table
--@pt: Criando a tabela alvo (target)
CREATE TABLE mergeexampletarget (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(50),
	address VARCHAR(100),
	insert_date timestamp without time zone,
	update_date timestamp without time zone
);

--@en: Inserting 2 records into target table
--@pt: Inserindo 2 registros na tabela alvo
INSERT INTO mergeexampletarget (name, address, insert_date, update_date) VALUES ('Ana', 'Main Street', NOW(), NOW());
INSERT INTO mergeexampletarget (name, address, insert_date, update_date) VALUES ('John', 'Park Avenue', NOW(), NOW());

--@en: Checking the table
--@pt: Verificando a tabela
SELECT * FROM mergeexampletarget;

--@en: Creating a source table, that will have the same structure with different data
--@pt: Criando uma tabela de origem (source), que terá a mesma estrutura mas dados diferentes
CREATE TABLE mergeexamplesource (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(50),
	address VARCHAR(100),
	insert_date timestamp without time zone,
	update_date timestamp without time zone
);

--@en: Let's insert 3 records: 2 not existing in the target table and 1 exists with a different value
--@pt: Vamos inserir 3 registros: 2 não existem na tabela alvo e 1 existe mas com valores diferentes
INSERT INTO mergeexamplesource (name, address, insert_date, update_date) VALUES ('Ana', 'Main Street - New Address!!', NOW(), NOW());
INSERT INTO mergeexamplesource (name, address, insert_date, update_date) VALUES ('Brian', 'Different Street', NOW(), NOW());
INSERT INTO mergeexamplesource (name, address, insert_date, update_date) VALUES ('Paul', 'Somewhere', NOW(), NOW());

--@en: Checking the source table
--@pt: Verificando a tabela de origem
SELECT * FROM mergeexamplesource;

--@en: Let's do a full join to see all combinations
--@pt: Vamos fazer um full join para ver todas as combinações possíveis
SELECT *
FROM mergeexampletarget T
FULL JOIN mergeexamplesource S ON T.name = S.name;

--@en: As we can see, Ana has a match while John exists only in the target table
--     and Brian and Paul exists only in the source table.
--@pt: Como podemos observar, Ana tem uma correspondência enquanto John existe apenas na
--     tabela alvo, e Brian e Paul existem somente na tabela de origem

/* * * * MERGE COMMAND * * * */
BEGIN TRANSACTION;

--@en: When we have matching records, update the address with the source one
--@pt: Quando temos registros correspondentes, atualiza o endereço com a informação da origem
UPDATE mergeexampletarget T
SET address = S.address,
	update_date = NOW()
FROM mergeexamplesource S
WHERE T.name = S.name;

--@en: When the record exists on the source and not on the target, inserts the new row
--@pt: QUando um registro existe na origem e não existe na tabela alvo, insere o novo registro
INSERT INTO mergeexampletarget (name, address, insert_date, update_date)
	SELECT S.name, S.address, NOW(), NOW()
	FROM mergeexamplesource S
	WHERE NOT EXISTS (
		SELECT 1
		FROM mergeexampletarget
		WHERE name = S.name
	);

--@en: When the record exists only on the target, you might want to delete it to be similar to the source. If
--     that's your case, this is how you do it.
--@pt: Quando um registro existe somente na tabela alvo, você talvez necessite deletar para sua tabela alvo ficar igual
--     à origem. Se este é o seu caso, é assim que se pode executar.
DELETE FROM mergeexampletarget T
WHERE NOT EXISTS (
	SELECT 1
	FROM mergeexamplesource S
	WHERE T.name = S.name
);

END TRANSACTION; --COMMIT

--@en: Final result, note that the not corresponding item was deleted, the matching item was updated and 2 new records were inserted
--@pt: Resultado final, note que o registro que não tinha correspondência foi deletado, o que tinha 
--     foi atualizado e 2 novos registros foram inseridos
SELECT * FROM mergeexampletarget;
