# Real-time Audio Classification on Streaming Audio Features

## Auditory Filterbank Temporal Envelope Features
Trial #4 with 25 Features, obtained from 5 channels of the Gammatone filterbank with center frequencies of [3220, 4058,5099,6393,8001] Hz, respectively.
The feature vectors for each channel correspond to the following FFT coefficients out of a 64-point FFT for a frame length of 1/3 seconds and a sampling rate of 100Hz. Features 2-5 are normalized by the DC term.
- DC
-  X(1)-X(5)
- X(6)-X(10)
-  X(11)-X(15)
-   X(16)-X(20)

