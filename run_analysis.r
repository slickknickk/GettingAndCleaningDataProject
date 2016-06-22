##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Nick Greenhagen
## 2016-06-22

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('C:/Users/greenhn/Desktop/Data Scientist/R/data/UCI HAR Dataset/')

# Read in the data from files
activity        <- read.table("./activity_labels.txt",header = FALSE)
features        <- read.table("./features.txt", header = FALSE)

subject_train   <- read.table("./train/subject_train.txt", header = FALSE)
X_train         <- read.table("./train/X_train.txt", header = FALSE)
Y_train         <- read.table("./train/Y_train.txt", header = FALSE)

subject_test    <- read.table("./test/subject_test.txt", header = FALSE)
X_test          <- read.table("./test/X_test.txt", header = FALSE)
Y_test          <- read.table("./test/Y_test.txt", header = FALSE)

# 1. Merge the training and the test sets to create one data set.
xmd <- rbind(X_train, X_test)
ymd <- rbind(Y_train, Y_test)
smd <- rbind(subject_train, subject_test)

# Assigin column names to the imported data
colnames(xmd) <- features[,2]
colnames(ymd) <- "activityID"
colnames(activity) <- c("activityID","activity") 
colnames(smd) <- "subjectID"

# Create final merged data set
mergedData <- cbind(smd,ymd,xmd)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
stdMeanFeatures <- grep("mean|std",features[,2],ignore.case = TRUE)
stdMeanFeatures <- stdMeanFeatures + 2
stdMeanFeatures <- append(stdMeanFeatures,1:2,after=0)
stdMeanData <- mergedData[,stdMeanFeatures]

# 3. Use descriptive activity names to name the activities in the data set
library(dplyr)
stdMeanData <- inner_join(activity, stdMeanData, by = "activityID")
stdMeanData <- select(stdMeanData,subjectID,everything(),-activityID)

# 4. Appropriately label the data set with descriptive variable names.
names(stdMeanData) <- gsub("^t", "Time", names(stdMeanData))
names(stdMeanData) <- gsub("^f", "Frequency", names(stdMeanData))
names(stdMeanData) <- gsub("-mean\\(\\)", "Mean", names(stdMeanData))
names(stdMeanData) <- gsub("-std\\(\\)", "StdDev", names(stdMeanData))
names(stdMeanData) <- gsub("-", "", names(stdMeanData))
names(stdMeanData) <- gsub("BodyBody", "Body", names(stdMeanData))
names(stdMeanData) <- gsub("Gyro","AngularVelocity",names(stdMeanData))
names(stdMeanData) <- gsub("Acc","Acceleration",names(stdMeanData))
names(stdMeanData) <- gsub("Mag","Magnitude",names(stdMeanData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
bySubjectActivity <- group_by(stdMeanData,subjectID,activity)
bySubjectActivity <- summarize_each(bySubjectActivity,funs(mean))
names(bySubjectActivity)[-c(1,2)] <- paste0("Avg", names(bySubjectActivity)[-c(1,2)])

# Export the data sets 
write.table(stdMeanData, 'C:/Users/greenhn/Desktop/Data Scientist/R/GettingAndCleaningDataProject/stdMeanData.txt',row.names=TRUE,sep='\t')
write.table(bySubjectActivity, 'C:/Users/greenhn/Desktop/Data Scientist/R/GettingAndCleaningDataProject/bySubjectActivity.txt',row.names=TRUE,sep='\t')
