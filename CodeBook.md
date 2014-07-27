Introduction
============
This file describes the data, the variables, and the work that has been performed to clean up the data.

Data Set Description
====================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each wi

Transformations and Work Done
======================================

Downloaded the zip file from the folloing URL
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Extracted the data into the folder "UCI HAR Dataset".

Set the working directory in R to the above folder.

Load test and training sets and the activities

read.table is used to load the data to R environment for the data, the activities and the subject of both test and training datasets.

# Read training data
trainData <- read.table("./train/X_train.txt",header=FALSE)
trainLabels <- read.table("./train/y_train.txt",header=FALSE)
trainSubjects <- read.table("./train/subject_train.txt",header=FALSE)
# Read test data
testData <- read.table("./test/X_test.txt",header=FALSE)
testLabels <- read.table("./test/y_test.txt",header=FALSE)
testSubjects <- read.table("./test/subject_test.txt",header=FALSE)

Descriptive activity names to name the activities in the data set

The class labels linked with their activity names are loaded from the activity_labels.txt file. The numbers of the testLabels and trainSubjects data frames are replaced by those names:

activities <- read.table("./activity_labels.txt",header=FALSE,colClasses="character")
trainLabels$V1 <- factor(trainLabels$V1,levels=activities$V1,labels=activities$V2)
testLabels$V1 <- factor(testLabels$V1,levels=activities$V1,labels=activities$V2)

Appropriately labels the data set with descriptive activity names

Each data frame of the data set is labeled - using the features.txt - with the information about the variables used on the feature vector. The Activity and Subject columns are also named properly before merging them to the test and train dataset.

features <- read.table("./features.txt",header=FALSE,colClasses="character")
colnames(trainData)<-features$V2
colnames(testData)<-features$V2
colnames(trainLabels)<-c("Activity")
colnames(testLabels)<-c("Activity")
colnames(trainSubjects)<-c("Subject")
colnames(testSubjects)<-c("Subject")

Merge test and training sets into one data set, including the activities

The Activity and Subject columns are appended to the test and train data frames, and then are both merged in the mergedData data frame.

trainData<-cbind(trainData,trainLabels)
trainData<-cbind(trainData,trainSubjects)
testData<-cbind(testData,testLabels)
testData<-cbind(testData,testSubjects)
mergedData<-rbind(testData,trainData)

Extract only the measurements on the mean and standard deviation for each measurement

mean() and sd() are used against mergedData via sapply() to extract the requested measurements.

mergedData_mean<-sapply(mergedData,mean,na.rm=TRUE)
mergedData_sd<-sapply(mergedData,sd,na.rm=TRUE)

A warning is returned for the Activity column because it's not numeric. This does not impact the calculation of the rest and NA is stored in the new data frames instead, since mean and sd are not applicable in this case. The same applies for Subject where we're not interested about the mean and sd, but since it's numeric already there is no warning.

Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Finaly the desired result, a tidy data table is created with the average of each measurement per activity/subject combination. The new dataset is saved in tidy.csv file.

DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy, "tidy.txt")
