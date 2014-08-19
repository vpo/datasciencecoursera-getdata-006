run_analysis <- function() {
    ## see https://class.coursera.org/getdata-006/human_grading/view/courses/972584/assessments/3/submissions

    ## 1. Merges the training and the test sets to create one data set.

    ## read train data
    print("read train data set")
    train_set <- read.fwf(file="UCI_HAR_Dataset/train/X_train.txt", widths=rep(c(-2,14), length.out=561*2))
    ## read and add activity class
    train_set$ACTIVITY_CLASS <- read.fwf(file="UCI_HAR_Dataset/train/y_train.txt", widths=c(1))$V1    
    ## read and add subject
    train_set$SUBJECT <- read.fwf(file="UCI_HAR_Dataset/train/subject_train.txt", widths=c(1))$V1    
    
    ## read test data
    print("read test data set")
    test_set <- read.fwf(file="UCI_HAR_Dataset/test/X_test.txt", widths=rep(c(-2,14), length.out=561*2))
    ## read and add activity classes
    test_set$ACTIVITY_CLASS <- read.fwf(file="UCI_HAR_Dataset/test/y_test.txt", widths=c(1))$V1    
    ## read and add subject
    test_set$SUBJECT <- read.fwf(file="UCI_HAR_Dataset/test/subject_test.txt", widths=c(1))$V1
    
    ## merge train and test data 
    data_set_all <- rbind(train_set, test_set)
    
    ## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    
    print("set column names")
    
    ## set header names for all columns
    col_names <- read.csv("UCI_HAR_Dataset/features.txt", sep = " ", colClasses = c("integer", "character"), header = FALSE)
    colnames(data_set_all) <- c(col_names$V2, c("ACTIVITY_CLASS", "SUBJECT"))
    
    ## extract mean and std value names + activity class + subject
    col_names2 <- append(subset(col_names, grepl("mean\\(|std\\(", col_names[[2]]))$V2 , c("ACTIVITY_CLASS", "SUBJECT"))
    data_set <- data_set_all[col_names2]
    
    ## 3. Uses descriptive activity names to name the activities in the data set
    activity_names <- read.csv("UCI_HAR_Dataset/activity_labels.txt", sep = " ", colClasses = c("integer", "character"), header = FALSE)
    data_set <- merge(data_set, activity_names, by.x = "ACTIVITY_CLASS", by.y = "V1", all = TRUE)
    colnames(data_set)[which(names(data_set) == "V2")] <- "ACTIVITY_NAME"
    
    ## 4. Appropriately labels the data set with descriptive variable names. 
    ## done in 2. step
    
    ## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
    print("generate tidy data set")
    
    ## create mean aggregate with grouping of subject and activity name
    data_set_aggr <- aggregate(data_set[,!(names(data_set) %in% c("ACTIVITY_CLASS","SUBJECT","ACTIVITY_NAME"))], 
                               list(data_set$SUBJECT, data_set$ACTIVITY_NAME), FUN = "mean")
    
    # rename columns
    colnames(data_set_aggr)[1] <- "Subject"
    colnames(data_set_aggr)[2] <- "Activity"
    
    for (i in 3:ncol(data_set_aggr)) {
        cn <- colnames(data_set_aggr)[i]
        colnames(data_set_aggr)[i] <- paste(cn, "-avg", sep="")
    }
    
    ## write data to fs
    write.table(data_set_aggr, "tidy_data_aggregate.csv", sep="\t", row.name = FALSE)
    
}
