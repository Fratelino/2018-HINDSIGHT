#-------------------- manual_search --------------------#
manual_search <- function(train_1, train_2, test_1, test_2, nfeat, nlags, units, units1, units2, units3, 
                          lr, nepochs, bs, nlayers, opt, activation, valsplit, patience) {
                
        lstm_tic = proc.time() # Start timer

        list[model,loss] = lstm(train_1, train_2, test_1, test_2, nfeat, nlags, units, units1, units2, units3,
                                lr, nepochs, bs, nlayers, opt, activation, valsplit, patience)
        loss_ms = as.numeric(loss[1])
        save_model_hdf5(model, 'lstm_MS.h5')
        
        lstm_time <<- proc.time() - lstm_tic # End timer
        
        # Estimate predictions
        predict_train <<- model %>% predict(train_2)
        predict_test <<- model %>% predict(test_2)
        
        return(loss_ms)
}