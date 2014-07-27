# Set working directory to the extracted folder "UCI HAR Dataset"
library(data.table)
# Read training data
trainData <- read.table("./train/X_train.txt",header=FALSE)
trainLabels <- read.table("./train/y_train.txt",header=FALSE)
trainSubjects <- read.table("./train/subject_train.txt",header=FALSE)
# Read test data
testData <- read.table("./test/X_test.txt",header=FALSE)
testLabels <- read.table("./test/y_test.txt",header=FALSE)
testSubjects <- read.table("./test/subject_test.txt",header=FALSE)
# 3. Use descriptive activity names to name the activities in the data set
activities <- read.table("./activity_labels.txt",header=FALSE,colClasses="character")
trainLabels$V1 <- factor(trainLabels$V1,levels=activities$V1,labels=activities$V2)
testLabels$V1 <- factor(testLabels$V1,levels=activities$V1,labels=activities$V2)
# 4. Appropriately label the data set with descriptive activity names
features <- read.table("./features.txt",header=FALSE,colClasses="character")
colnames(trainData)<-features$V2
colnames(testData)<-features$V2
colnames(trainLabels)<-c("Activity")
colnames(testLabels)<-c("Activity")
colnames(trainSubjects)<-c("Subject")
colnames(testSubjects)<-c("Subject")
# 1. Merges the training and the test sets to create one data set
trainData<-cbind(trainData,trainLabels)
trainData<-cbind(trainData,trainSubjects)
testData<-cbind(testData,testLabels)
testData<-cbind(testData,testSubjects)
mergedData<-rbind(testData,trainData)
# 2. Extract only the measurements on the mean and standard deviation for each measurement
mergedData_mean<-sapply(mergedData,mean,na.rm=TRUE)
mergedData_sd<-sapply(mergedData,sd,na.rm=TRUE)
# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
DT <- data.table(mergedData)
tidy <- DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy, "tidy.txt")
