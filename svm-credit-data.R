base = read.csv("credit-data.csv")
base$clientid = NULL

base$age = ifelse(base$age < 0 | is.na(base$age), mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE), base$age)

base[, 1:3] = scale(base[, 1:3])

library("caTools")
set.seed(1)
divisao = sample.split(base$default, SplitRatio = 0.75)
base_treinamento = subset(base, divisao == TRUE)
base_teste = subset(base, divisao == FALSE)

#install.packages('e1071')
library(e1071)
classificador = svm(formula = default ~., data = base_treinamento, 
                    type='C-classification', kernel = 'radial', cost = 5.0)
print(classificador)
previsoes = predict(classificador, newdata = base_teste[-4])
print(previsoes)
matriz_confusao = table(base_teste[,4], previsoes)
print(matriz_confusao)
library(caret)
confusionMatrix(matriz_confusao)
