##################################################################################
# Getting and Cleaning Data: Class Project
#
# The following script is designed to create tidy data sets from the
# Human Activity Recognition Using Smartphones data (http://archive.ics.uci.edu/
# ml/datasets/Human+Activity+Recognition+Using+Smartphones). The script will
# generate two data sets:
#
#     1. har.data - A subset of the original data that retains measurements
#                   of mean and standard deviation
#     2. har.summary.data - A summarized version that aggregates har.data by 
#                   "subject" and "activity_code", returning means.
#
# Author: tfrance
# Date: 04/20/14
##################################################################################

# Create a directory to store the data:
if (!file.exists("data")) {
  dir.create("data")
}

# Download the data file, if absent, to ./data/har.zip:
if (!file.exists("./data/har.zip")) {
  fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl, "./data/har.zip", method="curl")
  downloaded <- date()
}

# unzip it into the data directory:
unzip("./data/har.zip", exdir="./data", overwrite=T)

# Merge the training and test data sets:
# combine subject_test.txt, y_test.txt, X_test.txt;
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", sep="") # test subject id
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt") # test activity code
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt") # test signal data
test <- cbind(subject_test, y_test, X_test)

# combine subject_train.txt, y_train.txt, X_train.txt;
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", sep="") # train subject id
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt") # train activitiy code
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt") # train signal data
train <- cbind(subject_train, y_train, X_train)

# merge the two reconstructed data sets into one:
har.data <- rbind(train, test)

# add labels to the data:
feature.labels <- c("subject", "activity_code")
feature.labels <- append(feature.labels, as.character(read.table("./data/UCI HAR Dataset/features.txt")[,2]))
names(har.data) <- feature.labels

# add a new variable, "activity_desc" to describe the coded activities ("./data/UCI HAR Dataset/activity_labels.txt")
activity_desc <- factor(har.data$activity_code, levels=c(1,2,3,4,5,6), 
                        labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING"))
har.data <- cbind(har.data[,1:2], activity_desc, har.data[,3:ncol(har.data)]) # insert as third column

# reshape the data.frame to contain the first 3 columns, and all columns pertaining to mean and standard deviation:
# cols for mean and std have "-mean" and "-std" in their labels, respectively

# find all cols whose names match "-mean" or "-std":
feature.labels <- names(har.data)
matches <- grep("-std\\(\\)|-mean\\(\\)", feature.labels)
matches <- sort(append(matches, c(1:3)))

# reshape the data to the matches and the first 3 columns ("subject","activity_code", "activity_desc"):
har.data <- har.data[, matches]

# create new tidy data set that aggregates har.data by "subject" and "activity_code", returning means:
har.summary.data <- aggregate(har.data[4:ncol(har.data)], by=list(subject=har.data$subject, 
                                                                  activity_code=har.data$activity_code), FUN=mean)

# add activity_desc variable back into the summarized data set (N.B. I had removed this from the aggregation step, 
# because aggregating a factor returns NAs; this is a hack for getting it back. There must be a better way...)
activity_desc <- factor(har.summary.data$activity_code, levels=c(1,2,3,4,5,6), 
                        labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING"))
har.summary.data <- cbind(har.summary.data[,1:2], activity_desc, har.summary.data[,3:ncol(har.summary.data)]) # insert as third column

# clean up temp objects:
rm(subject_test, subject_train, test, train, X_test, X_train, y_test, y_train, activity_desc, feature.labels, fileurl, matches)