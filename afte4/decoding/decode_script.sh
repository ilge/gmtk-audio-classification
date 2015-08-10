#! /bin/sh 

export TKSRC="/Users/oldilge/Documents/gmtk-1.3.2/tksrc";
if [ x"$TKSRC" = x ]; then
  echo ERROR: you must set the TKSRC environment variable to 
  echo the directory containing the GMTK executables.
  exit 5
fi

# byte-swap the observation files, since the .pfile endianness 
# doesn't match the CPU endianness
ISWP="T"

# This script splits up the decoding work across NUMPROCS
# parallel processes. Assuming you have a multi-core CPU, 
# you can set NUMPROCS equal to the number of available cores.
# This line just sets the default (which is 2) in case the
# NUMPROCS environment variable is not defined
: ${NUMPROCS:=2}

# -of1 specifies the data file to decode, in this case the TIMIT
# core test set. -trans A@normalize applies a mean subtraction 
# and unit variance transformation to the observed MFCC data. The
# normalize file was produced by the obs-stats program.
#OFARGS="-of1 DATA/core_test_mfcc.pfile -iswp1 $ISWP -trans1 A@normalize"
#OFARGS="-of1 DATA/core_test_mfcc.pfile -iswp1 $ISWP"

# STRFILE specifies the graph structure of the decoding model
STRFILE=applause_detector.str

# MASTERFILE specifies some of the numerical parameters of the decoding model
MASTERFILE=applause_detector.mtr

# Number of components in the GMMs
NUMCOMPONENTS=128

# TRAINEDFILE specifies the numerical parameters of the model that were
# learned via the gmtkEMtrain program (see the frame_boot_train_command
# and seq_boot_train_command scripts)
TRAINEDFILE=${NUMCOMPONENTS}comp-frame.gmp

# The MASTERFILE is shared by both the training and decoding models,
# since they share much of the same content. However, the decoding
# model defines a few extra parameters. To avoid error messages about
# the decodig-specific parameters being unsed during training, they
# are removed by the C pre-processor unless the DECODING macro is
# defined. So, this defines it to enable them since we are decoding.
CPPARGS="-DDECODING"

# Some error checking
if [ ! -f ${STRFILE}.trifile ]; then
  echo ERROR: ${STRFILE}.trifile is missing. Run tricommand
  exit 5
fi
if [ ! -f ${TRAINEDFILE} ]; then
  echo NOTICE: $TRAINEDFILE is missing. 
  echo Using golden/${NUMCOMPONENTS}comp-frame.gmp instead
  TRAINEDFILE=golden/${NUMCOMPONENTS}comp-frame.gmp
  echo Run frame_boot_train_command if you want to train the model yourself
fi

OBSPATH=$TKSRC
if [ ! -f $TKSRC/obs-info ]; then
  if [ -f $TKSRC/../featureFileIO/obs-info ]; then
    OBSPATH=$TKSRC/../featureFileIO
  else
    echo ERROR: I could not find the GMTK obs-info program.
    echo I looked in $TKSRC and $TKSRC/../featureFileIO
    echo You may need to adjust your TKSRC environment variable
    echo or build and install GMTK
    exit 5
  fi
fi

# These arrange to terminate any child gmtkViterbi processes
# if the main script exits early for some reason (say ^C)
trap "exit" INT TERM
trap "kill 0" EXIT

# Error reporting function
function panic {
  echo An error occurred. See $1
  exit 5
}


# To split the work evenly over NUMPROCS processes, we need to know
# how many utterances there are to decode. The obs-info program
# tells us that.
declare -i NUMSEGMENTS=`$OBSPATH/obs-info $OFARGS | awk '{print $3}'`

# Create directories for the log & output files
if [ ! -d logs ]; then
  mkdir logs
fi
if [ ! -d decoded ]; then
  mkdir decoded
fi

# Divide up the work. If it doesn't divide evenly, the
# first extraDCDRNG processes get 1 extra utterance to decode.
DCDRNGinc=`expr $NUMSEGMENTS / $NUMPROCS`
extraDCDRNG=`expr $NUMSEGMENTS % $NUMPROCS`

# Launch the NUMPROCS gmtkViterbi processes. Each one will 
# decode utterances DCDRNGstart:DCDRNGend
DCDRNGstart=0
DCDRNGend=`expr $DCDRNGinc - 1`
for (( p=0 ; p < $NUMPROCS ; p+=1 )); do
  if test $p -lt $extraDCDRNG ; then
    DCDRNGend=`expr $DCDRNGend + 1`
  fi
  DCDRNG=$DCDRNGstart:$DCDRNGend

  zp=`printf %03u $p`
  echo Decoding $DCDRNG
  json2stream 62 0 |\
  $TKSRC/gmtkOnline \
       -os1 - -nf1 62 -fmt1 ascii \
      -inputMasterFile $MASTERFILE \
      -inputTrainable $TRAINEDFILE \ 
      $* > logs/decode_$DCDRNG.log 2>&1 &

# This tracks the child processes for error checking
  decodepid[$p]=$!
  logname[$p]=logs/decode_$DCDRNG.log

# update the range to decode for the next process
  DCDRNGstart=`expr $DCDRNGend + 1`
  DCDRNGend=`expr $DCDRNGstart + $DCDRNGinc - 1`
done

# wait for parallel gmtkViterbi processes to finish, and
# refer user to the log files if any reported an error
for (( p=0 ; p < $NUMPROCS ; p+=1 )); do
  wait ${decodepid[$p]} || panic ${logname[$p]}
done
