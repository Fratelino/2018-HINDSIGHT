install.packages("keras")
library(keras)
install_keras()

source("https://raw.githubusercontent.com/ggrothendieck/gsubfn/master/R/list.R")
source('hindsight.R')
source('time_series.R')
source('lstm.R')
source('manual_search.R')
source('random_search.R')

load('monroesets.RData')

loss = hindsight(training, testing, nfeatures = 5, nlags = 1)