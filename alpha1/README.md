# WaitWhat Demo Audio Event Detection Model

## Overview
This training model is the first stable live version to be used during the demo. The training is performed on a 10-dimensional feature space where features are selected from 264 FFT features collected on 8 gammatone filterbank outputs with center frequencies {377, 524, 707, 934, 1217, 1568,2000,2800}. 

###Features

Feature selection is based on a combined voting scheme according to four criteria:
- Bhattacharyya distance
- ROC
- Entropy
- T-test

### Training
The selected features are used to train a binary Hidden Markov Model (HMM) with Gaussian Mixture emissions. Test have shown that training for 16 mixture components yields optimal results in decoding. 

To avoid having convergence problems during training, we choose to have up to 20 features, leading to 20 dimensional Gaussian mixtures with diagonal covariance matrices. To back-up this assumption, during feature selection, we use cross-correlation weighting to avoid selecting features that are heavily correlated, i.e., consecutive FFT coefficients of a single Gammatone Filterbank output. 

### Decoding

There are two decoding models checked in. The first one uses the same binary HMM as in the training set, whereas the second one uses a 10-state  HMM where the first 5 states are the zero state substates, and the last five are designed to be the "one" state's substates. Each substate clique uses the trained GMM from the binary training HMM. The intuition behind using a larger test HMM is to add some hysteresis to the superstates, such that false positives are largely mitigated. 

The negative Binomial duration distribution of each superstate is adjusted to have an average duration of 15 frames. At the current frame rate of the WebSocket application (15 fps), this corresponds to a mean event time of 1 second.



  
