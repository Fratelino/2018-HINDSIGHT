#-------------------- Designing LSTM Networks --------------------#
lstm <- function(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3, lr, nepochs, bs, nlayers, opt, activation, valsplit, patience) {
        
        model <- keras_model_sequential()
        
        if (opt==1) {
                optimizer = optimizer_sgd(lr = lr)
        } else if (opt==2) {
                optimizer = optimizer_adam(lr = lr)
        } else if (opt==3) {
                optimizer = optimizer_rmsprop(lr = lr)
        } else {
                optimizer = optimizer_adagrad(lr = lr)
        } 
        
        if (activation==1) {
                act = "relu"
        } else if (activation==2) {
                act = "sigmoid"
        } else {
                act = "softmax"
        } 
        
        if (nlayers == 1) {
                model %>%
                        layer_lstm(units = units, return_sequences = FALSE, input_shape = c(nlags, nlags*nfeatures)) %>% 
                        layer_dense(units = 1, activation = act)
        } else if (nlayers == 2) {
                model %>%
                        layer_lstm(units = units, return_sequences = TRUE, input_shape = c(nlags, nlags*nfeatures)) %>% 
                        layer_lstm(units = units1) %>% 
                        layer_dense(units = 1, activation = act)
        } else if (nlayers == 3) {
                model %>%
                        layer_lstm(units = units, return_sequences = TRUE, input_shape = c(nlags, nlags*nfeatures)) %>% 
                        layer_lstm(units = units1, return_sequences = TRUE) %>% 
                        layer_lstm(units = units1) %>% 
                        layer_dense(units = 1, activation = act) 
        } else {
                model %>%
                        layer_lstm(units = units, return_sequences = TRUE, input_shape = c(nlags, nlags*nfeatures)) %>% 
                        layer_lstm(units = units1, return_sequences = TRUE) %>% 
                        layer_lstm(units = units2, return_sequences = TRUE) %>% 
                        layer_lstm(units = units3) %>% 
                        layer_dense(units = 1, activation = act) 
        }
        
        summary(model)
        
        model %>% compile(
                loss = "mean_absolute_error",
                optimizer = optimizer,
                metrics = c("mean_absolute_percentage_error")
        )
        
        early_stopping <- callback_early_stopping(patience = patience, verbose = 1)
        
        history <- model %>% fit(
                train_2, train_1,
                epochs = nepochs, batch_size = bs,
                validation_split = valsplit,
                callbacks = c(early_stopping)
        )
        
        loss = model %>% evaluate(test_2, test_1, verbose = 0)
        return(c(model,loss))
}