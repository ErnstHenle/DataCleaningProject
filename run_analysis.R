# run_analysis.R 

#######################################################
# Data and explanations:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#######################################################
# 0 Download data
ZipFileName <- "./getdata_projectfiles_UCI HAR Dataset.zip"
if(!file.exists(ZipFileName))
{
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile=ZipFileName)
}

# Assume getdata_projectfiles_UCI HAR Dataset.zip was downloaded
# read and combine train data
X_trainFileName <- "UCI HAR Dataset/train/X_train.txt"
XTrain <- read.table(unz(ZipFileName, X_trainFileName))
Y_trainFileName <- "UCI HAR Dataset/train/y_train.txt"
YTrain <- read.table(unz(ZipFileName, Y_trainFileName))
Subject_trainFileName <- "UCI HAR Dataset/train/subject_train.txt"
SubjectTrain <- read.table(unz(ZipFileName, Subject_trainFileName))
TrainSet <- cbind(XTrain, YTrain, SubjectTrain)

# 0 read and combine test data
X_testFileName <- "UCI HAR Dataset/test/X_test.txt"
XTest <- read.table(unz(ZipFileName, X_testFileName))
Y_testFileName <- "UCI HAR Dataset/test/y_test.txt"
YTest <- read.table(unz(ZipFileName, Y_testFileName))
Subject_testFileName <- "UCI HAR Dataset/test/subject_test.txt"
SubjectTest <- read.table(unz(ZipFileName, Subject_testFileName))
TestSet <- cbind(XTest, Y=YTest, S=SubjectTest)

#######################################################
# 1. Merges the training and the test sets to create one data set.
CombinedData <- rbind(TrainSet, TestSet)

#######################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
featuresFileName <- "UCI HAR Dataset/features.txt"
features <- read.table(unz(ZipFileName, featuresFileName))
# ColumnsToExtract <- grep("mean\\(\\)|std\\(\\)", features[,2])  # Alternate interpretation
ColumnsToExtract <- grep("mean|std", features[,2]) # Alternate interpretation
ColumnsToExtract <- c(ColumnsToExtract, length(CombinedData)-1, length(CombinedData))
CombinedData <- CombinedData[,ColumnsToExtract]

#######################################################
# 3 Uses descriptive activity names to name the activities in the data set
activity_labelsFileName <- "UCI HAR Dataset/activity_labels.txt"
activityLabels <- read.table(unz(ZipFileName, activity_labelsFileName), stringsAsFactors = F)
for (labelNo in activityLabels[,1])
{
  substitute <- CombinedData[,length(CombinedData)-1] == activityLabels[labelNo,1]
  CombinedData[substitute,length(CombinedData)-1] <- activityLabels[labelNo,2]
}

#######################################################
# 4. Appropriately labels the data set with descriptive variable names.
# Get variable names from features
# Create variable names for activity and subject
# Make variable names more appropriate
# Label data set with new variable name
extraFeatures <- data.frame(c(NA, NA))
extraFeatures <- cbind(extraFeatures, c("Activity", "Subject"))
names(extraFeatures) <- names(features)
features <- rbind(features, extraFeatures)
features[,2] <- sub("\\(\\)", "", features[,2])
features[,2] <- sub("-std", "Std", features[,2])
features[,2] <- sub("-mean", "Mean", features[,2])
features[,2] <- sub("-", "", features[,2])
names(CombinedData) <- features[ColumnsToExtract,2]

#######################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Use package dplyr to create a 180 X 81 tidy data set of means
# Same 81 columns as CombinedData but rearranged where subject and activity are first columns
# 180 rows where each row is a different combination of subject and activity
reposURL <- "http://cran.rstudio.com/"
if (!require("dplyr")) {install.packages("dplyr", dep=TRUE, repos=reposURL, type = "source")} else {" dplyr is already installed "}
library(dplyr)
GroupedByActivitySubject <- group_by(CombinedData, Activity, Subject)
MeanByActivitySubject <- summarise_each(GroupedByActivitySubject, funs(mean))

#######################################################
# Persist both tidy data sets as csv files in working directory
write.csv(CombinedData, "CombinedData.csv", row.names=F)
write.csv(MeanByActivitySubject, "MeanByActivitySubject.csv", row.names=F)
