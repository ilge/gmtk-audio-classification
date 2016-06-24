# Real-time Audio Classification on Streaming Audio Features

This repository contains multiple Bayesian models trained to perform audio event classification that have been developed for the purpose of live applause detection. This application was a component of the TerraSwarm RoboCafe demo, which was presented at DARPA WaitWhat? Forum in September'15. 

## Overview 

For documentation purposes, the repository contains multiple complete GMTK models trained using labeled audio data. The latest and most mature learning model is contained under [_alpha0_.](https://github.com/ilge/gmtk-audio-classification/tree/master/alpha0) 

## Feature selection

Classifying audio events often require both temporal and frequency domain signatures to be learned from raw data. For the specific task of applause detection, we experimented with Auditory Filterbank Temporal Envelope (AFTE) features. 

 

## Execution 

decoding/applause.sh can be run as a WebSocket app via websocketd. 
We extract feature vectors using a [CapeCode](capecode.org) swarmlet and stream these to gmtkOnline ( using WebSockets), which returns
decoded streams to the swarmlet. After processing the decoded stream through a smoothing filter, the results are ready to be processed by other applications. 

## Real-time Implementation

We used a raw audio signal collected by a microphone accessor at a sampling rate of 48kHz. For feature extraction, we used 1/3 s windows with an overlap window of 3200 samples (i.e., features were extracted at a rate of 15 fp). We used a filterbank of 8 channels and optimized center frequencies of the filterbank to be [377, 524, 707, 934, 1217, 1568, 2000, 2800] Hz, respectively. The output stream of each filter was processed by a low pass filter for detecting the envelope, and we finally took a 64-point FFT of each to yield features. 

As the objective of the features is to accurately identify audio envelopes belonging to applause vs non applause sounds, we ranked the features based on their discriminatory power using a combination of t-test, entropy, and KL Divergence criteria, and selected 10-20 features that are most influential in separating positive and negative samples. Note that there exist more complex feature selection/transformation/dimensionality reduction methods that could be applied (e.g., PCA), but simple selection worked well in our case. Also, note that the feature dimension dramatically affects the success probability of the HMM training phase. 




