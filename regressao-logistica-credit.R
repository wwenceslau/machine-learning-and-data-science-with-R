base = read.csv("credit-data.csv")
base$clientid = NULL

base$age = ifelse(base$age < 0 | is.na(base$age), mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE), base$age)

base[, 1:3] = scale(base[, 1:3])

library("caTools")
set.seed(1)
divisao = sample.split(base$default, SplitRatio = 0.75)
base_treinamento = subset(base, divisao == TRUE)
base_teste = subset(base, divisao == FALSE)

classificador = glm(formula = default ~., family = binomial, data = base_treinamento)
print(classificador)

probabilidade = predict(classificador, type = 'response', newdata = base_teste[-4])
print(probabilidade)
previsoes = ifelse(probabilidade > 0.5, 1, 0)
print(previsoes)
matriz_confusao = table(base_teste[,4], previsoes)
library(caret)
confusionMatrix(matriz_confusao)
