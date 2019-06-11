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

library('e1071')

classificador = naiveBayes(x = base_treinamento[-4], y = base_treinamento$default)
print(classificador)

previsao = predict(classificador, newdata = base_teste[-4])
print(previsao)

matriz_confusao = table(base_teste[ , 4], previsao)
print(matriz_confusao)
install.packages('caret')
library('caret')

confusionMatrix(matriz_confusao)
