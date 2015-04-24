#Getting and Cleaning Data - Run_Analysis.R:

#Setting WD: 
  setwd("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#Getting needed packages: 
  install.packages("data.table")
  library(data.table)
  install.packages("reshape2")
  library("reshape2")

#Getting activity labels:
  activity_labels <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"")

#Getting data column names:
  features <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"")

#Extracting mean and SD using grepl. grepl() searches for matches or argument pattern within each element of a character vector 
  mean_SD <- grepl("mean|std", features[,2])
  
############Test set############
  
#Importing test set: 
  X_test <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"")

#Importing labels: 
  Y_labels_test <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", quote="\"")

#Importing Subject test: 
  subject_test <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"")

#Applying header:
  names(X_test) = features[,2] 

#Subsetting using the vector created by grepl - extracting columns with mean and SD:
  X_test = X_test[,mean_SD]
  
#Adding labels:
  Y_labels_test[,2] = activity_labels$V2[Y_labels_test[,1]]
  names(Y_labels_test) = c("Activity_ID", "Activity_Label")
  names(subject_test) ="Subject"  
  
#Combining data and labels:
  test_data<- cbind(as.data.table(subject_test), Y_labels_test, X_test) 

############Train set############
  
#Importing train set: 
  X_train <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"")
#Labels: 
  Y_labels_train <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", quote="\"")
#Subject train: 
  subject_train <- read.table("U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"")
  
#Applying header:
  names(X_train) = features[,2]
  
#Subsetting using the vector created by grepl - extracting columns with mean and SD:
  X_train = X_train[,mean_SD]
  
#Adding labels:
  Y_labels_train[,2] = activity_labels$V2[Y_labels_train[,1]]
  names(Y_labels_train) = c("Activity_ID", "Activity_Label")
  names(subject_train) ="Subject"
  
#Combining data and labels:
  train_data<- cbind(as.data.table(subject_train), Y_labels_train, X_train) 
  
#############Merging Data###############
  
#Merging test and train dataset: 
  merged_data<-rbind(test_data, train_data)
  
#Create an independent tidy data set with the average of each variable for each activity and each subject: 
  id_labels = c("Subject", "Activity_ID", "Activity_Label")
  data_labels =setdiff(colnames(merged_data), id_labels)
  melt_data<-melt(merged_data, id=id_labels, measure.vars=data_labels)

  tidy_data = dcast(melt_data, Subject + Activity_Label~ variable, mean)

#Writing table: 
  write.table(tidy_data, file = "U:/R/Getting and Cleaning Data/Assignments/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/tidy_data.txt", row.names=F)
