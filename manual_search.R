#-------------------- Manual Search --------------------#
manual_search <- function(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3, 
                          lr, nepochs, bs, nlayers, opt, activation, valsplit, patience) {
                
        lstm_tic = proc.time() 
        list[model,loss] = lstm(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3, lr, nepochs, bs, nlayers, opt, activation, valsplit, patience)
        
        save_model_hdf5(model, 'lstm_MS.h5')
        lstm_time <<- proc.time() - lstm_tic
        return(as.numeric(loss[1]))
}