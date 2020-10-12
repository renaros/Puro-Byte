#!/usr/bin/env python
# coding: utf-8

# # Exemplo de ETL Simples
# 
# Desenvolvido por: Renato Rossi (renaroscoding@gmail.com) para o Instagram Puro Byte

# A idéia deste exercício é mostrar na prática como funciona um ETL simples para gerar um relatório em formato CSV de quantidade de emprestimos de veículos por região.
# Os dados de fonte são dois arquivos: Um arquivo CSV com informações de empréstimos de filmes e clientes e outro arquivo CSV com informações sobre cidades.

# #### Setup Inicial ####

# Importando bibliotecas de manipulação de dados 
import pandas as pd


# #### Baixando os dados dos arquivos (Extract) ####

# Para este caso como vamos lidar apenas com arquivos CSV não precisamos de mais nenhuma biblioteca além do pandas.
# Carregando as informações dos arquivos (cada um para um dataframe diferente)...
dataframe_cidades = pd.read_csv('cidades_etl_example.csv')
dataframe_emprestimos = pd.read_csv('emprestimos_etl_example.csv')


# #### Transformando os dados (Transform) ####

# Neste passo estamos consolidando as duas informações utilizando a coluna city_id como chave
dataframe_join = dataframe_emprestimos.join(
    dataframe_cidades, 
    on='city_id',    #chave da junção entre as tabelas
    how='inner',     #tipo da junção, neste caso inner
    rsuffix='_geo',  #alias para campos com mesmo nome do lado direito (regioes)
    lsuffix='_rent'  #alias para campos com mesmo nome do lado esquerdo (pedidos)
)

# E agora estamos contando a quantidade de alugueis de filmes agrupado por país e cidade

#groupby vai agrupar o dataframe por país e cidade e count() vai contar todas as colunas, por 
#isso temos que adicionar ['rental_id'] para contar somente nessa coluna.
count_by_city = dataframe_join.groupby(['country', 'city'])['rental_id'].count()


# #### Carregando os dados no destino (Load) ####

# Neste caso será um csv também na mesma pasta somente para fins didáticos, mas pode ser um banco de dados, um arquivo JSON ou qualquer outro formato.
count_by_city.to_csv('./count_by_city_export.csv')

