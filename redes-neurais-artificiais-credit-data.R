base = read.csv("credit-data.csv")
base$clientid = NULL

base$age = ifelse(base$age < 0 | is.na(base$age), mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE), base$age)

base[, 1:3] = scale(base[, 1:3])

library("caTools")
set.seed(1)
divisao = sample.split(base$default, SplitRatio = 0.75)
base_treinamento = subset(base, divisao == TRUE)
base_teste = subset(base, divisao == FALSE)

#install.packages('h2o')
library(h2o)
h2o.init(nthreads = -1)

classificador = h2o.deeplearning(y = 'default', 
                                 training_frame = as.h2o(base_treinamento),
                                 activation = 'Rectifier',
                                 hidden = c(100),
                                 epochs = 1000)

previsoes = h2o.predict(classificador, newdata = as.h2o(base_teste[-4]))
previsoes =(previsoes > 0.5)
previsoes = as.vector(previsoes)
matriz_confusao = table(base_teste[,4], previsoes)
library(caret)
confusionMatrix(matriz_confusao)
