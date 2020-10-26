/*
@en: 
Script developed by Renato Rossi in 10/22/2020
The objective with this script is to demonstrate the difference
between the Slowly Changing Dimension Types, and also how to
manipulate the data in a situation where we have to store a new
change in an existing record.
For this example we are updating an address from a client called Ana.
She was inserted in the system on 01/01/2020 and moved from Main Street 
to Another Street on 06/01/2020.

@pt:
Script desenvolvido por Renato Rossi em 22/10/2020
O objetivo desse script é demonstar a diferença entre os tipos de Slowly
Changing Dimensions, e também como manipular os dados em um contexto onde
temos que armazenar uma alteração em um registro existente.
Para esse exemplo estamos atualizando o endereço da cliente Ana.
Ela foi inserida no sistema em 01/01/2020 e se mudou da Main Street para o
endereço Another Street em 01/06/2020.

* * * SCD Type 1 | SCD Tipo 1 * * *
@en:
In this type we don't actually store historical information, when a new
status comes in, we simply update the old data with the new one.

@pt:
Nesse tipo não guardamos de fato uma informação histórica, quando um novo
status precisa ser inserido nós simplesmente atualizamos o registro.
*/
CREATE TABLE ExampleAddressSCD1 (
	ID SERIAL NOT NULL PRIMARY KEY,
	Customer VARCHAR(50), --@pt: Cliente
	Address VARCHAR(50), --@pt: Endereço
	UpdateDate DATE --@pt: Data de Atualizacao do registro
);

--@en: Inserting first record, when Ana registered herself on the system
--@pt: Inserindo o primeiro registro, quando a Ana se cadastrou no sistema
INSERT INTO ExampleAddressSCD1 (Customer, Address, UpdateDate)
	VALUES ('Ana', 'Main Street', '2020-01-01');
	
--@en: Checking to see how it looks like
--@pt: Verificando como estão os dados
SELECT * FROM ExampleAddressSCD1;

--@en: When we have a change, we simply update the information
--@pt: Quando temos uma alteração da informação, simplesmente atualizamos o registro
UPDATE ExampleAddressSCD1 
SET Address = 'Another Street', 
	UpdateDate = '2020-06-01' 
WHERE Customer = 'Ana';

--@en: Checking again to see how it looks like now
--@pt: Verificando novamente como estão os dados
SELECT * FROM ExampleAddressSCD1;

/*
* * * SCD Type 2 | SCD Tipo 2 * * *
@en:
In this type when a new status comes in we insert a new row, keeping the old
record in the table. You can put a flag to facilitate getting the current
record if you want.

@pt:
Nesse tipo quando temos um novo status um novo registro é inserido, mantendo
o registro antigo na tabela. Você pode colocar uma flag para facilitar retornar
a entrada mais nova.
*/
CREATE TABLE ExampleAddressSCD2 (
	ID SERIAL NOT NULL PRIMARY KEY,
	Customer VARCHAR(50), --@pt: Cliente
	Address VARCHAR(50), --@pt: Endereço
	UpdateDate DATE, --@pt: Data de Atualizacao do registro
	FlagCurrent BOOLEAN NOT NULL DEFAULT true --@pt: flag de registro atual
);

--@en: Inserting first record, when Ana registered herself on the system
--@pt: Inserindo o primeiro registro, quando a Ana se cadastrou no sistema
INSERT INTO ExampleAddressSCD2 (Customer, Address, UpdateDate, FlagCurrent)
	VALUES ('Ana', 'Main Street', '2020-01-01', true);
	
--@en: Checking to see how it looks like
--@pt: Verificando como estão os dados
SELECT * FROM ExampleAddressSCD2;

--@en: When we have a change, we simply add the information into the table
--     and update the flag on the old one
--@pt: Quando temos uma alteração da informação, simplesmente inserimos o registro
--     na tabela e atualizamos a flag do registro antigo
INSERT INTO ExampleAddressSCD2 (Customer, Address, UpdateDate, FlagCurrent)
	VALUES ('Ana', 'Another Street', '2020-06-01', true);
	
UPDATE ExampleAddressSCD2 
SET FlagCurrent = false
WHERE Customer = 'Ana'
AND UpdateDate < '2020-06-01';

--@en: Checking again to see how it looks like now
--@pt: Verificando novamente como estão os dados
SELECT * FROM ExampleAddressSCD2;

/*
* * * SCD Type 3 | SCD Tipo 3 * * *
@en:
This one is a little more complex, we have in the table a DateFrom and DateTo
to record the validity of a record, or in another words, it's like reading
"this status is valid for a period between this and this date".
This approach is very good to store records where you need to know an specific 
status in a given date and / or time.
I don't recommend using null as a DateTo

@pt:
Esse tipo é um pouco mais complexo, temos na tabela duas datas: DataDe e DataAte
para armazenar a validade de um registro, ou em outras palavras, é como ler
"esse status é valido no período entre essa e essa data".
Esse método é muito bom para armazenar registros onde você precisa saber um status
específico em uma data ou horário específico.
*/
CREATE TABLE ExampleAddressSCD3 (
	ID SERIAL NOT NULL PRIMARY KEY,
	Customer VARCHAR(50), --@pt: Cliente
	Address VARCHAR(50), --@pt: Endereço
	DateFrom DATE NOT NULL, --@pt: Data De
	DateTo DATE NOT NULL, --@pt: Data Ate
	FlagCurrent BOOLEAN NOT NULL DEFAULT true --@pt: flag de registro atual
);

--@en: Inserting first record, when Ana registered herself on the system
--@pt: Inserindo o primeiro registro, quando a Ana se cadastrou no sistema
INSERT INTO ExampleAddressSCD3 (Customer, Address, DateFrom, DateTo, FlagCurrent)
	VALUES ('Ana', 'Main Street', '2020-01-01', '2099-12-31', true);
	
--@en: Checking to see how it looks like
--@pt: Verificando como estão os dados
SELECT * FROM ExampleAddressSCD3;

--@en: When we have a change, we have to update the old record setting an end date,
--     then we insert the new one 
--@pt: Quando temos uma alteração da informação, devemos atualiar o registro anterior
--     colocando uma data final e depois inserir o novo
UPDATE ExampleAddressSCD3 
SET FlagCurrent = false,
	DateTo = '2020-05-31'
WHERE Customer = 'Ana'
AND FlagCurrent = true;

INSERT INTO ExampleAddressSCD3 (Customer, Address, DateFrom, DateTo, FlagCurrent)
	VALUES ('Ana', 'Another Street', '2020-06-01', '2099-12-31', true);
	
--@en: Checking again to see how it looks like now
--@pt: Verificando novamente como estão os dados
SELECT * FROM ExampleAddressSCD3;

--@en: With this, it's easier to find for example what was her address in 05/15/2020
--@pt: Com isso é fácil buscar qual era o endereço dela em 15/05/2020
SELECT Address
FROM ExampleAddressSCD3
WHERE Customer = 'Ana'
AND '2020-05-15' BETWEEN DateFrom AND DateTo;

SELECT Address
FROM ExampleAddressSCD3
WHERE Customer = 'Ana'
AND '2020-07-15' BETWEEN DateFrom AND DateTo;


/*
Bonus tip
@en: To transform your SCD type 2 to a SCD type 3, you can use the funcion LEAD to get
	 the next record date and then subtract 1 to get the previous period. If your LEAD
	 function returns NULL it means that you are on the most current period, so I'm 
	 setting to a super future date in order to avoid NULLs as a "date to".
@pt: Para transformar seu SCD tipo 2 em 3, é possível utilizar a função LEAD para retornar
	 a data do próximo registro, e depois subtrair 1 para pegar o menor período anterior.
	 Se sua função LEAD retornar NULL significa que você está na data mais atual, então
	 estou adotando uma data bastante futura para evitar NULLs no campo "Data até".
*/
SELECT 	customer,
		address,
		updatedate AS datefrom,
		CASE
			WHEN LEAD(updatedate) OVER (PARTITION BY customer ORDER BY updatedate) IS NULL 
				THEN '2099-12-31'
			ELSE
				LEAD(updatedate) OVER (PARTITION BY customer ORDER BY updatedate) - 1 
		END AS dateto,
		flagcurrent
FROM ExampleAddressSCD2;