base = read.csv("credit-data.csv")
base$clientid = NULL

base$age = ifelse(base$age < 0 | is.na(base$age), mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE), base$age)

base[, 1:3] = scale(base[, 1:3])

library("caTools")
set.seed(1)
divisao = sample.split(base$default, SplitRatio = 0.75)
base_treinamento = subset(base, divisao == TRUE)
base_teste = subset(base, divisao == FALSE)

#install.packages('RoughSets')
library(RoughSets)
dt_treinamento = SF.asDecisionTable(dataset = base_treinamento, decision.attr = 4)
dt_teste = SF.asDecisionTable(dataset = base_teste, decision.attr = 4)

intervalos = D.discretization.RST(dt_treinamento, nOfIntervals = 4)
print(intervalos)

dt_treinamento = SF.applyDecTable(dt_treinamento, intervalos)
dt_teste = SF.applyDecTable(dt_teste, intervalos)

classificador = RI.CN2Rules.RST(dt_treinamento, K = 4)
print(classificador)

previsao = predict(classificador, newdata = dt_teste[-4])
print(previsao)
matriz_confusao = table(dt_teste[,4], unlist(previsao))
print(matriz_confusao)
library(caret)
confusionMatrix(matriz_confusao)                        
