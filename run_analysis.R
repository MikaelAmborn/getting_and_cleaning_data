library(dplyr)

zipFile <- "./data/uci_har_dataset.zip"
zipDir <- "./data/UCI\ HAR\ Dataset/"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data")) { dir.create("./data") }
if(!file.exists(zipFile)) { download.file(dataUrl, destfile=zipFile, method="curl") }
if(!file.exists(zipDir)) { unzip(zipFile, exdir="./data") }

trainingDataFile <- paste(zipDir, "train/X_train.txt", sep="")
trainingSubjectFile <- paste(zipDir, "train/subject_train.txt", sep="")
trainingActivityFile <- paste(zipDir, "train/y_train.txt", sep="")
testDataFile <- paste(zipDir, "test/X_test.txt", sep="")
testSubjectFile <- paste(zipDir, "test/subject_test.txt", sep="")
testActivityFile <- paste(zipDir, "test/y_test.txt", sep="")
featureNameFile <- paste(zipDir, "features.txt", sep="")

# Read in the training and test data files
featureNames <- read.table(featureNameFile, col.names=c("Column", "Name"))
validFeatureNames <- gsub("-", "_", gsub("[()]", "", featureNames$Name))
trainingData <- read.table(trainingDataFile, col.names=validFeatureNames)
trainingSubject <- read.table(trainingSubjectFile, col.names = c("Subject"))
trainingActivity <- read.table(trainingActivityFile, col.names = c("Activity"))
testData <- read.table(testDataFile, col.names=validFeatureNames)
testSubject <- read.table(testSubjectFile, col.names = c("Subject"))
testActivity <- read.table(testActivityFile, col.names = c("Activity"))

# Create two data.frames for the training and test data
trainingDf <- data.frame(trainingSubject, trainingActivity, trainingData)
testDf <- data.frame(testSubject, testActivity, testData)

# Step 1 - Merges the training and the test sets to create one data set.
mergedDf <- rbind(trainingDf, testDf)

# Step 2- Extracts only the measurements on the mean and standard deviation for each measurement. 
mergedDf <- mergedDf[, grep("Subject|Activity|mean$|mean_|std$|std_", colnames(mergedDf))]

# Step 3 - Uses descriptive activity names to name the activities in the data set
activityNameFile <- paste(zipDir, "activity_labels.txt", sep="")
activityNames <- read.table(activityNameFile, col.names = c("Activity.Id", "Activity.Name"))
mergedDf <- merge(activityNames, mergedDf, by.x="Activity.Id", by.y="Activity")
mergedDf <- select(mergedDf, -Activity.Id)

# Step 4 - Appropriately labels the data set with descriptive variable names. 
# - Done when reading in the data above with read.table

# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the 
#          average of each variable for each activity and each subject.
newDf <- summarise_each(group_by(mergedDf, Subject, Activity.Name), funs(mean))
write.table(newDf, file="./data/tidyData.txt", row.name=FALSE)

