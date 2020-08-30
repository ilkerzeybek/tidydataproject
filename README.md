# How Script Works

  Firstly, the script creates a file named "data" in the current working directory and downloads the data set with download.file() function in that file. After downloading, it unzips the file with unzip() function. After unzipping, several list.files() functions are used for navigating in the file that unzipped.

## It Merges the training and the test sets to create one data set.

  It reads the respective training, test, activity labels, and the feature names with read.table() function. Then it merges the appropriate data sets with rbind() and cbind() functions in order to create one big data set.

## Extracts only the measurements on the mean and standard deviation for each measurement.
  
  It extracts the measurements on the mean and standard deviation for each measurement with package called "dplyr". It uses dplyr::select() function to select columns with names "Subject", "Label", and the ones with "mean" and "std" words in them. Extracting the columns with "mean" and "std" words is achieved by contains() function.

## Uses descriptive activity names to name the activities in the data set.
  
  Label column of the extracted data set is exchanged with actual descriptive activity names. This is achieved with 
  
  extracted$Label <- activities[extracted$Label, 2] 
  line.
  
## Appropriately labels the data set with descriptive variable names.

  The abbreviated variable names are changed with their full names. This is achieved with gsub() function.
  
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

  "dplyr" package is used for grouping the data set by Subject and Activity columns. This is achieved by dplyr::group_by() function. Then dplyr::summarize_all() function is used to apply mean() function to these groups. write.table() function is used to write data set as a "txt" file in the given directory. 
