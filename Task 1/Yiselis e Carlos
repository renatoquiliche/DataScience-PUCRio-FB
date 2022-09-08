# Required packages
# library(dplyr)

# importando la base de datos
#ds_salaries <- read.csv("C:/Users/xx-re/OneDrive/Documentos/GitHub/DataScience-PUCRio-FB/Data/ds_salaries.csv")
ds_salaries <- read.csv("~/GitHub/DataScience-PUCRio-FB/Data/DS_salarios/ds_salaries.csv")

# sampling with bootstrap
ds_salaries

ds_salaries_filtered <- ds_salaries[!is.na(as.numeric(ds_salaries$salary_currency)), ] # Delete rows
ds_salaries_filtered["salary_currency"]                                          # Print data frame subset

# The dataset does not have missing values

ds_salaries_bootstrap <- sample(ds_salaries, size=30, replace = TRUE)

ds_salaries_bootstrap

# The re-sample method was applied to original dataset with 30 sasmples, with reposition or bootstrap

# discretization numeric variable

# I define the mean salary here
(avg_salary <- mean(as.numeric(ds_salaries_bootstrap$salary)))


ds_salaries_discretized <- ds_salaries_bootstrap %>%
  mutate(salary_discretized = ifelse(salary_currency < avg_salary,
                           "below average", "at or above average"))

ds_salaries_discretized$salary_discretized <- as.factor(ds_salaries_discretized$salary_discretized) 


#Feature Engineering
ds_salaries_discretized <- ds_salaries_discretized %>%
  mutate(feature_date = (2022 - as.numeric(work_year))*12 + (12-as.numeric(work_month)))
