# Real-time Audio Classification on Streaming Audio Features

This repository contains multiple Bayesian models trained to perform audio event classification that have been developed for the purpose of live applause detection. This application was a component of the TerraSwarm RoboCafe demo, which was presented at DARPA WaitWhat? Forum in September'15. 

## Overview 

For documentation purposes, the repository contains multiple complete GMTK models trained using labeled audio data. The latest and most mature learning model is contained under [_alpha0_.](https://github.com/ilge/gmtk-audio-classification/tree/master/alpha0) 

## GMTK and Bayesian Models

We use [GMTK](https://melodi.ee.washington.edu/gmtk/) for training and online classification purposes. Each folder contains a subfolder named decoding, which includes model parameters obtained as a result of the GMTK training process.

The models used here are hidden markov models (HMMs) with Gaussian mixture emissions. In training, a binary HMM was assumed and mixture components for each were learned. For classification, we create an HMM with 2*M states, for which each binary state is replicated M times to temporally force classification to favor lasting features of a particular class. This helps with mitigating false positives ( sounds classified to be applause when they are actually caused by intermittent clap-like ambient sounds such as clinks or bangs). The trained models contain in the order of 10-20 mixture components for each class. 


## Implementation Details

Classifying audio events often require both temporal and frequency domain signatures to be learned from raw data. For the specific task of applause detection, we experimented with Auditory Filterbank Temporal Envelope (AFTE) features. 

 
We used a raw audio signal collected by a microphone accessor at a sampling rate of 48kHz. For feature extraction, we used 1/3 s windows with an overlap window of 3200 samples (i.e., features were extracted at a rate of 15 fp). We used a filterbank of 8 channels and optimized center frequencies of the filterbank to be [377, 524, 707, 934, 1217, 1568, 2000, 2800] Hz, respectively. The output stream of each filter was processed by a low pass filter for detecting the envelope, and we finally took a 64-point FFT of each to yield features. 

As the objective of the features is to accurately identify audio envelopes belonging to applause vs non applause sounds, we ranked the features based on their discriminatory power using a combination of t-test, entropy, and KL Divergence criteria, and selected 10-20 features that are most influential in separating positive and negative samples. Note that there exist more complex feature selection/transformation/dimensionality reduction methods that could be applied (e.g., PCA), but simple selection worked well in our case. Also, note that the feature dimension dramatically affects the success probability of the HMM training phase. 

## Real-time Performance

Note that at the given frame rate, we need to perform feature extraction per frame at about 60ms for real-time classification. We perform all filtering operations of the AFTE filters, as well as the envelope extraction using Overlap-and-add FFT, with a thread pool where each channel of the filterbank is handled by a separate thread. The java implementation of the feature extractor is available [here](https://chess.eecs.berkeley.edu/ptexternal/src/ptII/org/ptolemy/machineLearning/lib/AFTEFast.java) as part of the Ptolemy tree. 

## Execution 

decoding/applause.sh can be run as a WebSocket app via websocketd. 
We extract feature vectors using a [CapeCode](capecode.org) swarmlet and stream these to gmtkOnline ( using WebSockets), which returns
decoded streams to the swarmlet. After processing the decoded stream through a smoothing filter, the results are ready to be processed by other applications. 

