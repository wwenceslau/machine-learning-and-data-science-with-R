base = read.csv("credit-data.csv")
base$clientid = NULL

#dados inconsistentes + faltantes
base$age = ifelse(base$age < 0 | is.na(base$age), mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE), base$age)

#escalonamento
base[, 1:3] = scale(base[, 1:3])

#enconding da classe
base$default = factor(base$default, levels = c(0,1))

#Separação entre treino e teste
library("caTools")
set.seed(1)
divisao = sample.split(base$default, SplitRatio = 0.75)
base_treinamento = subset(base, divisao == TRUE)
base_teste = subset(base, divisao == FALSE)

library('rpart')
classificacao = rpart(formula = default ~ ., data = base_treinamento)
print(classificacao)
library(rpart.plot)
rpart.plot(classificacao)

previsao = predict(classificacao, newdata = base_teste[-4], type = 'class')
print(previsao)
matriz_confusao = table(base_teste[,4], previsao)
print(matriz_confusao)
library(caret)
confusionMatrix(matriz_confusao)
