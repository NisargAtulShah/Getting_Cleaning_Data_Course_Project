## Getting and Cleaning data - Course project - 31st jan 2016
## The aim of this code is to create a tidy dataset as per the instructions of the assignment
## The raw data used below and its data-details can be found on  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#### MERGE THE TEST AND TRAIN DATABASES
	## set the working directory in the folder which has the unzipped data downloaded from the website
	setwd("D:/Dropbox/nisarg_dss_home/3_getting_cleaning_data/course_project")

	## move to the "train" folder
	setwd("./train")
	
	## read the 3 databases using read.table(), default options work fine
	xtrain<-read.table("X_train.txt")
	ytrain<-read.table("y_train.txt")
	sub_train<-read.table("subject_train.txt")
	
	## combine the data sets,column-wise
	train_data <- cbind(sub_train,ytrain,xtrain)
	
	## move to the "test" folder
	setwd("../test")
	
	## read the 3 databases using read.table(), default options work fine
	xtest<-read.table("X_test.txt")
	ytest<-read.table("y_test.txt")
	sub_test<-read.table("subject_test.txt")
	
	## combine the data sets,column-wise
	test_data <- cbind(sub_test,ytest,xtest)

	## combine the test and train data, row-wise
	full_data<-rbind(test_data,train_data)
	##check the dimensions to confirm a correct merge	
	dim(full_data) 


#### ADD DESCRIPTIVE VARIABLE NAMES AND EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT	
	## Move to the folder which has the unzipped data
	setwd("../")
	## read in the file with the descriptive variable names using read.table(), default options work fine
	var_names<-read.table("features.txt")
	## Asign the descriptive names from the 2nd column of table, along with names for 'subject' an 'activity' columns
	names(full_data)<-c("subject","activity",as.character(t(var_names$V2)))

	## get a logical vector corresponding to the variable names vector,
	## the value is true if the name has mean() or std() in it
	mean_std_vars<-(grepl("mean\\(\\)",var_names$V2) | grepl("std\\(\\)",var_names$V2))

	## subset the columns of the full data using the above logical vetor, to get a data with only mean and standard deviation measures
	mean_std_data<-full_data[,c("subject","activity",as.character(t(var_names$V2[mean_std_vars])))]

#### ADD DESCRIPTIVE NAMES FOR THE ACTIVITIES		
	## the for loop looks at each entry in the activity column and replaces the number with the corresponding description
	## this can also be done in a much more elegant and effective way, but as the data is not huge, its fine
	for (i in 1:nrow(mean_std_data)) {
	     if (mean_std_data[i,2] == "1") {mean_std_data[i,2] <- "WALKING"}
	     if (mean_std_data[i,2] == "2") {mean_std_data[i,2] <- "WALKING_UPSTAIRS"}
	     if (mean_std_data[i,2] == "3") {mean_std_data[i,2] <- "WALKING_DOWNSTAIRS"}
	     if (mean_std_data[i,2] == "4") {mean_std_data[i,2] <- "SITTING"}
	     if (mean_std_data[i,2] == "5") {mean_std_data[i,2] <- "STANDING"}
	     if (mean_std_data[i,2] == "6") {mean_std_data[i,2] <- "LAYING"}
		} 

#### GET THE AVERAGE OF EACH VARIABLE, FOR EACH ACTIVITY, FOR EACH SUBJECT
	## load the dplyr library to access the group_by and summarize_each functions
	library(dplyr)		
	## group the data frame by the variables subject and activity, As it is done in a single groupby, 
	## the rows are first grouped by subjects and within the same subject, they are grouped by the activity
	mean_std_data_grp<-group_by(mean_std_data,subject,activity)
	
	## for each subject and each activity, the other variables are summarized using the mean function	
	summarized_data<-summarize_each(mean_std_data_grp,funs(mean))

	## converting the dataset into a data frame for ease of usage
	summarized_df <-as.data.frame(summarized_data)
		
	##check the dimensions to confirm an expected output	
	dim(summarized_df) 

#### CREATE AND OUTPUT A TIDY DATASET
	## the summarized data already has one row per observation
	## all variables are already in different columns
	## as there are no other tables, no keys to link to other tables are required
	## the character variables subject and activity should be converted to factor variables
	summarized_df$subject<-as.factor(summarized_df$subject)
	summarized_df$activity<-as.factor(summarized_df$activity)
	
	## the variable names are not clean, need to remove special characters and make the names easily understandable
	unclean_names <- names(summarized_df)
	
	## replace t and f
	time<-gsub("^t","TimeDomain",unclean_names)
	time_n_freq<-gsub("^f","FrequencyDomain",time)
	time_n_freq
	
	## add description instead of mean() and std()
	for (i in 1:length(time_n_freq)) {
	if (grepl("mean\\(\\)",time_n_freq)[i]) {time_n_freq[i]<-paste("AverageOf",time_n_freq[i],sep = "")}
	if (grepl("std\\(\\)",time_n_freq)[i]) {time_n_freq[i]<-paste("StandardDeviationOf",time_n_freq[i],sep = "")}
	     }

	## remove mean() and std() and add "along axis" IF applicable
	time_n_freq_new<-gsub("-std\\(\\)$","",time_n_freq)
	time_n_freq_new<-gsub("-mean\\(\\)$","",time_n_freq_new)
	time_n_freq_new<-gsub("-mean\\(\\)-","AlongAxis",time_n_freq_new)
	time_n_freq_new<-gsub("-std\\(\\)-","AlongAxis",time_n_freq_new)

	## prefix all names except first two with "group mean of"
	for (i in 3:length(time_n_freq_new)) {
	      time_n_freq_new[i]<-paste("GroupMeanOf",time_n_freq_new[i],sep = "")     
	      }
	clean_names <-time_n_freq_new     
	
	## assign the clean names to the complete the tidy dataset
	tidy_data<-summarized_df
	names(tidy_data) <- clean_names
	
	## write the tidy data set to a file
	write.table(tidy_data,row.name = F,file = "tidy_data.txt")
	
	
	
