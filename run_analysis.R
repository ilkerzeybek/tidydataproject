install.packages("dplyr")
library(dplyr)

if(!file.exists("./data")){
  dir.create("./data")
}

dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataURL, destfile = "./data/data.zip", method = "curl")

unzip(zipfile = "./data/data.zip", exdir = "./data")

list.files("./data")
list.files("./data/UCI HAR Dataset")
list.files("./data/UCI HAR Dataset/test")

features <- read.table("./data/UCI HAR Dataset/features.txt", header = F)
features <- as.vector(features$V2)

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features)
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Label")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Label")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("ID", "Label"))

x_merged <- rbind(X_train, X_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
total_merged <- cbind(x_merged, y_merged, subject_merged)

extracted <- select(total_merged, Subject, Label, contains("mean"), contains("std"))

extracted$Label <- activities[extracted$Label, 2]

col_names <- as.matrix(names(extracted))
names(extracted)[2] <- "Activity"
names(extracted) <- gsub("Acc", "Accelerometer", names(extracted))
names(extracted) <- gsub("Gyro", "Gyroscope", names(extracted))
names(extracted) <- gsub("BodyBody", "Body", names(extracted))
names(extracted) <- gsub("Mag", "Magnitude", names(extracted))
names(extracted) <- gsub("^t", "Time", names(extracted))
names(extracted) <- gsub("^f", "Frequency", names(extracted))
names(extracted) <- gsub("tBody", "TimeBody", names(extracted))
names(extracted) <- gsub("-mean()", "Mean", names(extracted), ignore.case = T)
names(extracted) <- gsub("-std()", "STD", names(extracted), ignore.case = T)
names(extracted) <- gsub("-freq()", "Frequency", names(extracted), ignore.case = T)
names(extracted) <- gsub("angle", "Angle", names(extracted))
names(extracted) <- gsub("gravity", "Gravity", names(extracted))

tidy_data <- extracted %>%
  group_by(Subject, Activity) %>%
  summarize_all(list(mean))
write.table(tidy_data, "./data/tidy_data.txt")
