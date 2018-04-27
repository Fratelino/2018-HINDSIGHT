#-------------------- Main Function of HINDSIGHT --------------------#
hindsight <- function(training, testing, nfeatures, nlags = 2, units = 10, units1 = 10, units2 = 10, units3 = 10, 
                      lr = 0.01, nepochs = 20, bs = 32, nlayers = 1, opt = 1, activation = 1, valsplit = 0.1, patience = 5,
                      rs = FALSE, niter = 2, units_l = 256, units1_l = 256, units2_l = 256, units3_l = 256,
                      lr_l = 0.1, nepochs_l = 100, bs_l = 128, nlayers_l = 4, opt_l = 4) {
        
        # Preprocessing of the training set
        training = time_series(training, nlags, nfeatures)
        
        # Prepare training sets for LSTM
        train_1 = matrix(training[,ncol(training)])
        train_2 = data.matrix(training[,-ncol(training)])
        train_2 <- array(train_2, dim=c(dim(training)[1], nlags, nlags*nfeatures))
        
        # Preprocessing of the testing set
        testing = time_series(testing, nlags, nfeatures)
        
        # Prepare testing sets for LSTM
        test_1 = matrix(testing[,ncol(testing)])
        test_2 = data.matrix(testing[,-ncol(testing)])
        test_2 <- array(test_2, dim=c(dim(testing)[1], nlags, nlags*nfeatures))
        
        if (isTRUE(rs)) {
                # Random Search
                loss = random_search(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3,
                                     lr, nepochs, bs, nlayers, opt, activation, valsplit, patience, niter,
                                     units_l, units1_l, units2_l, units3_l, lr_l, nepochs_l, bs_l, nlayers_l, opt_l)
                save.image("HINDSIGHT_RS.RData")
        } else {
                # Manual Search
                loss = manual_search(train_1, train_2, test_1, test_2, nfeatures, nlags, units, units1, units2, units3, 
                                     lr, nepochs, bs, nlayers, opt, activation, valsplit, patience)
                save.image("HINDSIGHT_MS.RData")
        }
        return (loss)
}
