#-------------------- hindnorm --------------------#
hindnorm <- function(data, split = 0.67) {
        
        # Default datasets
        training_def <<- as.data.frame(data[1:as.integer(dim(data)[1]*split),])
        names(training_def)[1] <<- names(data)[1]
        testing_def <<- as.data.frame(data[as.integer(dim(data)[1]*split + 1):dim(data)[1],])
        names(testing_def)[1] <<- names(data)[1]
        
        # Data normalization
        data_norm <<- data
        for (i in 1:dim(data)[2]) {
                if (!is.factor(data[,i])) {
                        data_norm[,i] <<- (data[,i] - min(data[,i]))/(max(data[,i]) - min(data[,i]))
                }
        }
        
        # Normalized datasets
        training <<- as.data.frame(data_norm[1:as.integer(dim(data_norm)[1]*split),])
        names(training)[1] <<- names(data_norm)[1]
        testing <<- as.data.frame(data_norm[as.integer(dim(data_norm)[1]*split + 1):dim(data_norm)[1],])
        names(testing)[1] <<- names(data_norm)[1]
}
