# HINDSIGHT #

## Framework Description ##
-----------------------------------------------
* HINDSIGHT -- An R-based Framework Towards Long Short Term Memory (LSTM) Optimization 
* Hyperparameter Optimization algorithms -- Manual Search (MS), Random Search (RS)
* Version 1.1 (previous 1.0)

## Source Files ##
-----------------------------------------------
* `hindnorm.R` -- Feature normalization
* `hindsight.R` -- The main function of HINDSIGHT
	* `time_series.R` -- Data pre-processing
	* `manual_search.R` -- Manual Search 
	* `random_search.R` -- Random Search
		* `lstm.R` -- Building LSTM Networks
* `vision.R` -- Calculate RMSE for training and testing (with Error Correction) - Results visualization 

.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* `hindtest.R` -- A proof of concept test file
* `README.md`
* `monroesets.RData` -- .RData image (*training, testing*) > More information regarding the MONROE-Nettest features can be found in https://www.netztest.at/en/OpenDataSpecification.html.
	* IMPORTANT NOTE: If data contains factor variables, levels must be integer encoded (not text). HINDSIGHT uses one-hot encoding during pre-processing.


## hindsight.R: Input Parameters ##
-----------------------------------------------
- `training`: Training dataset. The dependent variable **must** reside in the first column of the dataframe. This field is compulsory. 
- `testing`: Testing dataset. The dependent variable **must** reside in the first column of the dataframe. This field is compulsory. 
- `nfeatures`: No. features to be used as independent variables. This field is compulsory.
- `nlags`: No. time steps to 'look back' in time. This field is compulsory.
- `units`: No. neurons for the input layer. DEFAULT value is set to 10.
- `units1`: No. neurons for hidden layer 1. DEFAULT value is set to 10.
- `units2`: No. neurons for hidden layer 2. DEFAULT value is set to 10.
- `units3`: No. neurons for hidden layer 3. DEFAULT value is set to 10.
- `lr`: Learning rate. DEFAULT value is set to 0.001.
- `nepochs`: No. epochs during training phase. DEFAULT value is set to 50.
- `bs`: Batch size. DEFAULT value is set to 32 samples.
- `nlayers`: No. layers. By DEFAULT, only one layer is used.
- `opt`: Optimization algorithms list. **sgd = 1**, **adam = 2**, **rmsprop = 3**, **adagrad = 4**. By DEFAULT, **sgd** is used.
- `activation`: Activation function. **relu = 1**, **sigmoid = 2**, **softmax = 3**, **NULL = 4**. By DEFAULT, **relu** is used.
- `valsplit`: Validation split. DEFAULT value is set to 0.1.
- `patience`: Patience for the early stopping callback. DEFAULT value is set to 10.
- `rs`: A boolean flag to select between Manual Search (FALSE) and Random search (TRUE). DEFAULT value is set to FALSE.
- `niter`: No. iterations for Random Search. DEFAULT value is set to 20.
* (The parameters below should be only configured if rs = TRUE. They define the upper limit values for the hyperparameters.)
	- `units_l` = 256 
	- `units1_l` = 256 
	- `units2_l` = 256 
	- `units3_l` = 256
	- `lr_l` = 0.01 
	- `nepochs_l` = 150
	- `bs_l` = 128 
	- `nlayers_l` = 4
	- `opt_l` = 4

## Prerequisites ##
-----------------------------------------------
* Install the R Keras package from CRAN as: 
	* `install.packages("keras")`
* Load Keras library and install the tensorflow backend with CPU support:
	* `library(keras)`
	* `install_keras()`
* (Optional) -- Install the tensorflow backend with GPU support. Ensure that all required CUDA and CUDNN libraries have already been installed in your system > More information can be found in https://tensorflow.rstudio.com/installation_gpu.html#prerequisites:
	* `install_keras(tensorflow = "gpu")`

## Designing LSTM Networks -- Get Started ##
-----------------------------------------------
* Clone the HINDSIGHT repository locally.
* Run hindtest.R script as:
	* `Rscript hindtest.R`
* This testing script 
	* Loads all required functions.
	* Loads the datasets (testing and training).
	* Calls *hindnorm* function as:
		* `hindnorm(data)`
	* Calls *hindsight* function as:
		* `hindsight (training, testing, nfeatures = 5, nlags = 1)`
	* Saves an image to the current directory as HINDSIGHT_MS.RData. The image can be loaded as follows:
		* `load('HINDSIGHT_MS.RData')`
	* Calls *vision* function as: 
		* `vision(data, training_def, testing_def, predict_train, predict_test, nlags = 1)`

* Alternatively, install Rstudio from web (any version) and experiment with the input parameters.

### Contact Details ###
-----------------------------------------------
* Konstantinos Kousias (kostas@simula.no)
* Michael Riegler (michael@simula.no)
* Ozgu Alay (ozgu@simula.no)
* Antonios Argyriou (anargyr@uth.gr)