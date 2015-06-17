#1. Download, load and merge data
xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/Y_train.txt")
subTrain <- read.table("./train/subject_train.txt")
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/Y_test.txt")
subTest <- read.table("./test/subject_test.txt")

testData <- cbind(xTest, yTest, subTest)
trainData <- cbind(xTrain, yTrain, subTrain)
twoSets <- rbind(testData, trainData)

#2.Extracts only the measurements on the mean and standard deviation for each measurement,
#Appropriately labels the data set with descriptive variable names. 
features <- read.table("./features.txt")
colnames(twoSets) <- features$V2

smallData <- twoSets[,(sapply("mean\\(", grepl, features$V2) | sapply("std", grepl, features$V2))]
names(smallData)[ncol(smallData)] <- "subject"
names(smallData)[ncol(smallData)-1] <- "activityLabels"

#4. descriptive activity names to name the activities in the data set
activityLabels <- read.table("./activity_labels.txt")
smallData$activityLabels  <-  factor(smallData$activityLabels, labels=activityLabels$V2)
smallData$subject <- factor(smallData$subject)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

tidyData <- aggregate(smallData[,1:(ncol(smallData)-2)], by=list(smallData$activityLabels, smallData$subject), FUN=mean, na.rm=TRUE)
names(tidyData)[1] <- "activityLabels"
names(tidyData)[2] <- "subject"

#Export
write.table(tidyData, file="./tidyData", row.names=FALSE) 
