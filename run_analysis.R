#Getting and Cleaning Data - Course Project: 

#Run Analysis: 

#Setting WD: 
setwd("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
#within this folder there are two folders - one with the training set and one with the test set

#Getting packages: 
if(!require("data.table")) {install.packages("data.table")}
if(!require("reshape2")) {install.packages("reshape2") }
require("data.table")
require("reshape2")

#1: Merge the training and the test sets to create one data set: 

#Getting activity labels:
activity_labels <- read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"")[,2]

#Getting data column names:
features <- read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"")[,2]

#Extract only the measurements on the mean and standard deviation for each measurement:
# grepl() search for matches o argument pattern within each element of a character vector 
extract_features<-grepl("mean|std", features) 

#Importing test set: 
X_test <- read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"")
#Labels: 
Y_labels_test <- read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", quote="\"")
#Subject test: 
subject_test <-read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"")

#Applying header:
names(X_test)=features

#Extract only the measurements on the mean and standard deviation for each measurement:
X_test = X_test[,extract_features]

#Adding labels:
Y_labels_test[,2] = activity_labels[Y_labels_test[,1]]
names(Y_labels_test) = c("Activity_ID", "Activity_Label")
names(subject_test) ="Subject"

#Combining data and labels:
test_data<- cbind(as.data.table(subject_test), Y_labels_test, X_test)

#Importing train set: 
X_train <- read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"")
#Labels: 
Y_labels_train <- read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", quote="\"")
#Subject train: 
subject_train <-read.table("H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"")

#Applying header:
names(X_train)=features

#Extract only the measurements on the mean and standard deviation for each measurement:
X_train = X_train[,extract_features]

#Adding labels:
Y_labels_train[,2] = activity_labels[Y_labels_train[,1]]
names(Y_labels_train) = c("Activity_ID", "Activity_Label")
names(subject_train) ="Subject"

#Combining data and labels:
train_data<- cbind(as.data.table(subject_train), Y_labels_train, X_train)

#Merging test and train dataset: 
merged_data<-rbind(test_data, train_data)

#Create an independent tidy data set with the average of each variable for each activity and each subject: 
id_labels = c("Subject", "Activity_ID", "Activity_Label")
data_labels =setdiff(colnames(merged_data), id_labels)
melt_data<-melt(merged_data, id=id_labels, measure.vars=data_labels)

tidy_data = dcast(melt_data, Subject + Activity_Label~ variable, mean)

write.table(tidy_data, file = "H:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/tidy_data.txt", row.names=F)
