# Real-time Audio Classification on Streaming Audio Features

Real-time streaming audio classification v1 that uses LPC features
TODO: Auditory Filterbank Temporal Envelope (AFTE) features to be added

decoding/applause.sh can be run as a WebSocket app via websocketd. 
We extract feature vectors using a Ptolemy II swarmlet and stream to gmtkOnline, which returns
decoded state streams to the Ptolemy WebSocketClient accessor. 


