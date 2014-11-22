
##You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

#set working directory.
setwd("D:/Brady/coursera/Get and clean data/UCI HAR Dataset")

#fast way to deal with fixed width format dataset.
library(LaF)

##Step 1. Merges the training and the test sets to create one data set. -- START

        #for training set
        
        #Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
        subject_train_Data <- read.table("./train/subject_train.txt")
        #set varable's name
        names(subject_train_Data) = c("subject")
        
        #Training labels.
        y_train_Data <- read.table("./train/y_train.txt")
        #set varable's name
        names(y_train_Data) = c("label")

        #List of all features
        feature_Data <- read.table("./features.txt")

        #A 561-feature vector with time and frequency domain variables.
        #Training set.
        #x_train_Data <- read.fwf("./train/X_train.txt", widths=c(rep(16, times=561)), n=3)
        #x_train_Data <- read.fwf("./train/X_train.txt", widths=c(rep(16, times=561)))
        laf_train <- laf_open_fwf("./train/X_train.txt", column_types=c(rep("numeric", times=561)), column_widths=c(rep(16, times=561)))
        #laf_train <- laf_open_fwf("./train/X_train.txt", column_types=c(rep("numeric", times=561)), column_widths=c(rep(16, times=561)), column_names=feature_Data$V2)
        
        #get dataset from class laf
        x_train_Data <- laf_train[,]

        #set varaiables' name
        names(x_train_Data) = feature_Data$V2

        #merge training dataset together
        #mergedData4trainning <- cbind(type=c(rep(1, times=nrow(subject_train_Data))), subject_train_Data, y_train_Data, x_train_Data)
        mergedData4trainning <- cbind(subject_train_Data, y_train_Data, x_train_Data)

        #for test set
        
        #Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
        subject_test_Data <- read.table("./test/subject_test.txt")
        #set varable's name
        names(subject_test_Data) = c("subject")
        
        #Test labels.
        y_test_Data <- read.table("./test/y_test.txt")
        #set varable's name
        names(y_test_Data) = c("label")
        
        #A 561-feature vector with time and frequency domain variables.
        #Test set.
        #x_test_Data <- read.fwf("./test/X_test.txt", widths=c(rep(16, times=561)), n=3)
        laf_test <- laf_open_fwf("./test/X_test.txt", column_types=c(rep("numeric", times=561)), column_widths=c(rep(16, times=561)))
        #laf_test <- laf_open_fwf("./test/X_test.txt", column_types=c(rep("numeric", times=561)), column_widths=c(rep(16, times=561)), column_names=feature_Data$V2)
        
        #get dataset from class laf
        x_test_Data <- laf_test[,]
        
        #set varaiables' name
        names(x_test_Data) = feature_Data$V2
        
        #merge test dataset together
        #mergedData4test <- cbind(type=c(rep(2, time=length(subject_test_Data))), subject_test_Data, y_test_Data)
        #mergedData4test <- cbind(type=c(rep(2, times=nrow(subject_test_Data))), subject_test_Data, y_test_Data, x_test_Data)
        mergedData4test <- cbind(subject_test_Data, y_test_Data, x_test_Data)
        
        #merge all of dataset together
        mergedDataAll <- rbind(mergedData4trainning, mergedData4test)

        #ordering dataset
        library(plyr)
        mergedDataAll <- arrange(mergedDataAll, subject, label)
##Step 1. Merges the training and the test sets to create one data set. -- END

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. -- START
        #for detecting by partial column names
        library(stringr)
        
        #ectract he measurements on the mean
        extracted_mean_Data <- mergedDataAll[, str_detect(names(mergedDataAll), "mean")]
        
        #ectract he measurements on the std
        extracted_std_Data <- mergedDataAll[, str_detect(names(mergedDataAll), "std")]

        #combin data set together
        #extracted_Data <- cbind(mergedDataAll[, 1:3], extracted_mean_Data, extracted_std_Data)
        extracted_Data <- cbind(mergedDataAll[, 1:2], extracted_mean_Data, extracted_std_Data)
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. -- END

## 3. Uses descriptive activity names to name the activities in the data set -- START
        #get activity labels info
        activity_labels_Data <- read.table("./activity_labels.txt")

        #set variables' names
        names(activity_labels_Data) = c("activity_id", "activity")
        
        #assigning the related activity name by activity id
        merged_activity_Data <- merge(activity_labels_Data, extracted_Data, by.x="activity_id", by.y="label")
        
        #ordering dataset
        merged_activity_Data <- arrange(merged_activity_Data, subject, activity)

## 3. Uses descriptive activity names to name the activities in the data set -- END

## 4. Appropriately labels the data set with descriptive variable names. -- START
        #removing all punctuation to set new variable names.        
        names(merged_activity_Data) = gsub("[[:punct:]]", "", names(merged_activity_Data))
## 4. Appropriately labels the data set with descriptive variable names. -- END

## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject. -- START
        library(data.table)
        #covert to data.table format
        dt <- data.table(merged_activity_Data)

        #summarising data is based on grouping by subject and activity.
        summarised_Date <- dt[, list(tBodyAccmeanX=mean(tBodyAccmeanX), tBodyAccmeanY=mean(tBodyAccmeanY)
                                     ,tBodyAccmeanZ=mean(tBodyAccmeanZ), tGravityAccmeanX=mean(tGravityAccmeanX)
                                     , tGravityAccmeanY=mean(tGravityAccmeanY)
                                     , tGravityAccmeanZ=mean(tGravityAccmeanZ)
                                     , tBodyAccJerkmeanX=mean(tBodyAccJerkmeanX)
                                     , tBodyAccJerkmeanY=mean(tBodyAccJerkmeanY)
                                     , tBodyAccJerkmeanZ=mean(tBodyAccJerkmeanZ)
                                     , tBodyGyromeanX=mean(tBodyGyromeanX)
                                     , tBodyGyromeanY=mean(tBodyGyromeanY)
                                     , tBodyGyromeanZ=mean(tBodyGyromeanZ)
                                     , tBodyGyroJerkmeanX=mean(tBodyGyroJerkmeanX)
                                     , tBodyGyroJerkmeanY=mean(tBodyGyroJerkmeanY)
                                     , tBodyGyroJerkmeanZ=mean(tBodyGyroJerkmeanZ)
                                     , tBodyAccMagmean=mean(tBodyAccMagmean)
                                     , tGravityAccMagmean=mean(tGravityAccMagmean)
                                     , tBodyAccJerkMagmean=mean(tBodyAccJerkMagmean)
                                     , tBodyGyroMagmean=mean(tBodyGyroMagmean)
                                     , tBodyGyroJerkMagmean=mean(tBodyGyroJerkMagmean)
                                     , fBodyAccmeanX=mean(fBodyAccmeanX)
                                     , fBodyAccmeanY=mean(fBodyAccmeanY)
                                     , fBodyAccmeanZ=mean(fBodyAccmeanZ)
                                     , fBodyAccmeanFreqX=mean(fBodyAccmeanFreqX)
                                     , fBodyAccmeanFreqY=mean(fBodyAccmeanFreqY)
                                     , fBodyAccmeanFreqZ=mean(fBodyAccmeanFreqZ)
                                     , fBodyAccJerkmeanX=mean(fBodyAccJerkmeanX)
                                     , fBodyAccJerkmeanY=mean(fBodyAccJerkmeanY)
                                     , fBodyAccJerkmeanZ=mean(fBodyAccJerkmeanZ)
                                     , fBodyAccJerkmeanFreqX=mean(fBodyAccJerkmeanFreqX)
                                     , fBodyAccJerkmeanFreqY=mean(fBodyAccJerkmeanFreqY)
                                     , fBodyAccJerkmeanFreqZ=mean(fBodyAccJerkmeanFreqZ)
                                     , fBodyGyromeanX=mean(fBodyGyromeanX)
                                     , fBodyGyromeanY=mean(fBodyGyromeanY)
                                     , fBodyGyromeanZ=mean(fBodyGyromeanZ)
                                     , fBodyGyromeanFreqX=mean(fBodyGyromeanFreqX)
                                     , fBodyGyromeanFreqY=mean(fBodyGyromeanFreqY)
                                     , fBodyGyromeanFreqZ=mean(fBodyGyromeanFreqZ)
                                     , fBodyAccMagmean=mean(fBodyAccMagmean)
                                     , fBodyAccMagmeanFreq=mean(fBodyAccMagmeanFreq)
                                     , fBodyBodyAccJerkMagmean=mean(fBodyBodyAccJerkMagmean)
                                     , fBodyBodyAccJerkMagmeanFreq=mean(fBodyBodyAccJerkMagmeanFreq)
                                     , fBodyBodyGyroMagmean=mean(fBodyBodyGyroMagmean)
                                     , fBodyBodyGyroMagmeanFreq=mean(fBodyBodyGyroMagmeanFreq)
                                     , fBodyBodyGyroJerkMagmean=mean(fBodyBodyGyroJerkMagmean)
                                     , fBodyBodyGyroJerkMagmeanFreq=mean(fBodyBodyGyroJerkMagmeanFreq)
                                     , tBodyAccstdX=mean(tBodyAccstdX)
                                     , tBodyAccstdY=mean(tBodyAccstdY)
                                     , tBodyAccstdZ=mean(tBodyAccstdZ)
                                     , tGravityAccstdX=mean(tGravityAccstdX)
                                     , tGravityAccstdY=mean(tGravityAccstdY)
                                     , tGravityAccstdZ=mean(tGravityAccstdZ)
                                     , tBodyAccJerkstdX=mean(tBodyAccJerkstdX)
                                     , tBodyAccJerkstdY=mean(tBodyAccJerkstdY)
                                     , tBodyAccJerkstdZ=mean(tBodyAccJerkstdZ)
                                     , tBodyGyrostdX=mean(tBodyGyrostdX)
                                     , tBodyGyrostdY=mean(tBodyGyrostdY)
                                     , tBodyGyrostdZ=mean(tBodyGyrostdZ)
                                     , tBodyGyroJerkstdX=mean(tBodyGyroJerkstdX)
                                     , tBodyGyroJerkstdY=mean(tBodyGyroJerkstdY)
                                     , tBodyGyroJerkstdZ=mean(tBodyGyroJerkstdZ)
                                     , tBodyAccMagstd=mean(tBodyAccMagstd)
                                     , tGravityAccMagstd=mean(tGravityAccMagstd)
                                     , tBodyAccJerkMagstd=mean(tBodyAccJerkMagstd)
                                     , tBodyGyroMagstd=mean(tBodyGyroMagstd)
                                     , tBodyGyroJerkMagstd=mean(tBodyGyroJerkMagstd)
                                     , fBodyAccstdX=mean(fBodyAccstdX)
                                     , fBodyAccstdY=mean(fBodyAccstdY)
                                     , fBodyAccstdZ=mean(fBodyAccstdZ)
                                     , fBodyAccJerkstdX=mean(fBodyAccJerkstdX)
                                     , fBodyAccJerkstdY=mean(fBodyAccJerkstdY)
                                     , fBodyAccJerkstdZ=mean(fBodyAccJerkstdZ)
                                     , fBodyGyrostdX=mean(fBodyGyrostdX)
                                     , fBodyGyrostdY=mean(fBodyGyrostdY)
                                     , fBodyGyrostdZ=mean(fBodyGyrostdZ)
                                     , fBodyAccMagstd=mean(fBodyAccMagstd)
                                     , fBodyBodyAccJerkMagstd=mean(fBodyBodyAccJerkMagstd)
                                     , fBodyBodyGyroMagstd=mean(fBodyBodyGyroMagstd)
                                     , fBodyBodyGyroJerkMagstd=mean(fBodyBodyGyroJerkMagstd)
                                     
                                )
                                , by=list(subject, activity)]
        
        #output txt file that store from dataset - summarised_Date.txt.
        write.table(summarised_Date, "summarised_Date.txt", quote = FALSE, sep = "\t", row.names = FALSE)

## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject. -- END

