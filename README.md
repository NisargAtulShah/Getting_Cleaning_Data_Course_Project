# Getting_Cleaning_Data_Course_Project - This repository is for the Course Project.

##The code in the repository, "run_analysis" is explained below:

The aim of this code is to create a tidy dataset as per the instructions of the assignment
The raw data used below and its data-details can be found on  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

I have first merged the 3 base datsets to create databases for each test and train seperately.
The 3 base datasets have been merged using a column bind, while the resulting test and train databases have been merged using row-bind

to add the descriptive names i have imported the features.txt file, and assigned the second element of it, as the names of the combined test and train database (full_data)



##The code book for the data is the file "code_book.txt"
