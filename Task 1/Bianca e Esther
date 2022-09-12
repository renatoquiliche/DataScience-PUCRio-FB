##Carregar Pacotes#####

library(ggplot2)
library(readxl)
library(tidyverse)

##Carregar o dataset Data Science Job Salaries no software utilizado##

dados <- read.csv("https://raw.githubusercontent.com/renatoquiliche/DataScience-PUCRio-FB/main/Data/DS_salarios/ds_salaries.csv")

#gerar estatísticas descritivas#

mean(dados$salary_in_usd) # média dos salários em dólar

median(dados$salary_in_usd) # mediana dos salários em dólar

var(dados$salary_in_usd) # variância dos salários em dólar

summary(dados) #resumo de outras estatísticas

#------------------------------------------------------------------------#
#Aplicar uma técnica de amostragem (sugestão: aplicar bootstrap)#
#Bootstrapping é uma técnica de reamostragem para se realizar inferências sobre acurácia de estimativas por amostras. #


# Criar um vetor para armazenar o valor da reamostragem:
reamostras = rep(NA, 10000)

# Simular a reamostragem 10.000 vezes:
for (i in 1:10000) {
  reamostra = sample(dados$salary_in_usd, replace = T) # Reamostragem dos salários com reposição
  reamostras[i] = mean(reamostra) # Calcular a média de cada reamostra
}

# Transformar o vetor em formato tidy:
reamostras = data.frame(salarios = reamostras)

# Criar o gráfico de distribuição da média bootstrap:
reamostras  %>%
  ggplot(aes(x = salarios)) +
  geom_histogram(alpha = 0.3, fill = "red") +
  labs(
    title = "Distribuição dos Salários da Reamostragem",
    subtitle = paste0("Media: ", round(mean(dados$salary_in_usd),1),".")
  ) + 
  theme_light()

#------------------------------------------------------------------------#
#Aplicar uma técnica de discretização (sugestão: transformar variável numérica em quantiles)#

#Categorizar a coluna de salários em USD em faixas salariais#

dados$faixa_salarial<-rep(NA,length(dados$salary_in_usd))
summary(dados$salary_in_usd)
sd(dados$salary_in_usd,na.rm=T)
dados$faixa_salarial[dados$salary_in_usd<summary(dados$salary_in_usd)[2]]<-'Salario muito baixo'
dados$faixa_salarial[summary(dados$salary_in_usd)[2]<=dados$salary_in_usd&dados$salary_in_usd<summary(dados$salary_in_usd)[3]]<-'Salario baixo'
dados$faixa_salarial[summary(dados$salary_in_usd)[3]<=dados$salary_in_usd&dados$salary_in_usd<summary(dados$salary_in_usd)[5]]<-'Salario medio'
dados$faixa_salarial[dados$salary_in_usd>=summary(dados$salary_in_usd)[5]]<-'Salario alto'

#------------------------------------------------------------------------#
#Aplicar uma técnica de Feature Engineering 
#(sugestão: aplicar uma funçao que transforme os campos de ano e mês na quantidade de meses transcorrido desde uma data inicial. Por exemplo, ano 2020/mês 6 representariam 30 meses de antiguidade)#

j = length(dados$salary_in_usd)
intervalo_meses<-c()
for(i in 1:j) {intervalo_meses[i]=(((dados$work_year[i]-1996)*12)+((12-5)+1)+((dados$work_month[i]-1)))}
dados$intervalo_meses
tail(dados)
