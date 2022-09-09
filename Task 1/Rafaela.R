
# Nesta atividade, devem clonar o repositório GitHub da disciplina nos seus discos 
# locais e fazer um git push com o seu código e relatórios para que possam ser avaliados. 

# Repositório: https://github.com/renatoquiliche/DataScience-PUCRio-FB

# Carregar o dataset Data Science Job Salaries no software utilizado e gerar 
# estatísticas descritivas (extra: desenvolver os exercícios 1, 2, 3 e 4 usando 
# o dataset do seus projetos da disciplina).

library(data.table)
library(dplyr)

# Link dataset: https://github.com/renatoquiliche/DataScience-PUCRio-FB/blob/main/Data/DS_salarios/ds_salaries.csv

#df <- read.csv("/home/rafaela/Documents/PUC/2022.2/Ciencia de Dados/DataScience-PUCRio-FB/Data/DS_salarios/ds_salaries.csv")
df <- read.csv("ds_salaries.csv")
head(df)
tail(df)
l = length(df$salary_in_usd)

# 1) Aplicar uma técnica de amostragem (sugestão: aplicar bootstrap)

# Bootstrap

transpose(sample(transpose(df), size = 30, replace = TRUE))

# 2) Aplicar uma técnica de discretização (sugestão: transformar variável 
# numérica em quantiles)

quantil25 <- quantile(df$salary_in_usd)[2]
quantil50 <- quantile(df$salary_in_usd)[3]
quantil75 <- quantile(df$salary_in_usd)[4]

for (i in 1:l) {
  if (df$salary_in_usd[i] <= quantil25) {
    df$salary_in_usd_disc[i] <- 1
  } else if (df$salary_in_usd[i] <= quantil50 && df$salary_in_usd[i] > quantil25) {
    df$salary_in_usd_disc[i] <- 2
  } else if (df$salary_in_usd[i] <= quantil75 && df$salary_in_usd[i] > quantil50) {
    df$salary_in_usd_disc[i] <- 3
  } else if (df$salary_in_usd[i] > quantil75) {
    df$salary_in_usd_disc[i] <- 4
  }
}

head(df)

# 3) Aplicar uma técnica de Feature Engineering (sugestão: aplicar uma funçao 
# que transforme os campos de ano e mês na quantidade de meses transcorrido desde 
# uma data inicial. Por exemplo, ano 2020/mês 6 representariam 30 meses de antiguidade)

# desde janeiro de 2014

2014-05-01

ano = 2014
mes = 05

diff_mes <- c()
for (i in 1:l) {
  diff_mes[i] = ((df$work_year[i] - ano) * 12) + (df$work_month[i] - mes + 1)
}
df$diff_mes = diff_mes
tail(df)
