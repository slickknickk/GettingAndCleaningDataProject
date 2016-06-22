# GettingAndCleaningDataProject
Course Project for Getting and Cleaning Data

The run_analysis.r script will perform the following steps on the UCI HAR Dataset downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Execution
1. Download source data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Extract Zip to desired folder.
3. Modify run_analysis.r to set the working directory at the beginning of the script to the location of the UCI data set.
4. Modify run_analysis.r to set the working directory at the end of the script to the output directory for the tidy data sets.
5. Run Script

# Dependencies
Requires dplyr library.
