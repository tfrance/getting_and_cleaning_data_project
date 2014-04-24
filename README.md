### Coursera: Getting and Cleaning Data - Class Project
---
This project contains the following files:

**run_analysis.R**: This script creates a tidy data set adapted from [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The original data can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The script performs the following transformations:
* Downloads the original data set and unzips it into a data directory ("./data/har.zip")
* Concatenates the subject, activity-code, and data from each data set
* Merges the training and test sets into a single data set ("har.data")
* Adds labels to the features of the data set
* Adds a new column "activity-desc", that provides human-readable descriptions of the activities coded numerically in "activity-code"
* Reshapes the data to retain the following columns: "subject", "activity-code", "activity-desc" and all features capturing data on mean and standard deviation (identified by "-mean" and "-std" in the feature labels)
* Creates a second tidy data set ("har.summary.data") that aggregates har.data by "subject" and "activity_code", returning means

**CodeBook.md**: A code book describing the variables in the data set.
  