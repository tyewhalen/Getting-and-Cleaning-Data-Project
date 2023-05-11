# Load dplyr package #
library(dplyr)

# Set working directory #
setwd("//sfp.idir.bcgov/U114/TYWHALEN$/Profile/Desktop/UCI HAR Dataset")

# Get training data #
subject_train <- read.table("train/subject_train.txt", header = FALSE)
features_train <- read.table("train/X_train.txt", header = FALSE)
activity_train <- read.table("train/y_train.txt", header = FALSE)

# Get test data #
subject_test <- read.table("test/subject_test.txt", header = FALSE)
features_test <- read.table("test/X_test.txt", header = FALSE)
activity_test <- read.table("test/y_test.txt", header = FALSE)

# Get activity and features data #
activity_labels <- read.table("activity_labels.txt", header = FALSE)
feature_labels <- read.table("features.txt", header = FALSE)

# Merge training and test data sets #
subject <- rbind(subject_train, subject_test)
features <- rbind(features_train, features_test)
activity <- rbind(activity_train, activity_test)
colnames(subject) <- "Subject"
colnames(features) <- t(feature_labels[2])
colnames(activity) <- "Activity"
data_merged <- cbind(subject, features, activity)

# Keep only the features columns with mean and standard deviation #
dim(data_merged)
columns_req <- grep(".*Mean.*|.*Std.*", names(data_merged), ignore.case=TRUE)
req_columns <- c(columns_req, 1, 563)
mean_std_data <- data_merged[,req_columns]
dim(mean_std_data)

# Name activity variable according to activity label #
mean_std_data$Activity <- as.character(mean_std_data$Activity)
for (i in 1:6){
        mean_std_data$Activity[mean_std_data$Activity == i] <- as.character(activity_labels[i,2])
        }
mean_std_data$Activity <- as.factor(mean_std_data$Activity)

# Label variables in dataset #
names(mean_std_data)<-gsub("Acc", "Accelerometer", names(mean_std_data))
names(mean_std_data)<-gsub("Gyro", "Gyroscope", names(mean_std_data))
names(mean_std_data)<-gsub("BodyBody", "Body", names(mean_std_data))
names(mean_std_data)<-gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data)<-gsub("^t", "Time", names(mean_std_data))
names(mean_std_data)<-gsub("^f", "Frequency", names(mean_std_data))
names(mean_std_data)<-gsub("tBody", "TimeBody", names(mean_std_data))
names(mean_std_data)<-gsub("-mean()", "Mean", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("-std()", "STD", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("-freq()", "Frequency", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("angle", "Angle", names(mean_std_data))
names(mean_std_data)<-gsub("gravity", "Gravity", names(mean_std_data))
str(mean_std_data)

# Tidy dataset with mean of each variable for each activity and subject #
tidy_data <- aggregate(. ~Subject + Activity, mean_std_data, mean)
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
