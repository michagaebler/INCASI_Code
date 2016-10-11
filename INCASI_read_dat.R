require(R.matlab)
#require(RHRV)

# set working directory
setwd('D:/INCASI/Labtest/20171007') 

############### LOGFILE (FROM STIMULATION) ############### 

# read logfile
log <- read.csv('inc1mert.dat', sep = '\t') 

# name columns of logfile
colnames(log) <- c('block', 'trialnum', 'stimnum', 'oldnew', 'valence', 'dummy1', 'fixonset', 
                   'piconset', 'picoffset', 'clickonset', 'dummy2', 'rateonset', 'dummy3', 'dummy4', 'rightwrong')

# read markers of stimulation (using R.matlab package)
matinfo <- readMat('inc1mert.mat')

# check length between markers
logonset_s <- as.numeric(matinfo$const[3])
logoffset_s <- as.numeric(matinfo$const[4])

logduration_s <- logoffset_s - logonset_s 


#str(log)

############### ECG FILE ############### 

# specify ECG sampling frequency (in Hz)
ecg_sf <-  2048 # --> 1 datapoint every 0.4882812 ms (1000/2048)

# import raw data
ecg <- read.csv('20161007_Testdata_export_EXG.csv', sep = '\t')

# import markers from ECG file ("events")
ecg_events <- read.csv('20161007_Testdata_export_events.csv', sep = '\t')

# check length between markers
ecgonset_s <- ecg_events[1,3] / ecg_sf
ecgoffset_s <- ecg_events[2,3] / ecg_sf

ecgduration_s <- (ecg_events[2,3] - ecg_events[1,3]) / ecg_sf

# deviation between ECG and logfile length between markers (in s)
deviation_s <- abs(ecgduration_s - logduration_s)

