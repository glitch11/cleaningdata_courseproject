# cleaningdata_courseproject

run_analysis.R

Consists of code separated into 5 bullets matching the 5 bullets of the assignment.

Script itself is heavily commented.  

PRE-PROCESSING:
Downloading file and extracting file into working directory.
BULLET 1:Merges the training and the test sets to create one data set.
1. Read "test" data (3 files) into 3 data frames.
2. Read column headers.
3. Combine test data and column headers.
4. Read "train" data (3 files) into 3 data frames.
5. Read column headers.
6. Combine train data and column headers
7. Combine train and test data.

BULLET 2:Extracts only the measurements on the mean and standard deviation for each measurement.
1. Created a vector of column indices where the column names included mean() or std() or the ID columns
2. Created new dataframe using this vector as the subset parameter.

BULLET 3:Uses descriptive activity names to name the activities in the data set
1. Read in activity labels into a data frame
2. Merged main data set (bullet 1) with these activity labels.

BULLET 4: Appropriately labels the data set with descriptive variable names.
1. I'm not an engineer, the original variable names are as descriptive as I could ever make them.  These were left as-is.
2. I did fix the column names for Activity Name and Activity ID as these were nameless after the merge.

BULLET 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
1. Created factors for Activity Name (walking, etc) and Person (subject) ID.
2. Used the aggregate function to 'group by' (DBA terms) by Activity Name and Person ID and provide the mean for each unique combination of those 2 factors.
3. Exported tidy data set.  30 subjects, 6 activities = 180 rows (means), 81 (columns)  (79 were std and mean variables, 2 were groupings)

 




 