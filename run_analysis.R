## 03 Getting and Cleaning Data
## Week 4 - assignment

# download and unzip the dataset (only if they are missing)
if(!file.exists("Dataset.zip")){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, "Dataset.zip", method = "curl"); rm(url)
}
if(!file.exists("UCI HAR Dataset")){
  unzip("Dataset.zip")
}

#### PART 1 Merges the training and the test sets to create one data set. ####
# Read each file into a data frame: 
features <- as.character(read.table("UCI HAR Dataset/features.txt")[,2])
activities <- as.character(read.table("UCI HAR Dataset/activity_labels.txt")[,2])

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subjectID")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")

test <- cbind(subject_test, y_test, x_test)
rm(subject_test, x_test, y_test)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjectID")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")

train <- cbind(subject_train, y_train, x_train)
rm(subject_train, x_train, y_train)

#combine and format subjectID and activity as factors, and add column names
fullData <- rbind(train, test); rm(train, test)
names(fullData) <- c("subject.id", "activity", features)
fullData$subject.id <- as.factor(fullData$subject.id)
fullData$activity <- factor(fullData$activity, labels = activities)

#### PART 2 Extracts only the measurements on the mean and standard deviation for each measurement. ####
#grep("mean\\(\\)|std\\(\\)", names(fullData), value = T) #(check grep output)
meanOrStd <- fullData[,c(1:2, grep("mean\\(\\)|std\\(\\)", names(fullData)))]

#### PART 3 Uses descriptive activity names to name the activities in the data set ####
# already done in part 1
# fullData$activity <- factor(fullData$activity, labels = activities)

#### PART 4 Appropriately labels the data set with descriptive variable names. ####
newnames <- names(meanOrStd)
newnames <- sub("BodyBody", " body ", newnames)
newnames <- sub("Body", " body ", newnames)
newnames <- sub("Gravity", " gravity ", newnames)
newnames <- sub("Acc", " accelerometer ", newnames)
newnames <- sub("Gyro", " gyroscope ", newnames)
newnames <- sub("^t", "time ", newnames)
newnames <- sub("^f", "frequency ", newnames)
newnames <- sub("Mag", "magnitude ", newnames)
newnames <- sub("Jerkmagnitude", "Jerk magnitude", newnames)
newnames <- sub("std", "standard deviation", newnames)
newnames <- gsub("-", " ", newnames)
newnames <- gsub("  ", " ", newnames)
newnames <- gsub(" ", ".", newnames)
newnames <- sub("\\(\\)", "", newnames)
names(meanOrStd) <- newnames; rm(newnames)

#### PART 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ####
# with dplyr
#library(dplyr)
#final.dplyr <- meanOrStd %>% group_by(subject.id, activity) %>% summarize_all(.funs = funs(mean))

# with aggregate
final.aggregated <- aggregate(meanOrStd[,-c(1,2)], by = list(subject.id = meanOrStd$subject.id, activity = meanOrStd$activity), FUN = mean)

#write the dataset to a txt file
write.table(final.aggregated, "FinalDataset.txt", row.names = F)

#check if re-import is ok
#f <- read.table("FinalDataset.txt", header = T)
