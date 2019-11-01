# Getting and Cleaning Data
This is the repository for the programing assignment of the course Getting and Cleaning Data on coursera. The original dataset used for this assignment can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). 

## run_analysis.R
This is the R script used to convert the original dataset into a tidy dataset. The script merges the training and test datasets into one dataset, adds relevant column names, keeps only the columns for mean and standard deviation, replaces activities by descriptive names, and creates a tidy dataset with the average for each varaible for each subject and activity. 

## FinalDataset.txt
This is the final tidy dataset created by the script 'run_analysis.R'. It contains the average of each variable for mean and standard deviation that are presented for each subject and activity. 

## Codebook.txt
The codebook is a modified version of the original codebook that describes the new tidy dataset 'FinalDataset.txt'. 