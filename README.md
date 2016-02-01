# README.md

# Data Cleaning Project

The R script is called run_analysis.R.  run_analysis.R expects the zip file "getdata_projectfiles_UCI HAR Dataset.zip" in ./data. Alternately, run_analysis requires access to the internet to download this zip file from: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

The code in run_analysis.R can be run one line at a time or using the source command source('run_analysis.R').  The result will be two tidy data sets written out to csv files.  The first tidy data, called CombinedData.csv, contains the combined testing and training data of the mean and standard deviation variables together with the subject and activity labels.  The second tidy data set, called MeanByActivitySubject.csv, contains the mean for each activity and each subject of each variable in CombinedData.csv. 

