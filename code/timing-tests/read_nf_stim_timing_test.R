

#######  www.ndclab.com   ###########
# By: Kianoosh Hosseini at NDCLab@FIU  
# This script reads text files that include triggers sent to the recorder laptop.
# This script needed to be changed for different timing tests.
# These files have ".vmrk" extension.

# Last update: Sep. 9th, 2024

# install.packages("pracma")
library(stringr)
library(pracma)
library(dplyr)

# Change the address below to where you have stored vmrk filesz.
path <- ("C:/Users/cknowlto/Documents/read-study2-dataset/code/timing-tests")
# Change the address below to name of the vmrk file name.
mrkTxt <- readLines(paste(path, "/sys1_2025-10-07_arrow-alert-nf-v1-2-timing-test_stim_timing.vmrk", sep = "")) # load the .vmrk file into the workspace.
myDat <- setNames(data.frame(matrix(nrow = length(mrkTxt), ncol = 1)), c("colA")) # creates an empty data frame with a single column and row # = length(mrkTxt)

# This 'for' loop creates a dataframe from the loaded text file. 
for (i in 1:length(mrkTxt)) {
  myDat[i, 1] <- mrkTxt[i]
  
}

# Keep rows that have the string "Stimulus"
newDat <- myDat %>%
  filter(
    str_detect(colA, "Stimulus")
  )
# Let's delete all the strings to "Stimulus,"
for (i in 1:nrow(newDat)) {
  newDat$colB[i] <- gsub(".*Stimulus,", "", newDat$colA[i]) 
}

# Let's delete all the strings after the ms of the sent marker!
for (i in 1:nrow(newDat)) {
  newDat$colC[i] <- gsub(",1,0*.", "", newDat$colB[i]) 
}

newDat <- subset(newDat, select = -c(colA, colB)) # removing the colA and colB columns.
proc_fileName <- "stim_timing_output.csv"
write.csv(newDat,paste(path,proc_fileName, sep = "/", collapse = NULL), row.names=FALSE)

newDat <- read.csv(paste(path,proc_fileName, sep = "/", collapse = NULL))
# add a piece of code to count the number of stimuli. The actual number should be 800 trials. Any deviation from this 800
# should be flagged.


########################################################################################################################
########## RUN THE CODE BELOW If YOU WANT RUN TIMING TEST USING The SOCIAL and NON-SOCIAL Conditions.###################
########################################################################################################################


flanker_dat <- setNames(data.frame(matrix(ncol = 1)), c("timeDiff")) # creating an empty data frame that will be filled with time difference values!
dVal <- setNames(data.frame(matrix(ncol = 1)), c("timeDiff"))

# If you wana perform the flanker timing test for stimulus presentation run the code below!
for (i in 1:nrow(newDat)) {
  if (str_detect(newDat$colC[i], "S128")) {
    if (i != 1){
      if ( str_detect(newDat$colC[i-1], "S 41")  || str_detect(newDat$colC[i-1], "S 42") || str_detect(newDat$colC[i-1], "S 43") || str_detect(newDat$colC[i-1], "S 44")){
        secondVal <- str2num(gsub(".*S128,", "", newDat$colC[i]))
        firstVal <- str2num(gsub(".*,", "", newDat$colC[i-1]))
        diffVal <- secondVal - firstVal
        dVal[1,] <- diffVal
        flanker_dat <- rbind(flanker_dat, dVal)

      } else if (str_detect(newDat$colC[i-1], "S 51")  || str_detect(newDat$colC[i-1], "S 52") || str_detect(newDat$colC[i-1], "S 53") || str_detect(newDat$colC[i-1], "S 54")){
        secondVal <- str2num(gsub(".*S128,", "", newDat$colC[i]))
        firstVal <- str2num(gsub(".*,", "", newDat$colC[i-1]))
        diffVal <- secondVal - firstVal
        dVal[1,] <- diffVal
        flanker_dat <- rbind(flanker_dat, dVal)
      }
    }
  } else {
    next
  }
}
flanker_dat <- na.omit(flanker_dat, na.action = "omit")
# THE AVERAGE of Stimulus TIME OFFSET
time_offset_avg <- mean(flanker_dat$timeDiff)
### Printing output
print(paste("The average time offset is ", time_offset_avg))
#### end of printing output
# THE SD of Stimulus TIME OFFSET
time_offset_sd <- sd(flanker_dat$timeDiff)
print(paste("The Standard Deviation (SD) of time offset is ", time_offset_sd))

# The following line tells you the number of flanker trials.
# It should be 800. If it is different (especially, low), it means there is sth wrong and need to
# be examined.
print(paste("Number of flanker task markers are", nrow(flanker_dat)))

######################################### END of SOCIAL AND NONSOCIAL TIMING TEST ######################################
########################################################################################################################


########################################################################################################################
########## RUN THE CODE BELOW If YOU WANT RUN TIMING TEST USING ONLY PRACTICE TRIALS.###################################
########################################################################################################################

practice_dat <- setNames(data.frame(matrix(ncol = 1)), c("timeDiff")) # creating an empty data frame that will be filled with time difference values!
dVal <- setNames(data.frame(matrix(ncol = 1)), c("timeDiff"))


# If you wana perform the flanker timing test for stimulus presentation run the code below!
for (i in 1:nrow(newDat)) {
  if (str_detect(newDat$colC[i], "S128")) {
    if (i != 1){
      if ( str_detect(newDat$colC[i-1], "S  1")  || str_detect(newDat$colC[i-1], "S  2") || str_detect(newDat$colC[i-1], "S  3") || str_detect(newDat$colC[i-1], "S  4")){
        secondVal <- str2num(gsub(".*S128,", "", newDat$colC[i]))
        firstVal <- str2num(gsub(".*,", "", newDat$colC[i-1]))
        diffVal <- secondVal - firstVal
        dVal[1,] <- diffVal
        practice_dat <- rbind(practice_dat, dVal)
      }
    }
  } else {
    next
  }
}


practice_dat <- na.omit(practice_dat, na.action = "omit")
mean(practice_dat$timeDiff)
sd(practice_dat$timeDiff)


################################################ END of PRACTICE TIMING TEST ###########################################
########################################################################################################################

######## Below is the timing test results for the Flanker task of the READ study task on October 6, 2025 - System 2######
# stimulus triggers
# mean(flanker_dat$timeDiff)
# 10.7583333333333
# sd(flanker_dat$timeDiff)
# 1.52674351414939
# nrow(flanker_dat)
# 720

######## Below is the timing test results for the Flanker task of the READ study task on October 6, 2025 - System 1######
# stimulus triggers
# mean(flanker_dat$timeDiff)
# 11.8263888888889
# sd(flanker_dat$timeDiff)
# 1.46886964720779
# nrow(flanker_dat)
# 720




