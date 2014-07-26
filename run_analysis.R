
## Assignment:
## You should create one R script called run_analysis.R that does the following. 

## 1) Merges the training and the test sets to create one data set.
## 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3) Uses descriptive activity names to name the activities in the data set
## 4) Appropriately labels the data set with descriptive variable names. 
## 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## load data from local files

testLabels <- read.table("./test/y_test.txt")
testData <- read.table("./test/X_test.txt")
testSubject <- read.table("./test/subject_test.txt")

trainLabels <- read.table("./train/y_train.txt")
trainData <- read.table("./train/X_train.txt")
trainSubject <- read.table("./train/subject_train.txt")

activityLabels <- read.table("activity_labels.txt")
featureLabels <- read.table("features.txt")

## data loaded, now update titles

featureColNames <- as.vector(featureLabels$V2, mode="character")

colnames(testData) <- featureColNames
colnames(trainData) <- featureColNames

remove(featureLabels, featureColNames)

colnames(testLabels) <- "activityid"
colnames(testSubject) <- "subjectid"

colnames(trainLabels) <- "activityid"
colnames(trainSubject) <- "subjectid"

colnames(activityLabels) <- c("activityid", "activityname")

## bring files together into one with appropriate titles

combinedTestData <- cbind(testSubject, testLabels, testData)
combinedTrainData <- cbind(trainSubject, trainLabels, trainData)

remove(testSubject, testLabels, testData)
remove(trainSubject, trainLabels, trainData)

## merge activity labels

options(warn=-1)

namedTestData <- merge(combinedTestData, activityLabels, by.x = "activityid", by.y = "activityid", all.x=TRUE)
rawTestData <- namedTestData[,c(2,564,3:563)]

namedTrainData <- merge(combinedTrainData, activityLabels, by.x = "activityid", by.y = "activityid", all.x=TRUE)
rawTrainData <- namedTrainData[,c(2,564,3:563)]

options(warn=0)

remove(namedTestData, namedTrainData, combinedTestData, combinedTrainData, activityLabels)

## combine test and training data into single table

combinedRawData <- rbind(rawTestData, rawTrainData)

remove(rawTestData, rawTrainData)

## trim out excess columns

trimmedRawData <- combinedRawData[,c(1:2,grep("mean\\(|std\\(",names(combinedRawData)))]

## - this is the FULL data set before compressing down; save in memory 
## remove(combinedRawData)

## melt

meltedData <- melt(trimmedRawData, c("subjectid", "activityname"))

remove(trimmedRawData)

## dcast for final output

finalData <- dcast(meltedData, subjectid+activityname~...,mean)

remove(meltedData)

## save output to file

## write.table(finalData, file="./finalOutput.txt", row.names=FALSE)
