base = read.csv('risco-credito.csv')
base = base[base$risco != "moderado" , ]

classificador = glm(formula = risco ~ ., family = binomial, data = base)

historia = c('boa','ruim')
divida = c('alta', 'alta')
garantias = c('nenhuma', 'adequada')
renda = c('acima_35', '0_15')
df = data.frame(historia, divida, garantias, renda)
print(df)

probabilidade = predict(classificador, type = 'response', newdata = df)
print(probabilidade)
resposta = ifelse(probabilidade >= 0.5, "baixo", "alto")
print(resposta)
