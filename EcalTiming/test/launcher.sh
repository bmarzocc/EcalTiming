#! /bin/bash

##############################################################################
#                                     USAGE                                  #
#                                                                            #
#   ./launcher.sh /store/data/Run2015B/AlCaP0/RAW/v1/000/ 251 562 "AlCaP0"   #
##############################################################################

cd /afs/cern.ch/work/s/sgelli/public/CMSSW_7_4_4_patch4/src/
export SCRAM_ARCH='slc6_amd64_gcc491'
eval `scramv1 runtime -sh`
source /afs/cern.ch/project/eos/installation/cms/etc/setup.sh 
EOSCMD="/afs/cern.ch/project/eos/installation/cms/bin/eos.select"

#FILES=$($EOSCMD ls /eos/cms/store/data/Run2015B/AlCaP0/RAW/v1/000/251/562/00000/)
#$EOSCMD ls /eos/cms/store/data/Run2015B/AlCaP0/RAW/v1/000/251/562/00000/ >test.txt

#for files in $FILES
#do
#  echo "Input " $files
#done

#echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

#while read line
#do
#  echo "Input " $line
#
#done</afs/cern.ch/work/s/sgelli/public/CMSSW_7_4_4_patch4/src/test.txt

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

#all dataset study - $1 example: /store/data/Run2015B/AlCaPhiSym/RAW/v1/000/
if [ -z "$2" ]  && [ -z "$3" ]; then #-n is true when a variable is NOT null, -z is true when a variable IS null !!! remember the spaces !!! one after the bracket and one before !!! Otherwise it     doesn't work
  
  echo "++++++++++++++++++++++++++";
  echo "+  Single Dataset Study  +";
  echo "++++++++++++++++++++++++++";

  TESTS=$($EOSCMD ls "/eos/cms/"$1)
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  fileList="'"
  echo "FOLDER"
  for test in $TESTS
  do
    echo "Input folders " $test
    secondFolders=$($EOSCMD ls "/eos/cms/"$1"/"$test)
    for secondFolder in $secondFolders
    do
      echo "second folders " $secondFolder
      realFiles=$($EOSCMD ls "/eos/cms/"$1/$test/$secondFolder/00000/)
      for realFile in $realFiles
      do
        #echo "path " $1/$test/$secondFolder/00000/$realFile
        fileList+=$"$1/$test/$secondFolder/00000/$realFile, "
      done
    done
  
  done
  fileList=${fileList%??} #to remove the ", " chars from the file string
  fileList+="'"
  echo "-------------------------------------------------------------------------" 
  echo $fileList
  echo "-------------------------------------------------------------------------"

else
  #Single run study - as before $1 example: /store/data/Run2015B/AlCaPhiSym/RAW/v1/000/ $2 example: 251 $3 example: 562 -> study only the run 251562 from PhiSym stream

  echo "++++++++++++++++++++++"
  echo "+  Single Run Study  +"
  echo "++++++++++++++++++++++"

  TEST1=$($EOSCMD ls "/eos/cms/"$1"/"$2"/"$3"/00000/")
  
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  
  #echo $TEST1
  
  
  #fileListSingle="'"
  for test1 in $TEST1
  do
    fileList+=$"$1/$2/$3/00000/$test1, "
    #echo "Input test1 " $test1
   
  done
  fileList=${fileList%??}
  #fileListSingle+="'"
  echo $fileList
  
  #cmsRun /afs/cern.ch/work/s/sgelli/public/CMSSW_7_4_4_patch4/src/EcalTiming/EcalTiming/test/ecalTime_fromAlcaStream_cfg.py files="$fileList"
  
fi 

echo $CMSSW_BASE
cd $CMSSW_BASE/src/EcalTiming/EcalTiming/test/


cmsRun ecalTime_fromAlcaStream_cfg.py files="$fileList" output="output/run"${2}${3}"_"${4}".root" streamName=$4 
#cmsRun ecalTime_fromAlcaStream_cfg.py files='/store/data/Run2015A/AlCaP0/RAW/v1/000/246/908/00000/581F78FF-D909-E511-A356-02163E01231F.root, /store/data/Run2015A/AlCaP0/RAW/v1/000/246/908/00000/581F78FF-D909-E511-A356-02163E01231F.root' streamName=$4
