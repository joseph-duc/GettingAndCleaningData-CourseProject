# This file will do the following:
# 1. load required libraries.
# 2. Define a function (download_data) to download data which is used for this course project
# 3. Define a function (run_analysis) to do requirement items of this course project.



download_data <- function() {
    # To download data which is used for this course project.
    # downloaded file is saved as "dataset.zip"
    # Then, unzip the downloaded file at the current directory
    
    url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
    downfile <- 'dataset.zip'
    
    download.file(url, destfile = downfile, method = 'curl')
    unzip(downfile)
}





load_data <- function (data_file) {
    # function to load data from a text file without header
    # Return data frame
    read.table(data_file,header=FALSE)
}
run_analysis <- function() {
    # 
    # 1. Merges the training and the test sets to create one data set.
    # 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    # 3. Uses descriptive activity names to name the activities in the data set
    # 4. Appropriately labels the data set with descriptive variable names. 
    # 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
    dataDir <- "./UCI HAR Dataset"
    print(sprintf("[INFO] - Data directory is '%s'", dataDir))
    
    
    print("[INFO] - Load feature + traning data")
    features <- load_data(paste(dataDir, 'features.txt', sep = "/"))
    subjectTrain <- load_data(paste(dataDir, 'train/subject_train.txt', sep = "/"))
    xTrain <- load_data(paste(dataDir, 'train/X_train.txt', sep = "/"))
    yTrain <- load_data(paste(dataDir, 'train/y_train.txt', sep = "/"))
    
    print("[INFO] - Assigin column names to the data imported above")
    colnames(subjectTrain) <- "subjectId";
    colnames(xTrain) <- features[,2]; 
    colnames(yTrain) <- "activityId";
    
    print("[INFO] - merge data train")
    train = cbind(yTrain,subjectTrain,xTrain)
    
    print("[INFO] - Load test data")
    subjectTest <- load_data(paste(dataDir, 'test/subject_test.txt', sep = "/"))
    xTest <- load_data(paste(dataDir, 'test/X_test.txt', sep = "/"))
    yTest <- load_data(paste(dataDir, 'test/y_test.txt', sep = "/"))
    
    print("[INFO] - Assign column names to the test data loaded above")
    colnames(subjectTest) <- "subjectId"
    colnames(xTest) <- features[,2]
    colnames(yTest) <- "activityId"

    print("[INFO] - merge data test")
    test <- cbind(yTest,subjectTest,xTest)

    print("[INFO] - Join training and test data to create a final data set")
    data <- rbind(train, test)
    
    # 2. Extract only the measurements on the mean and standard deviation for
    # each measurement.
    print("[INFO] - Identify items in mean and standard deviation from merged data")
    colNames <- colnames(data)
    extractedData <- data[grepl("(activity..|subject..|-(mean|std)\\()",colNames)==TRUE]
    
    # 3. Use descriptive activity names to name the activities in the data set
    
    print("[INFO] - Merge the extractedData set with the acitivity table to include descriptive activity names")
    activity <-load_data(paste(dataDir, 'activity_labels.txt', sep = "/"))
    colnames(activity) <- c('activityId','activityType')
    extractedData <- merge(extractedData, activity, by = 'activityId', all.x = TRUE)
    
    # 4. Rename columns
    print("[INFO] - Updating the column names to include the new column names after merge")
    colNames  = colnames(extractedData)
    for (i in 1:length(colNames)) 
    {
        colNames[i] = gsub("\\()","",colNames[i])
        colNames[i] = gsub("-std$","StdDev",colNames[i])
        colNames[i] = gsub("-mean","Mean",colNames[i])
        colNames[i] = gsub("^(t)","time",colNames[i])
        colNames[i] = gsub("^(f)","freq",colNames[i])
        colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
    }
    colnames(extractedData) = colNames;
    
    
    print("[INFO] - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
    # Create a new table, finalDataNoActivityType without the activityType column
    activeCol <- names(extractedData) != 'activityType'
    finalDataNoActivityType  = extractedData[,activeCol]
    
    # Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
    activeCol <- names(finalDataNoActivityType) != c('activityId','subjectId')
    tidyData    = aggregate(finalDataNoActivityType[,activeCol],
                            by=list(activityId = finalDataNoActivityType$activityId,
                                    subjectId = finalDataNoActivityType$subjectId),
                            mean)
    
    # Merging the tidyData with activityType to include descriptive acitvity names
    tidyData    = merge(tidyData,activity,by='activityId',all.x=TRUE)
    
    # Export the tidyData set 
    write.table(tidyData, './submitData.txt',row.names=TRUE,sep='\t')
}