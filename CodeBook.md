This file  describes the variables, the data, and any transformations or work that is performed to clean up the data


### File run_analysis.R will do the following:

1. Load required libraries.
2. Define a function (download_data) to download data which is used for this course project
3. Define a function (run_analysis) to do requirement items of this course project.


### Function download_data()

To download data from 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip' and store at the current folder with name: **dataset.zip**. Then it extract this zip file to used for this course project

### Function run_analysis()
This function will do the following tasks:

1. Load feature, training and test data from the current directory: "./UCI HAR Dataset" which is downloaded beforehand from URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, then unziped at the same folder of file run_analysis.R  
1. Assign column names for data tables which have just been loaded.  
1. Then aerges the training and the test sets to create one data set variable: **data**
1. Next step, this function will extract only the measurements on the mean and standard deviation for each measurement and store the desired data to variable: **extractedData**
3. Next step, this function will load activity information from file 'activity_labels.txt' and store to variable **activity**. Then, merge the extractedData set with the acitivity table to include descriptive activity names.
4. Appropriately labels the data set **extractedData** with descriptive variable names.
5. Finally, to calculate the average of each variable for each activity and each subject and write the result to file **submitData.txt**. This function defines another variable **finalDataNoActivityType** to store data for each activity of each subject (a subset of variable **extractedData**)

### Use this file in course project:
```{r}
source("run_analysis.R");
download_data();
run_analysis();
```


