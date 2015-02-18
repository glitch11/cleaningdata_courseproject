run_analysis<-function(){
  
  ##download file
  
  zipfile<-tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",zipfile)
  
  ##extract file
  
  directory<-"courseproject"
  unzip(zipfile, exdir=directory, unzip="internal")
  
  ##get current wd to re-set it at end
  currentwd<-getwd()
  
  ##BULLET 1 START
  ##Merges the training and the test sets to create one data set.
  
  ##read files into datasets from test directory
  ##subject_test.txt: the person ID (1 x 2947).
  ##x_test.txt: raw data (x by 2947)
  ##y_test.txt: the action ID (1 x 2947 again)
  
  setwd("./courseproject/UCI HAR Dataset/test")
  testgroup_rawdata<-read.table("X_test.txt")
  testgroup_actionID<-read.table("y_test.txt")
  testgroup_personID<-read.table("subject_test.txt")
  
  ##read in column headers for the raw data and set names for the test group
  setwd("..")
  testgroup_columnheaders <- read.table("features.txt")
  names(testgroup_rawdata)<-testgroup_columnheaders$V2
  names(testgroup_actionID)<-c("Action ID")
  names(testgroup_personID)<-c("Person ID")

  ##combine 3 test files into 1 denormalized file 
  denorm_test_data<-cbind(testgroup_rawdata, testgroup_actionID)
  denorm_test_data<-cbind(denorm_test_data, testgroup_personID)  
  
  ##read files into dataset from train directory
  setwd("./train")
  ##subject_train.txt: the person ID (1 x 7352).
  ##x_train.txt: raw data (x by 7352)
  ##y_train.txt: the action ID (1 x 7352 again)
  
  traingroup_rawdata<-read.table("X_train.txt")
  traingroup_actionID<-read.table("y_train.txt")
  traingroup_personID<-read.table("subject_train.txt")
  
  ##read in column headers for the raw data and set names for the train group
  setwd("..")
  traingroup_columnheaders <- read.table("features.txt")
  names(traingroup_rawdata)<-traingroup_columnheaders$V2
  names(traingroup_actionID)<-c("Action ID")
  names(traingroup_personID)<-c("Person ID")
  
  ##combine 3 test files into 1 denormalized file 
  denorm_train_data<-cbind(traingroup_rawdata, traingroup_actionID)
  denorm_train_data<-cbind(denorm_train_data, traingroup_personID)  
  
  ##add denorm test table to denorm train table
  denorm_total_data<-rbind(denorm_test_data, denorm_train_data)

  ##END BULLET 1.  

  ##START BULLET 2
  ##Extracts only the measurements on the mean and standard deviation for each measurement. 
  
  meancolumns<-grep("-mean()", names(denorm_total_data))
  stdcolumns<-grep("-std()", names(denorm_total_data))
  IDcolumns<-grep("ID", names(denorm_total_data))
  columnsiwant<-c(IDcolumns,meancolumns, stdcolumns)
  strippedata<-denorm_total_data[columnsiwant]
  
  ##END BULLET 2
  
  ##START BULLET 3
  ##Uses descriptive activity names to name the activities in the data set

  ##read in activity labels
  activitynames<-read.table("activity_labels.txt")
  ##merge activity names with action ID so that the descriptive activity name gets added
  mergeddata<-merge(activitynames, strippedata, by.x="V1", by.y="Action ID")
  ##END BULLET 3
  
  ##START BULLET 4
  ##Appropriately labels the data set with descriptive variable names. 
  names(mergeddata)[1]<-"ActivityID"
  names(mergeddata)[2]<-"ActivityName"
  ##All other column names were added in the BULLET 1 section
  
  ##END BULLET 4
  
  ##START BULLET 5
  ##From the data set in step 4, creates a second, 
  ##independent tidy data set with the average of each 
  ##variable for each activity and each subject.
  
  ##create factors for person ID and activity
  factoractivity<-factor(mergeddata$ActivityName, exclude="")
  factorperson<-factor(mergeddata$"Person ID", exclude="")
  
  ## group by 2 factors, person ID and activity and 
  ##generate the mean for that combo across all measures
  exportdata<-aggregate(x = mergeddata, by = list(factorperson,factoractivity),FUN="mean")
  
  ##drop extraneous columns and name the rest
  exportdata2 <- subset(exportdata, select = -c(1,3,4))
  names(exportdata2)[1]<-"ActivityName"
    
  ##write the final data set
  setwd(currentwd)
  write.table(exportdata2, file = "tidydataset.txt", row.name=FALSE)
  
  ##END BULLET 5
  

}