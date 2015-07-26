### Instructions

* The run_analysis.R script requieres the "UCI HAR Dataset.zip" unzipped and the "UCI HAR Dataset" folder set as Working Directory.
* This file contains the unique script to perform the analysis.

### Libraries required

* dplyr package

### Input files (considering "UCI HAR Dataset" as Working Directory)

* features.txt
* activity_labels.txt

##### Test files required

* ./test/X_test.txt
* ./test/Y_test.txt
* ./test/subject_test.txt

##### Training files required

* ./train/X_train.txt
* ./train/Y_train.txt
* ./test/subject_test.txt

### Output file

* ./tidydataset.txt

### Script description

1. The script reads the previously listed Input files into memory (features and X,Y,Subject for TEST and TRAINING Groups)
2. The script assings variable names to X_test from features data, as well as temporary variables for joins operations.
3. Considering data dimensions, the script CBINDs SUBJECT, X and Y datasets, for the TEST set.
4. Considering data dimensions, the script CBINDs SUBJECT, X and Y datasets, for the TRAINING set.
5. Considering data dimensions and common variables, the script RBINDs the previously created TEST(subject,x,y data) and TRAINING(subject,x,y data), getting a big dataset with all the information available, as it has been requested in the First Step of the Project.
6. The script removes temporary variables from memory.
7. The script searches for "mean" and "std" in the names vector of the dataset created using regular expressions to get all the possible instances (Mean,mean, Std,std). The script keeps the relevant variables not equal to mean or std as well. All of this is done by using the regular expression "[Mm]ean|[Ss]td|subject|activity".
8. The script joins (MERGE) the dataset obtained with the activity labels dataset to get "descriptive activity labels" as it has been requested. The MERGE is done by using the Activity Key, wich has been called "activity index".
9. The script works over the names vector of the dataset, replacing short expressions with descriptive ones (descriptive variable names labeling). The meaning of each variable has been interpreted by using the original available dataset information.
10. Finally, the script creates a second, independent tidy dataset with the average of each variable for each activity and each subject. This is done by using the "GROUP BY" and "SUMMARISE EACH" functions of the DPLYR package. This final dataset is in the **wide form** of tidy data. This dataset is tidy because: 
  * Each variable measured is in one column
  * Each different observation of that variable is in a different row
11. The final tidy dataset is written to a text file using the write.table command and row.names=false parameter.



