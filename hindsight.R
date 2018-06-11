#-------------------- hindsight --------------------#
hindsight <- function(training, testing, nfeatures, nlags, units = 10, units1 = 10, units2 = 10, units3 = 10, 
                      lrate = 0.001, nepochs = 50, bs = 32, nlayers = 1, opt = 1, activation = 1, valsplit = 0.1, patience = 10,
                      rs = FALSE, niter = 20, units_l = 256, units1_l = 256, units2_l = 256, units3_l = 256,
                      lrate_l = 0.01, nepochs_l = 150, bs_l = 128, nlayers_l = 4, opt_l = 4) {
        
        # Preprocessing of the training set
        training = time_series(training, nlags, nfeatures)
        
        # Find the position of the first factor (if any)
        pos = nlags*nfeatures + 1
        for (i in 1:nfeatures) {
                if (is.factor(training[,i])) {
                        pos = i              
                        break
                }
        }

        # Prepare training sets for LSTM
        train_1 = matrix(training[,ncol(training)])
        train_2 = model.matrix(~ . + 0, data = as.data.frame(training[,-ncol(training)]))
        # Remove the column at the <pos> position (if any factor exists)
        if (nlags!=1){
                if (dim(train_2)[2] %% nlags == 1) {
                        train_2 = train_2[,-pos]
                }
        } else {
                if (pos != (nlags*nfeatures + 1)) {
                        train_2 = train_2[,-pos]
                }
        }
        # Estimate the number of features for the second array (training)
        nfeat = dim(train_2)[2]/nlags
        train_2 <- array(train_2, dim=c(dim(train_2)[1], nlags, nfeat))
        
        # Preprocessing of the testing set
        testing = time_series(testing, nlags, nfeatures)
        
        # Find the position of the first factor (if any)
        pos = nlags*nfeatures + 1
        for (i in 1:nfeatures) {
                if (is.factor(testing[,i])) {
                        pos = i              
                        break
                }
        }
        
        # Prepare testing sets for LSTM
        test_1 = matrix(testing[,ncol(testing)])
        test_2 = model.matrix(~ . + 0, data = as.data.frame(testing[,-ncol(testing)]))
        # Remove the column at the <pos> position (if any factor exists)
        if (nlags!=1){
                if (dim(test_2)[2] %% nlags == 1) {
                        test_2 = test_2[,-pos]
                }
        } else {
                if (pos != (nlags*nfeatures + 1)) {
                        test_2 = test_2[,-pos]
                }
        }
        # Estimate the number of features for the second array (testing)
        nfeat = dim(test_2)[2]/nlags
        test_2 <- array(test_2, dim=c(dim(test_2)[1], nlags, nfeat))
        
        if (isTRUE(rs)) {
                # Random Search function
                loss = random_search(train_1, train_2, test_1, test_2, nfeat, nlags, units, units1, units2, units3,
                                     lr, nepochs, bs, nlayers, opt, activation, valsplit, patience, niter,
                                     units_l, units1_l, units2_l, units3_l, lr_l, nepochs_l, bs_l, nlayers_l, opt_l)
                save.image("HINDSIGHT_RS.RData")
        } else {
                # Manual Search function
                loss = manual_search(train_1, train_2, test_1, test_2, nfeat, nlags, units, units1, units2, units3, 
                                     lr, nepochs, bs, nlayers, opt, activation, valsplit, patience)
                save.image("HINDSIGHT_MS.RData")
        }
        return (loss)
}
