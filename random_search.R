#-------------------- Random Search --------------------#
random_search <- function(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3, 
                          lr, nepochs, bs, nlayers, opt, activation, valsplit, patience, niter,
                          units_l, units1_l, units2_l, units3_l, lr_l, nepochs_l, bs_l, nlayers_l, opt_l) {

        gridtable <<- data.frame(units = integer(),
                           units1 = integer(), 
                           units2 = integer(),
                           units3 = integer(),
                           lr = numeric(),
                           nepochs = integer(),
                           bs = integer(),
                           nlayers = integer(),
                           opt = integer(),
                           Value = numeric())
        
        lstm_tic = proc.time() 
        
        unitsc = units
        units1c = units1
        units2c = units2
        units3c = units3
        lrc = lr
        nepochsc = nepochs
        bsc = bs
        nlayersc = nlayers
        optc = opt
        
        for (i in 1:niter) {
                units = sample(unitsc:units_l, 1) 
                units1 = sample(units1c:units1_l, 1) 
                units2 = sample(units2c:units2_l, 1) 
                units3 = sample(units3c:units3_l, 1) 
                lr = runif(1, lrc, lr_l)
                nepochs = sample(nepochsc:nepochs_l, 1) 
                bs = sample(bsc:bs_l, 1) 
                nlayers = sample(nlayersc:nlayers_l, 1)
                opt = sample(optc:opt_l,1) 
                
                list[model,loss] = lstm(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3, lr, nepochs, bs, nlayers, opt, activation, valsplit, patience)
                
                if (i == 1) {
                        save_model_hdf5(model, 'lstm_RS.h5')
                        loss_rs = as.numeric(loss[1])
                } else {
                        if (as.numeric(loss[1]) < loss_rs) {
                                save_model_hdf5(model, 'lstm_RS.h5')
                                loss_rs = as.numeric(loss[1])
                        }
                }
                
               gridtable[i, ] <<- list(units, units1, units2, units3, lr, nepochs, bs, nlayers, opt, as.numeric(loss[1]))
        }
        
        lstm_time <<- proc.time() - lstm_tic
        return(loss_rs)
}