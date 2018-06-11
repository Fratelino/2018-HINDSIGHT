#-------------------- hindtest --------------------#
install.packages("keras")
library(keras)
install_keras()

source("https://raw.githubusercontent.com/ggrothendieck/gsubfn/master/R/list.R")

source('hindnorm.R')
source('hindsight.R')
source('time_series.R')
source('lstm.R')
source('manual_search.R')
source('random_search.R')
source('vision.R')

load('monroesets.RData')
data = rbind(training, testing)

hindnorm(data)
hindsight(training, testing, nfeatures = 3, nlags = 1)
vision(data, training_def, testing_def, predict_train, predict_test, nlags = 1)