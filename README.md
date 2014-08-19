# Coursera - Datascience - Getting and Cleaning Data 
This github project contains the work to accomplish the project assignment of coursera course "Getting and Cleaning Data":
--
* The raw data (see subdirectory UCI_HAR_Dataset)
* A tidy data set (see tidy_data_aggregate.csv)
* A code book describing each variable and its values in the tidy data set (see CodeBook.md)
* A recipe to go from 1 -> 2,3 (see below)

Recipe to convert raw data to tidy data by running run_analysis.R:
--
1. Merges the training and the test sets to create one data set
  1. Reads training data set
    1. Reads and add activity class to training data
    1. Reads and add subject to training data
  1. Reads test data set
    1. Reads and add activity classes to test data
    1. Reads and add subject to test data
  1. Merges training and test data sets
1. Extracts only the measurements on the mean and standard deviation for each measurement
  1. Sets header names for all columns
  1. Extracts mean and std value names + activity class + subject
1. Uses descriptive activity names to name the activities in the data set
1. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
  1. Creates mean aggregate with grouping of subject and activity name
  1. Renames columns
  1. Writes tidy data set to file

