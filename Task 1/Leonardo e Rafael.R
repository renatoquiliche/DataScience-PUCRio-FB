# Diretorio
setwd("C:/Users/fabio/Desktop/PUC/2022.2/Ciência de Dados/Prática/Tarefa 1")

#Pacotes
library(readr)
library(psych)
library(data.table)

# Exercicio 1 - Carregar os dados e gerar estatísticas descritivas
salarios.c <- read_csv("ds_salaries.csv")[,-1]
describeBy(salarios.c)
 

# Exercicio 2 - Técnica de Amostragem
# Bootstrap
salarios <- transpose(sample(transpose(salarios.c), size = 50, replace = TRUE))
colnames(salarios) <- colnames(salarios.c)



# Exercicio 3 - Técnica de Discretização
# Transformação da variável salário numérica para uma varíavel categórica
str(salarios)
salarios$salary_in_usd <- as.numeric(salarios$salary_in_usd)

# Em relação a média
salarios$salary_in_usd_average <- ifelse(salarios$salary_in_usd < mean(salarios$salary_in_usd),
                           "Below Average", "Above Average")


# Em relação aos quantis
quartil25 <- quantile(salarios$salary_in_usd)[2]
quartil50 <- quantile(salarios$salary_in_usd)[3]
quartil75 <- quantile(salarios$salary_in_usd)[4]

salarios$salary_in_usd_quantiles <- ifelse(salarios$salary_in_usd <= quartil25,
                                 "Quantile 25", ifelse(salarios$salary_in_usd <= quartil50 & salarios$salary_in_usd > quartil25,
                                             "Quantile 50", ifelse(salarios$salary_in_usd <= quartil75 & salarios$salary_in_usd > quartil50,
                                                         "Quantile 75","Quantile 100")))



# Exercicio 4 - Técnica de Feature Engineering
# Criação de uma nova variável para indicar se o trabalha no mesmo país em que mora, o que representa mais informação
salarios$residence_location <- ifelse(
  salarios$employee_residence != salarios$company_location, 
  "Live in a country and works for another", "Work and live in the same country")


