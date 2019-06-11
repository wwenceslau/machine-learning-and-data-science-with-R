base = read.csv('risco-credito.csv')

install.packages('e1071')
library('e1071')

classificador = naiveBayes(x = base[-5], y = base$risco)
print(classificador)

historia = 'boa'
divida = 'alta'
garantias = 'nenhuma'
renda = 'acima_35'

df = data.frame(historia, divida, garantias, renda)

previsao = predict(classificador, newdata = df, 'raw')
print(previsao)

historia = 'ruim'
divida = 'alta'
garantias = 'adequada'
renda = '0_35'

df2 = data.frame(historia, divida, garantias, renda)

previsao2 = predict(classificador, newdata = df2, 'raw')
print(previsao2)
