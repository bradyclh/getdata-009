getdata-009
===========

Getting and Cleaning Data Course Project.

This cook book describes all of separate steps how to work.

Before the first step, setting working directory to be ready to get all of data files from UCI HAR dataset. (D:/Brady/coursera/Get and clean data/UCI HAR Dataset)

Step 1. Merges the training and the test sets to create one data set.
[subject_train.txt]
Using function read.table to get "subject_train.txt", stores in variable "subject_train_Data" and column's name is called "subject".

[y_train.txt]
Following previous operation, we get "y_train.txt" data into variable "y_train_Data" and set "label" to be column's name. 

[features.txt]
Variable feature_Data has caught from features.txt.

[X_train.txt]
The fast way is function laf_open_fwf that is good to deal with huge file "X_train.txt". However, the type of variable laf_train is class that have to convert to a data frame. The converted varalibe is called "x_train_Data" and its columns' names are labeled by the second column list from variable feature_Data.

And we collect three datasets(subject_train_Data, y_train_Data, x_train_Data) together to be new one called mergedData4trainning. Following operations, we create another dataset mergedData4test by testing data. Finally,
dataset mergedDataAll is that bind mergedData4trainning and mergedData4test, and  order by column subject, label.

Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Including library stringr, to find the column names that contain "mean" or "std" word. Then, to combine dataset extracted_mean_Data and extracted_std_Data into new collection called extracted_Data.

Step 3. Uses descriptive activity names to name the activities in the data set.
We read file activity_labels.txt and names it columns to be "activity_id" and "activity". New dataset merged_activity_Data is that contains activity_labels_Data and extracted_Data by the key "activity_id"/"label". In addition, dataset merged_activity_Data has re-ordered by columns "subject" and "activity".

Step 4. Appropriately labels the data set with descriptive variable names.
We use function gsub to replace all punctuations to define new variable names of datase merged_activity_Data.

Step 5. From the data set in step 4, creates a second, independent tidy data set.
About performance, to compare to two ways (ddply and data.table), the latter function is quick to handle for grouping dataset. Hence, we convert dataset merged_activity_Data to be format of data.table. Creating a dataset summarised_Date that combine list of hundreds of summarised dataset by two parts arguments. One of arguments is a list that computes to average values for each columns of dataset merged_activity_Data. The second part shows that all average values is grouping by subject and activity.

Finally, we write a file summarised_Date.txt that is from dataset summarised_Date.
