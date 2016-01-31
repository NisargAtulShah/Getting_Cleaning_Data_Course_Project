# Getting_Cleaning_Data_Course_Project 
##- This repository is for the Course Project.

##The code in the repository, "run_analysis" is explained below:

The aim of this code is to create a tidy dataset as per the instructions of the assignment.
The raw data used below and its data-details can be found on  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

I have first merged the 3 base datsets to create databases for each test and train seperately.
The 3 base datasets have been merged using a column bind, while the resulting test and train databases have been merged using row-bind

To add the descriptive names i have imported the features.txt file, and assigned the second element of it, as the names of the combined test and train database (full_data)

then to only get the variables with mean() or std() in theis names, i have created a logical vector with the same condition and subsettted the columns of the full_data with it. the resulting dataset "mean_std_data" has just the required variables.

Next, using a for loop and the mapping provided in the file "activity_labels.txt" i replaced the number values with descriptive names.

To find the average of each variable for each subject and each activity i used the dplyr package.
after grouping the data by the group_by function and summarizing each variable with the function mean, i arrived at the required data

to make the data tidy, i needed to rename the variable and convert character variables in to factor variables.
I also converted the character variables to factor variables. All other requirements for tidy data were already met.

in renaming the variables i took the following steps:
*if starts with t add “TimeDomain” else if start with f then add “FrequencyDomain”
*if there is mean() then add “AverageOf” 
*if there is std() then add “StandardDeviationOf” 
*replace both mean() and std () by “AlongAxis” – except for last 8
*add “GroupMeanOf” in the starting of each var name

finally i exported the data using the write.table function.

##The code book for the data is the file "code_book.txt"
