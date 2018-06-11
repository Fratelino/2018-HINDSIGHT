#-------------------- vision --------------------#
vision <- function(data, training_def, testing_def, predict_train, predict_test, nlags) {
        
        # Revert predictions (non-normalized)
        predict_train_back = predict_train*(max(data[,1]) - min(data[,1])) + min(data[,1])
        predict_test_back = predict_test*(max(data[,1]) - min(data[,1])) + min(data[,1])
        
        # Residuals for training -- With error correction *predictions left-shifted by one*
        residuals_train = predict_train_back - training_def[(1 + (nlags - 1)):(dim(training_def)[1] - 1),1]
        mse_train = mean(residuals_train^2) # MSE for training
        rmse_train <<- sqrt(mse_train) # RMSE for training
        
        # Residuals for testing -- With error correction *predictions left-shifted by one*
        residuals_test = predict_test_back - testing_def[(1 + (nlags - 1)):(dim(testing_def)[1] - 1),1]
        mse_test = mean(residuals_test^2) # MSE for testing
        rmse_test <<- sqrt(mse_test) # RMSE for testing
        
        # Visualization
        index = c(1:dim(data)[1])
        plot(index, data[,1], xlab='samples (time)', ylab = 'value')
        lines(index, data[,1], lwd = 2)
        index = c((1 + (nlags - 1)):(length(predict_train_back) + nlags - 1))
        lines(index, predict_train_back[,1], col=2, lty = 2, lwd = 2)
        index = c(((length(predict_train_back) + nlags) + nlags):dim(data)[1])
        lines(index, predict_test_back[,1], col=3, lty = 4, lwd = 2)
}       
