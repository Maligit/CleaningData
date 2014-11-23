#This script will download a set of files from the accelerometers from the Samsung Galaxy S smartphone.
#It then coalesces the files into one dataset capturing the mean and std for various subjects on six different types of activities.

#It then produces a long form of tidy dataset

# load packages
library(data.table)


# set workdrive
setwd("./")

#Create new directory if it does not exist
if (!file.exists("./UCI HAR Dataset")) {
  dir.create("UCI HAR Dataset")
}

#Open zip file and unpack it into right directory
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(fileURL, destfile ="temp", method="curl")

unzip(zipfile="temp", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = getwd(), unzip = "internal",
      setTimes = FALSE)

unlink(temp)
#close("fileURL")
#list.files("./UCI HAR Dataset")

#Read appropriate files into respective directories 
features <- read.table("./UCI HAR Dataset/features.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Merge files to combine training and test data
xtrain.test <- rbind(xtrain,xtest)
ytrain.test <- rbind(ytrain,ytest)
subtrain.test <- rbind(subtrain, subtest)

colnames(xtrain.test) <- features$V2
#colnames(ytrain.test) <- "Activity"

#Select mean and std as the only relevant data for the study
mean.std.data <- xtrain.test[grep("mean|std", names(xtrain.test))]
clean.names <- make.names(colnames(mean.std.data))
colnames(mean.std.data) <- clean.names

#substitute the right activity based on id
ytrain.test$words[ytrain.test$V1 == 1] <- "WALKING"
ytrain.test$words[ytrain.test$V1 == 2] <- "WALKING_UPSTAIRS"
ytrain.test$words[ytrain.test$V1 == 3] <- "WALKING_DOWNSTAIRS"
ytrain.test$words[ytrain.test$V1 == 4] <- "SITTING"
ytrain.test$words[ytrain.test$V1 == 5] <- "STANDING"
ytrain.test$words[ytrain.test$V1 == 6] <- "LAYING"

#Combine subject and activity as one data.frame
sub.activity <- cbind(subtrain.test,ytrain.test[,2])
colnames(sub.activity) <- c("Subject", "Activity")
sub.activity <- cbind(mean.std.data,sub.activity)

#create a data.table to facilitate lapply operation
final.set = data.table(sub.activity)
final.Xtrain.set <- final.set[, lapply(.SD, mean), by = list(Subject,Activity)]

#coerce data.table into a data.frame
outfile <-data.frame()
outfile <- final.Xtrain.set

#Write output as text file
write.table(outfile, "subactivity_mean_test.txt", row.names=FALSE )
