library(dplyr)

## LOAD data

activity_labels <- read.table('UCI HAR Dataset//activity_labels.txt', header = FALSE)
features <- read.table('UCI HAR Dataset/features.txt', header=FALSE)

X_train <- read.table('UCI HAR Dataset/train/X_train.txt', header=FALSE)
y_train <- read.table('UCI HAR Dataset/train/y_train.txt', header=FALSE)

subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', header=FALSE)

body_acc_x_train <- read.table('UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt', header=FALSE)
body_acc_y_train <- read.table('UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt', header=FALSE)
body_acc_z_train <- read.table('UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt', header=FALSE)

body_gyro_x_train <- read.table('UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt', header=FALSE)
body_gyro_y_train <- read.table('UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt', header=FALSE)
body_gyro_z_train <- read.table('UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt', header=FALSE)

total_acc_x_train <- read.table('UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt', header=FALSE)
total_acc_y_train <- read.table('UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt', header=FALSE)
total_acc_z_train <- read.table('UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt', header=FALSE)


X_test <- read.table('UCI HAR Dataset/test/X_test.txt', header=FALSE)
y_test <- read.table('UCI HAR Dataset/test/y_test.txt', header=FALSE)

subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', header=FALSE)

body_acc_x_test <- read.table('UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt', header=FALSE)
body_acc_y_test <- read.table('UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt', header=FALSE)
body_acc_z_test <- read.table('UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt', header=FALSE)

body_gyro_x_test <- read.table('UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt', header=FALSE)
body_gyro_y_test <- read.table('UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt', header=FALSE)
body_gyro_z_test <- read.table('UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt', header=FALSE)

total_acc_x_test <- read.table('UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt', header=FALSE)
total_acc_y_test <- read.table('UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt', header=FALSE)
total_acc_z_test <- read.table('UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt', header=FALSE)


## Relabel data

names(y_train) <- c('activity_id')
names(y_test) <- c('activity_id')
names(activity_labels) <- c('activity_id', 'activity_label')

names(features) <- c('feature_id', 'feature')
names(X_test) <- features$feature
names(X_train) <- features$feature

names(subject_test) <- 'subject'
names(subject_train) <- 'subject'

## 1. Merge data set

train <- cbind(X_train, y_train)
train <- cbind(train, subject_train)
test <- cbind(X_test, y_test)
test <- cbind(test, subject_test)

data <- rbind(train, test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

data <- data[c(c('subject', 'activity_id'), as.character(filter(features, grepl("mean()", feature) | grepl("std()", feature))$feature))]

## 3. Uses descriptive activity names to name the activities in the data set

data <- merge(data, activity_labels, by=c('activity_id'))
data <- select(data, -activity_id)

## 4. Appropriately labels the data set with descriptive variable names. 
names(data) <- gsub('\\(\\)','',names(data))

## 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.

output_data <- summarise_each(group_by(data, subject, activity_label), funs(mean))

write.table(output_data, file='output.txt', row.names=FALSE)
