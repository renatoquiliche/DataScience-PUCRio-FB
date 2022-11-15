
##Carregar Pacotes#####

##Carregar Pacotes#####

install.packages("rpart")
install.packages("rpart.plot")
install.packages("ISLR")
install.packages("mccr")
install.packages("tree")
install.packages("caret")

library(ISLR)
require(tree)
library(rpart)
library(rpart.plot)
library(mccr)
require(mccr)
library(dplyr)
library(caret)
library(fastDummies)

##Carregar o dataset##

dados <- read.csv("https://raw.githubusercontent.com/renatoquiliche/DataScience-PUCRio-FB/main/Data/DS_salarios/ds_salaries.csv")

dados$salary_in_usd = dados$salary_in_usd/1000

#Pre-processing
#1. Transform the categorical features into binary variables (dummy variables). Dummy variables are accepted by almost any classifier. (1 point)

str(dados)
table(dados$company_size)
head(dados)
glimpse(dados)


input_variables <- dados[,c('company_size', 'remote_ratio'
                            , 'work_year', 'job_title', 'experience_level'
                            , 'employment_type', 'employee_residence'
                            , 'company_location', 'salary_in_usd')]


final_data <- dummy_cols(input_variables, select_columns = c('work_year', 'job_title', 'experience_level'
                                                             , 'employment_type', 'employee_residence'
                                                             , 'company_location'), remove_selected_columns = TRUE)

## Partição de dados
#make this example reproducible
set.seed(0)

#create ID column
final_data$id <- 1:nrow(final_data)

#use 70% of dataset as training set and 30% as test set 
train_size = 0.7

train <- final_data %>% dplyr::sample_frac(train_size)
test  <- dplyr::anti_join(final_data, train, by = 'id')

#Processing
#2. Fit a Decision Tree to classify the size of company in which each data scientist work. 
#This is represented by the feature ‘company_size’, which is the target variable.
#2.1
set.seed(100)
tree_model <- rpart(company_size~., data = train, method = 'class', maxdepth=3)
summary(tree_model)
rpart.plot(tree_model, extra=104)

table(train$company_size)
table(test$company_size)

#2.2 - Plot the decision tree
#To predict on test data
rpart.predict(tree_model, test, type='class')


#3. Interpret the results of the decision tree (3 points)
#3.1. Write a paragraph interpreting the structure of the decision tree.

#Baseado nessas features inicias, pode-se observar que foram definidas três classes L,M,S, que representam os respectivos tamanhos das companhias (pequena, média e grande). A árvore de 
#decisão é constituída por frequências para cada tamanho da companhia, e no primeiro nó de decisão da árvore, foi observado que o tamanho da companhia M tem a maior frequência (55%) em relação às
#demais. A categoria work_year_2022 foi a melhor avaliada, e quando está igual a 0, vimos que foram representados nós de ramificações para uma tomada de decisão que será realizada. Isso posto, quando a decisão 
#for sim, temos que 48% do resultado da decisão é o tamanho da companhia L, pois tem a maior frequência, e se for não temos que 52% do resultado da decisão é o tamanho da companhia M. Diante
#dessa decisão, foi representado outro nó de decisão com a segunda melhor categoria representada na árvore, no qual o salary_in usd >= 19e+3 obteve o melhor desempenho. As alternativas de ramificações seguem o mesmo conceito
#que a primeira categoria, quando for sim, temos que 44% do resultado da decisão é o tamanho da companhia L, e se for não, temos que 5% do resultado da decisão é o tamanho da companhia S, ambos pelo mesmo 
#motivo de exibirem as maiores frequências. Com isso, é criado outro nó de decisão com a terceira melhor categoria na árvore de decisão, que foi o remote_ratio<75. Nessa última análise da 
#árvore, já que o exercício propôs no máximo 3 nós de decisão, temos que se a decisão for sim, 3% do resultado é o tamanho da companhia M, e ao contrário, e se for não, 2% do resultado é o tamanho da companhia S. 
#Dessa maneira, a árvore de decisão foi representada a fim de aprimorar a performance dos métodos de classificação que foram expostos, além disso a companhia ser capaz de comparar possíveis ações com base em 
#seus custos, probabilidades e benefícios.




#4. Measure the performance of the decision tree to make accurate predictions.
#4.1. By hold-out cross-validation performance (3 points)
#4.1.1. Estimate the accuracy, interpret the results. (1.5 points)

predict_unseen <- predict(tree_model, test, type = 'class')

table_mat <- table(test$company_size, predict_unseen)
table_mat
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
print(paste('Accuracy for test', accuracy_Test))

#A acurácia deu 0.67032967032967, mas isso não quer dizer que a acurária é realmente boa, pois os dados estão desbalanceados.

#4.1.2. Estimate the Matthews correlation coefficient, interpret the results (1.5 points)

test$company_size <- ifelse(test$company_size=="S", 0,
                            ifelse(test$company_size=="M", 1,
                                   2))

predict_unseen <- ifelse(predict_unseen=="S", 0,
                         ifelse(predict_unseen=="M", 1,
                                2))

mccr(test$company_size,predict_unseen)

# Matthews correlation coefficient tem menos viés, logo está mais próximo da acurácia "certa" do modelo