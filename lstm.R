#-------------------- lstm --------------------#
lstm <- function(train_1, train_2, test_1, test_2, nfeat, nlags, units, units1, units2, units3, 
        lr, nepochs, bs, nlayers, opt, activation, valsplit, patience) {
        
        model <- keras_model_sequential()
        
        # Optimizer selection
        if (opt==1) {
                optimizer = optimizer_sgd(lr = lr)
        } else if (opt==2) {
                optimizer = optimizer_adam(lr = lr)
        } else if (opt==3) {
                optimizer = optimizer_rmsprop(lr = lr)
        } else {
                optimizer = optimizer_adagrad(lr = lr)
        } 
        
        # Activation function selection
        if (activation==1) {
                act = "relu"
        } else if (activation==2) {
                act = "sigmoid"
        } else if (activation==3) {
                act = "softmax"
        } else {
                act = NULL
        } 
        
        # LSTM networks
        if (nlayers == 1) {
                model %>%
                        layer_lstm(units = units, return_sequences = FALSE, input_shape = c(nlags, nfeat)) %>% 
                        layer_dense(units = 1, activation = act)
        } else if (nlayers == 2) {
                model %>%
                        layer_lstm(units = units, return_sequences = TRUE, input_shape = c(nlags, nfeat)) %>% 
                        layer_lstm(units = units1) %>% 
                        layer_dense(units = 1, activation = act)
        } else if (nlayers == 3) {
                model %>%
                        layer_lstm(units = units, return_sequences = TRUE, input_shape = c(nlags, nfeat)) %>% 
                        layer_lstm(units = units1, return_sequences = TRUE) %>% 
                        layer_lstm(units = units2) %>% 
                        layer_dense(units = 1, activation = act) 
        } else {
                model %>%
                        layer_lstm(units = units, return_sequences = TRUE, input_shape = c(nlags, nfeat)) %>% 
                        layer_lstm(units = units1, return_sequences = TRUE) %>% 
                        layer_lstm(units = units2, return_sequences = TRUE) %>% 
                        layer_lstm(units = units3) %>% 
                        layer_dense(units = 1, activation = act) 
        }
        
        summary(model)
        
        model %>% compile(
                loss = "mean_absolute_error",
                optimizer = optimizer,
                metrics = c("mean_squared_error")
        )
        
        # available callbacks
        early_stopping <- callback_early_stopping(monitor = "loss", patience = patience, verbose = 1)
        tensorboard <- callback_tensorboard() # Add this callback in 'fit' if you wish to use tensorboard

        history <- model %>% fit(
                train_2, train_1,
                epochs = nepochs, batch_size = bs,
                validation_split = valsplit,
                callbacks = c(early_stopping)
        )

        loss = model %>% evaluate(test_2, test_1, verbose = 0, batch_size = bs)
        
        return(c(model,loss))
}