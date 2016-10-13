require(R.matlab)


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

#### exploration

log$pic_duration <- log$picoffset - log$piconset

#### peak detection with Kubios


exg1_crop <- ecg$EXG1[ecg_events[1,3]:length(ecg$EXG1)]
exg2_crop <- ecg$EXG2[ecg_events[1,3]:length(ecg$EXG2)]

#exg1_crop_resamp <- resample(exg1_crop, 1000, 2048) # get resample() from signal

write.csv(exg1_crop, 'EXG1_cropped_4Kubios.csv')
write.csv(exg2_crop, 'EXG2_cropped_4Kubios.csv')

exg1_peaks <- read.csv('EXG1_cropped_peaks_from_Kubios.txt')
exg2_peaks <- read.csv('EXG2_cropped_peaks_from_Kubios.txt')

exg1_peaks <- as.vector(exg1_peaks[,1])
exg2_peaks <- as.vector(exg2_peaks[,1])


#### analyse encoding

diff_ecg_log <- ecgonset_s 
log$clickonset_ecgtime_s <- (log$clickonset/1000 - logonset_s) 
log$clickonset_ecgtime_dpt <- log$clickonset_ecgtime_s * ecg_sf

log_encode <- subset(log, log$block == 1)

log_encode$clickonset_ecgtime_s

for (ipt in 1:length(log_encode$clickonset_ecgtime_s)) {
  

position <-  min(which(exg1_peaks > log_encode$clickonset_ecgtime_s[ipt]))
  
#  log_encode$clickonset_ecgtime_s[ipt] - exg1_peaks[position]
#  log_encode$clickonset_ecgtime_s[ipt] - exg1_peaks[position+1]
  
  
  
}



