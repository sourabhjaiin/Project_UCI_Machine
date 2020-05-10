#analysis

#1. Merges the training and the test sets to create one data set.
#.......................................................................................
#1. Adding Library

library(reshape2)
library(dplyr)

#.......................................................................................
#2. downloading and unzipping file 

fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./projectC3")){dir.create("./projectc3")}
download.file(fileurl, destfile = "./projectc3/dataset.zip")

unzip(zipfile = "./projectc3/dataset.zip", exdir = "./projectc3")

#.........................................................................................

#3. reading files

#train data

x_train<-read.table("./projectc3/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./projectc3/UCI HAR Dataset/train/Y_train.txt")
s_train<-read.table("./projectc3/UCI HAR Dataset/train/subject_train.txt")

#test data
x_test<-read.table("./projectc3/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./projectc3/UCI HAR Dataset/test/Y_test.txt")
s_test<-read.table("./projectc3/UCI HAR Dataset/test/subject_test.txt")

#...........................................................................................

#4 merging all data in one set
 
mrg_train<-cbind(x_train,y_train,s_train)
mrg_test<-cbind(x_test,y_test,s_test)
finalmrg<-rbind(mrg_train,mrg_test)
 
#............................................................................................
#............................................................................................
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#............................................................................................. 
#.............................................................................................


#5. Loading featuring and activitylabels

features <- read.table('./projectc3/UCI HAR Dataset/features.txt')
activityLabels = read.table('./projectc3/UCI HAR Dataset/activity_labels.txt')

#............................................................................................

#reading column Names

colNames<- colnames(finalmrg)

#defining id, mean and standard deviation

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)


#...........................................................................................

#subsetting mean and std

setForMeanAndStd <- finalmrg[ , mean_and_std == TRUE]

#...........................................................................................
#...........................................................................................
#3. Uses descriptive activity names to name the activities in the data set
#...........................................................................................
#...........................................................................................


setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                             by='activityId',
                             all.x=TRUE)


#...........................................................................................
#...........................................................................................
# 4. Appropriately labels the data set with descriptive variable names. (Already completed)
#...........................................................................................
#...........................................................................................


#...........................................................................................
#...........................................................................................
# 5 From the data set in step 4, creates a second, independent tidy data set with the average 
#   of each variable for each activity and each subject.
#...........................................................................................
#...........................................................................................

#5.1 Making a second tidy data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#5.2 Writing second tidy data set in txt file

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)



