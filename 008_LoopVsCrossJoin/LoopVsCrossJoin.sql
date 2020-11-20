/*
@en: 
Script developed by Renato Rossi in 11/19/2020
The objective with this script is to show the difference between using a loop
and a cross join instead.

@pt:
Script desenvolvido por Renato Rossi em 19/11/2020
O objetivo desse script é mostrar a diferença no uso de um loop em um cross join.
*/

--@en: First we create a table for branches (agencia in portuguese) and insert some mockup data
--@pt: Primeiro criamos a tabela de agências e inserimos alguns dados fictícios
CREATE TABLE agencia (
	id serial primary key,
	nome varchar(30),
	flag_ativo boolean not null default true
);

INSERT INTO agencia (nome) VALUES ('Agência 1'), ('Agência 2'), ('Agência 3'), ('Agência 4'), ('Agência 5');

SELECT * FROM agencia;

--@en: Creating a table for products (in portuguese produto), that will store bank products such as credit card
--     (cartão), transfers (transferência) and payment slips (boleto)
--@pt: Criando tabela para produtos bancários, que armazenará valores de cartão, transferência e boleto como 
--     exemplo
CREATE TABLE produto (
	id serial primary key not null,
	produto varchar(30)
);

INSERT INTO produto (produto) VALUES ('Cartão'), ('Transferência'), ('Boleto');

SELECT * FROM produto;


--@en: The movements table (in portuguese movimentação) stores all the transactions done in this
--     example bank.
--@pt: A tabela de movimentação armazena transações feitas nesse banco de exemplo
CREATE TABLE movimentacao (
	id serial primary key not null,
	fk_agencia int,
	fk_produto int,
	cliente varchar(30),
	data_movimentacao timestamp without time zone not null default NOW(),
	valor decimal(10,2),
	foreign key (fk_agencia) references agencia(id),
	foreign key (fk_produto) references produto(id)
);

INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 2, '2019-11-10', 'Kathie Sygroves', 821.56);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 2, '2019-3-19', 'Hervey Sheron', 923.55);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 2, '2019-5-31', 'Alair McGow', 468.6);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-6-11', 'Micki Southward', 582.07);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-3-25', 'Aldric Mixon', 99.7);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-4-12', 'Al Proudley', 772.37);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-6-18', 'Analise Jamison', 719.79);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-10-8', 'Kale McQuin', 576.6);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 1, '2019-6-9', 'Rozanna Lamburne', 443.77);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-7-21', 'Harris Tease', 198.13);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-4-19', 'Evvy Moat', 768.25);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 1, '2019-3-5', 'Carolee De Cruze', 481.33);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2020-10-1', 'Claudell Archibold', 275.37);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 1, '2019-1-20', 'Fara Karslake', 461.02);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-5-4', 'Sybille Marklew', 521.15);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 1, '2019-12-18', 'Mahmud Dumigan', 422.32);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 1, '2019-3-6', 'Stace Rothman', 875.25);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-9-28', 'Erich Haire', 157.45);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-8-16', 'Geoff Crimin', 850.14);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-6-1', 'Nero Minocchi', 550.95);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-9-18', 'Licha Windridge', 654.2);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-3-24', 'Charlot Knightsbridge', 603.83);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-9-13', 'Morgen Larmor', 979.22);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-6-25', 'Kylie Swyer', 676.57);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-7-23', 'Gloriana Cornehl', 387.88);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-4-21', 'Maris Mewitt', 273);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 2, '2019-10-18', 'Serena Matovic', 682.91);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-1-6', 'Opal McCaughan', 443.4);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 2, '2019-1-7', 'Sofia Fingleton', 675.1);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (4, 2, '2019-6-7', 'Maiga Farherty', 156.47);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-11-30', 'Isaac Standrin', 440.56);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 1, '2020-4-28', 'Elvira Duddle', 405.59);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 2, '2020-4-10', 'Gianna Geillier', 109.13);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-9-9', 'Guglielmo Misselbrook', 108.1);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-5-16', 'Antoine Mattes', 155.54);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 1, '2019-11-24', 'Gaynor Mixer', 623.47);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-2-9', 'Ellsworth Abbots', 324.39);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2020-3-4', 'Elroy Trembey', 550.72);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (2, 2, '2019-1-28', 'Royall Sainsberry', 499.56);
INSERT INTO movimentacao (fk_agencia, fk_produto, data_movimentacao, cliente, valor) VALUES (1, 1, '2019-2-26', 'Raviv Dawkes', 313.94);

--@en: Create a table to store the results for the report (in portuguese, relatorio)
--@pt: Criando uma tabela para armazenar os resultados do relatório
CREATE TABLE relatorio
(
    id integer NOT NULL SERIAL PRIMARY KEY,
    agencia varchar(30),
    produto varchar(30),
    qtde integer NOT NULL DEFAULT 0
)

--@en: Query that returns number of transactions (quantidade_operacoes) and 
--     amount transacted (valor_transacionado) by branch and product, but this query does not show 
--     branches / products without transactions
--@pt: Query que retorna o numero de transações e o valor transacionado por agência e produto, mas
--     essa query não mostra agências e / ou produtos sem movimentações
SELECT 	a.nome as agencia,
		p.produto,
		COUNT(1) as quantidade_operacoes,
		SUM(valor) as valor_transacionado
FROM movimentacao m
INNER JOIN agencia a ON m.fk_agencia = a.id
INNER JOIN produto p ON m.fk_produto = p.id
GROUP BY a.nome, p.produto
ORDER BY 1, 2;


/*****************************************************/

/* Loop */

--@en: for each product and branch, insert a record with quantity 0. After that updates
--     the values for branches / products that had transactions.
--@pt: para cada produto e agência, insere um registro com quantidade 0. Depois disso
--     atualiza o valor para as agências e produtos que tiveram movimentações.

TRUNCATE TABLE relatorio;

do $$

declare pr record;
		ag record;

begin	
	for pr in SELECT produto FROM produto	
	loop
		for ag in SELECT nome FROM agencia	
		loop
			INSERT INTO relatorio (agencia, produto, qtde)
				SELECT ag.nome, pr.produto, 0;
		end loop;
	end loop;
end;
$$;

UPDATE relatorio r
SET qtde = quantidade_operacoes
FROM (
	SELECT 	a.nome as agencia,
			p.produto,
			COUNT(1) as quantidade_operacoes,
			SUM(valor) as valor_transacionado
	FROM movimentacao m
	INNER JOIN agencia a ON m.fk_agencia = a.id
	INNER JOIN produto p ON m.fk_produto = p.id
	GROUP BY a.nome, p.produto
) d
WHERE r.agencia = d.agencia AND r.produto = d.produto;

SELECT * FROM relatorio ORDER BY 2, 3;



/* Cross Join */

TRUNCATE TABLE relatorio;

INSERT INTO relatorio (agencia, produto, qtde)
	SELECT  a.agencia,
			a.produto,
			COALESCE(b.quantidade_operacoes, 0) AS quantidade_operacoes
	FROM (
		--@en: by doing agencia a, produto b, we are creating a all to all relationship between the tables
		--@pt: ao fazer agencia a, produto b, estamos criando um relacionamento todos para todos entre as tabelas
		SELECT 	a.id AS id_agencia,
				a.nome AS agencia,
				p.id AS id_produto,
				p.produto
		FROM agencia a, produto p
	) a
	LEFT JOIN (
		SELECT  m.fk_agencia,
				m.fk_produto,
				COUNT(1) as quantidade_operacoes,
				SUM(valor) as valor_transacionado
		FROM movimentacao m
		GROUP BY m.fk_agencia, m.fk_produto
	) b ON a.id_agencia = b.fk_agencia AND a.id_produto = b.fk_produto;

SELECT * FROM relatorio ORDER BY 2, 3;