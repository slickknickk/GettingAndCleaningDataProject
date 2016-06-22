setwd('C:/Users/greenhn/Desktop/Data Scientist/R/data/UCI HAR Dataset/')

activity        <- read.table("./activity_labels.txt",header = FALSE)
features        <- read.table("./features.txt", header = FALSE)

subject_train   <- read.table("./train/subject_train.txt", header = FALSE)
X_train         <- read.table("./train/X_train.txt", header = FALSE)
Y_train         <- read.table("./train/Y_train.txt", header = FALSE)

subject_test    <- read.table("./test/subject_test.txt", header = FALSE)
X_test          <- read.table("./test/X_test.txt", header = FALSE)
Y_test          <- read.table("./test/Y_test.txt", header = FALSE)

xmd <- rbind(X_train, X_test)
ymd <- rbind(Y_train, Y_test)
smd <- rbind(subject_train, subject_test)

colnames(xmd) <- features[,2]
colnames(ymd) <- "activityID"
colnames(activity) <- c("activityID","activity") 
colnames(smd) <- "subjectID"

mergedData <- cbind(smd,ymd,xmd)

stdMeanFeatures <- grep("mean|std",features[,2],ignore.case = TRUE)
stdMeanFeatures <- stdMeanFeatures + 2
stdMeanFeatures <- append(stdMeanFeatures,1:2,after=0)
stdMeanData <- mergedData[,stdMeanFeatures]

stdMeanData <- inner_join(activity, stdMeanData, by = "activityID")
stdMeanData <- select(stdMeanData,subjectID,everything(),-activityID)

names(stdMeanData) <- gsub("^t", "Time", names(stdMeanData))
names(stdMeanData) <- gsub("^f", "Frequency", names(stdMeanData))
names(stdMeanData) <- gsub("-mean\\(\\)", "Mean", names(stdMeanData))
names(stdMeanData) <- gsub("-std\\(\\)", "StdDev", names(stdMeanData))
names(stdMeanData) <- gsub("-", "", names(stdMeanData))
names(stdMeanData) <- gsub("BodyBody", "Body", names(stdMeanData))
names(stdMeanData) <- gsub("Gyro","AngularVelocity",names(stdMeanData))
names(stdMeanData) <- gsub("Acc","Acceleration",names(stdMeanData))
names(stdMeanData) <- gsub("Mag","Magnitude",names(stdMeanData))

bySubjectActivity <- group_by(stdMeanData,subjectID,activity)
bySubjectActivity <- summarize_each(bySubjectActivity,funs(mean))
names(bySubjectActivity)[-c(1,2)] <- paste0("Avg", names(bySubjectActivity)[-c(1,2)])

