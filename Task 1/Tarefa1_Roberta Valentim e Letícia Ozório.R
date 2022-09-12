#1)Carregar o dataset Data Science Job Salaries no software utilizado e 
#gerar estatísticas descritivas (extra: desenvolver os exercícios 1, 2, 3 e 4 usando o 
#dataset do seus projetos da disciplina)

library(data.table)
library(dplyr)
df <- read.csv("Data/DS_salarios/ds_salaries.csv")

library(Hmisc)

summary(df)  
#mostra um resumo estatístico de df, como mínimos, medianas, médias, tamanho, 
#máximos, dentre outros.

install.packages('data.table')
library(data.table)

# 2) Aplicar uma técnica de amostragem (sugestão: aplicar bootstrap)
transpose(sample(transpose(df), size = 200, replace = TRUE)) 

# 3) Aplicar uma técnica de discretização (Primeiro foi calculada a mediana para 
#salary_in_usd(salários em dólar) e posteriormente atribuído o valor 0, 
#caso o valor estivesse abaixo ou igual a mediana e 1, caso estivesse acima da mediana)

install.packages("dplyr")
library(dplyr)

(avg_salary <- median(as.numeric(df$salary_in_usd)))

df_salaries_discr <- df %>% mutate(df_salaries_discr= 
ifelse(salary_in_usd <= avg_salary, "0", "1"))

#Aplicar uma técnica de Feature Engineering (sugestão: aplicar uma funçao que 
#transforme os campos de ano e mês na quantidade de meses transcorrido desde uma 
#data inicial. Por exemplo, ano 2020/mês 6 representariam 30 meses de antiguidade)

#Considerada como data inicial 01 de julho de 2018 e considerando que no dataframe(df) o mês
#é contabilizado iniciando dia 01. Dessa forma, a quantidade de meses dos anos inteiros é
#calculada como o ano do df(dataframe) menos o ano escolhido como inicial (2018),multiplicado por 12 
#(quantidade de meses no ano). A quantidade de meses do ano inicial é calculada como 12 (quantidade de 
#meses no ano) menos o mês escolhido como inicial (7), mais 1, pois como foi considerado que o mês 
#se incia no dia 1, ele deve ser contabilizado. A quantidade de meses do ano final é calculada como
# o mes no data frame menos um, pois como foi considerado que o mês começa no dia 01, ele não foi 
#contabilizado.

ano_inicial<-2018
mes_inicial<-7
j = length(df$salary_in_usd)
antiguidade_meses<-c()
for(i in 1:j) {antiguidade_meses[i]=(((df$work_year[i]-ano_inicial)*12)+((12-mes_inicial)+1)+((df$work_month[i]-1)))}
df$antiguidade_meses
tail(df)

