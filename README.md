---
title: "README"
---
For the purpose of the assignment, tidy data is enterpreted in the wide sense. For additional information see https://class.coursera.org/getdata-015/forum/thread?thread_id=27

First, script loads all data into R and then binds train, test, and subject data together. In the last step, script binds everything in one dataset twoSets.

```{r}
xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/Y_train.txt")
subTrain <- read.table("./train/subject_train.txt")
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/Y_test.txt")
subTest <- read.table("./test/subject_test.txt")

testData <- cbind(xTest, yTest, subTest)
trainData <- cbind(xTrain, yTrain, subTrain)

twoSets <- rbind(testData, trainData)
```

Next, the script reads in variable names and assignes them to the twoSets dataset. After, the extracts the variables with mean and standard deviation into smallData dataset and assigns variable names to subjects and activities.

```{r}
features <- read.table("./features.txt")
colnames(twoSets) <- features$V2

smallData <- twoSets[,(sapply("mean\\(", grepl, features$V2) | sapply("std", grepl, features$V2))]
names(smallData)[ncol(smallData)] <- "subject"
names(smallData)[ncol(smallData)-1] <- "activityLabels"
```

Next, the script reads in names of the activities and assignes them to corresponding numbers in the dataset.

```{r}
activityLabels <- read.table("./activity_labels.txt")
smallData$activityLabels  <-  factor(smallData$activityLabels, labels=activityLabels$V2)
smallData$subject <- factor(smallData$subject)
```
Next, the script summarizes the data by type of activity and subject number into a new dataset tidyData and then exprts it.

```{r}
tidyData <- aggregate(smallData[,1:(ncol(smallData)-2)], by=list(smallData$activityLabels, smallData$subject), FUN=mean, na.rm=TRUE)
names(tidyData)[1] <- "activityLabels"
names(tidyData)[2] <- "subject"

write.table(tidyData, file="./tidyData", row.names=FALSE) 
```

