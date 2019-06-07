base = read.csv("credit-data.csv")
base$clientid = NULL

base[base$age < 0, ]

mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE)


base$age = ifelse(base$age < 0 | is.na(base$age), mean(base$age[base$age > 0 & !is.na(base$age)], na.rm = TRUE), base$age)


base[, 1:3] = scale(base[, 1:3])

