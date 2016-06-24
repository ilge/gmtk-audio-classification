# Real-time Audio Classification on Streaming Audio Features

This repository contains multiple Bayesian models trained to perform audio event classification that have been developed for the purpose of live applause detection. This application was a component of the TerraSwarm RoboCafe demo, which was presented at DARPA WaitWhat? Forum in September'15. 

## Overview 

For documentation purposes, the repository contains multiple complete GMTK models trained using labeled audio data. The latest and most mature learning model is contained under [_alpha0_.](https://github.com/ilge/gmtk-audio-classification/tree/master/alpha0) 




Real-time streaming audio classification v1 that uses LPC features
TODO: Auditory Filterbank Temporal Envelope (AFTE) features to be added

decoding/applause.sh can be run as a WebSocket app via websocketd. 
We extract feature vectors using a Ptolemy II swarmlet and stream to gmtkOnline, which returns
decoded state streams to the Ptolemy WebSocketClient accessor. 


