#-------------------- Data Preprocessing --------------------#
time_series <- function(data, nlags, nfeatures) {
        for (i in 1:nlags) {
                for (j in 1:nfeatures) {
                        if (i==nlags) {
                                ntemp = paste("feat",j,"(t)",sep="")
                                data[ntemp] = shift(data[[j]],i)
                                break
                        } else {
                                ntemp = paste("feat",j,"(t-",nlags-i,")",sep="")
                                data[ntemp] = shift(data[[j]],i)
                        }
                }
        }  
        for (k in 1:nfeatures) {
                colnames(data)[k] = c(paste("feat",k,"(t-",nlags,")",sep=""))
        }
        data = head(data,-nlags)
        return(data)
}        

#-------------------- Shift function --------------------#
shift <- function(nfeatures, steps) {
        c(nfeatures[-(seq(steps))], rep(NA,steps))
}