# -*- coding: utf-8 -*-
"""
Created on Sun Sep 10 17:51:58 2023

@author: Gabriel V. Santos
@matrícula: 2321029
"""

# Importação das bibliotecas
import pandas as pd
import matplotlib.pyplot as plt
#import numpy as np
from datetime import datetime


# Importação da base de dados .csv
ds_salaries_arq = 'ds_salaries.csv'
ds_salaries_df = pd.read_csv(ds_salaries_arq)
#print(ds_salaries_df)

# 1) Estatística descritiva

# 1.1) Resumo estatístico
ds_resumo = ds_salaries_df.describe()
print('1) Estatística descritiva \n1.1) Resumo estatístico \n {}'.format(ds_resumo))

# 1.2) Média, mediana e moda dos salários
media_salaries = ds_salaries_df['salary_in_usd'].mean()
mediana_salaries = ds_salaries_df['salary_in_usd'].median()
moda_salaries = ds_salaries_df['salary_in_usd'].mode()
print("\n1.2) Média, mediana e moda dos salários \nO levantamento amostral dos salários da base de dados para os USA indica os seguintes aspectos: \n \t Média: {:.1f} \n \t Mediana: {:.1f} \n \t Moda {} \n".format(media_salaries, mediana_salaries, moda_salaries))


# 1.3) Matriz de correlação entre colunas numéricas
colunas_removidas = [ds_salaries_df.columns[0]]
df_reduzido = ds_salaries_df.drop(colunas_removidas, axis=1)
matriz_corr_salaries = df_reduzido.corr()
# Plotagem da matriz de corelação como mapa de calor e com rótulos
fig, ax = plt.subplots()
cax = ax.matshow(matriz_corr_salaries, cmap='coolwarm')
fig.colorbar(cax)
plt.xticks(range(len(matriz_corr_salaries.columns)), matriz_corr_salaries.columns, rotation=45)
plt.yticks(range(len(matriz_corr_salaries.columns)), matriz_corr_salaries.columns)
print('1.3) Matriz de correlação entre colunas numéricas')
plt.show()


# 1.4) Análise dos salários para a profissão Data Scientist por nível de experiência

print('\n1.4) Análise dos salários para a profissão Data Scientist por nível de experiência')
      
# Filtragem
scientist_df = ds_salaries_df[ds_salaries_df['job_title'] == 'Data Scientist']
scientist_se_df = scientist_df[scientist_df['experience_level'] == 'SE']
scientist_mi_df = scientist_df[scientist_df['experience_level'] == 'MI']
scientist_en_df = scientist_df[scientist_df['experience_level'] == 'EN']

# Calcular a média dos salários
media_salary_usd = scientist_df['salary_in_usd'].mean()
media_salary_se_usd = scientist_se_df['salary_in_usd'].mean()
media_salary_mi_usd = scientist_mi_df['salary_in_usd'].mean()
media_salary_en_usd = scientist_en_df['salary_in_usd'].mean()


# Plotagem
plt.figure(figsize=(10, 6))
plt.scatter(scientist_df['experience_level'], scientist_df['salary_in_usd'])
plt.axhline(media_salary_se_usd, color='green', linestyle='--', label='Média de salários para Data Scientist SE (usd)')
plt.axhline(media_salary_mi_usd, color='blue', linestyle='--', label='Média de salários para Data Scientist MI (usd)')
plt.axhline(media_salary_en_usd, color='red', linestyle='--', label='Média de salários para Data Scientist EN (usd)')
plt.xlabel('Nível de experiência')
plt.ylabel('Salário (usd)')
plt.title('Salário e média da profissão Data Scientis por experiência')
plt.legend()
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()




# 2) Bootstrap
print('2) Bootstrap')

# Número de iterações bootstrap
n_iter = 1000

# Tamanho da amostra
sample_size = len(ds_salaries_df)

# Lista para armazenar as estatísticas de interesse (por exemplo, a média)
bootstrap_statistics = []

for _ in range(n_iter):
    # Amostragem bootstrap com substituição
    bootstrap_sample = ds_salaries_df['salary_in_usd'].sample(n=sample_size, replace=True)
    
    # Calculo da média dos salários (usd) para a amostra bootstrap
    statistic = bootstrap_sample.mean()
    
    # Adicione a estatística à lista
    bootstrap_statistics.append(statistic)

# Converta a lista de estatísticas em um DataFrame
bootstrap_df = pd.DataFrame({'Bootstrap_Estimates': bootstrap_statistics})

# Exibir estatísticas resumidas
print("Estatísticas do Bootstrap:")
print(bootstrap_df.describe())

# Plotar um histograma das estatísticas do Bootstrap
plt.figure(figsize=(10, 6))
plt.hist(bootstrap_statistics, bins=30, edgecolor='k')
plt.title('Distribuição das Estatísticas do Bootstrap')
plt.xlabel('Salário (usd)')
plt.ylabel('Frequência')
plt.show()



#3) Discretização
print('3) Discretização')

# Criação da coluna dos quantis
quantis = pd.qcut(ds_salaries_df['salary_in_usd'], q=4, labels=['1º Quartil', '2º Quartil', '3º Quartil', '4º Quartil'])
ds_salaries_df['quartil_salarios'] = quantis
print(ds_salaries_df[['job_title','salary_in_usd', 'quartil_salarios']][:11])



#4) Feature Engineering
print('\n4) Feature Engineering')

# Cálculo do tempo decorrido até a data atual em meses
ds_salaries_df['meses_transcorridos'] = (datetime.now().year - ds_salaries_df['work_year']) * 12 + (datetime.now().month - ds_salaries_df['work_month'])
    
print(ds_salaries_df[['work_year','work_month', 'meses_transcorridos']][:11])
    
