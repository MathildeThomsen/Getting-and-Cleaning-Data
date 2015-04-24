# Getting-and-Cleaning-Data
#Assignment: 
Creates a R script called run_analysis.R which does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Initally WD is set
#Needed packages are installed
#Activity labels and features are loaded
#A vector containing matches for mean and std in the features second column is created using grepl
#Test set is loaded
#Labels for the test set are loaded
#Subject numbers are loaded since the same subject has performed different activities
#Header is applied using second column of the loaded features
#Test set is subsetted by the created vector extracting columns with mean and std
#Labels are added using the second column of the loaded labels
#Combining the different data.frames in the following order: Subject number, labels indicating the activity, the test set
#All of the above steps are repeated for the train set
#Creating merged data from the final test and train set
#Creating tidy data from the merged data using melt and dcast
#Writing table
