library(dplyr)

#STEP 1: Merges the training and the test sets to create one data set.

#Read features and test group files
features<-read.table("features.txt",header=FALSE)

x_test<-read.table("./test/X_test.txt",header=FALSE)
y_test<-read.table("./test/Y_test.txt",header=FALSE)
subject_test<-read.table("./test/subject_test.txt",header=FALSE)

#Assign variable names
names(x_test)<-features[,2]
names(y_test)<-"activity_index"
names(subject_test)<-"subject"

#Cbind subject, x and y information of the test group
xy_test<-cbind(subject_test,x_test)
xy_test<-cbind(xy_test,y_test)

#Read training group files
x_train<-read.table("./train/X_train.txt",header=FALSE)
y_train<-read.table("./train/Y_train.txt",header=FALSE)
subject_train<-read.table("./train/subject_train.txt",header=FALSE)

#Assign variable names
names(x_train)<-features[,2]
names(y_train)<-"activity_index"
names(subject_train)<-"subject"

#Cbind subject, x and y information of the test group
xy_train<-cbind(subject_train,x_train)
xy_train<-cbind(xy_train,y_train)

#Rbind test group data frame and training group data frame
all_xy_train_test<-rbind(xy_test,xy_train)

#Remove temporary variables from memory
rm(x_test)
rm(y_test)
rm(subject_test)
rm(x_train)
rm(y_train)
rm(subject_train)
rm(features)
rm(xy_test)
rm(xy_train)

#STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

#Grepl over names vector using Regular Expressions, subsetting "mean", "std" and relevant columns
all_xy_train_test_meanstd<-all_xy_train_test[,grepl("[Mm]ean|[Ss]td|subject|activity",names(all_xy_train_test))]
rm(all_xy_train_test)

#STEP 3: Uses descriptive activity names to name the activities in the data set


#Read activity labels and merge it with train/test data frame
activity_labels<-read.table("activity_labels.txt",header=FALSE)
names(activity_labels)<-c("activity_index","activity_description")
all_xy_train_test_meanstd_act<-merge(all_xy_train_test_meanstd,activity_labels,all=TRUE)

rm(all_xy_train_test_meanstd)
rm(activity_labels)

#Remove activity_index (not needed) using dplyr package
all_xy_train_test_meanstd_act<-select(all_xy_train_test_meanstd_act, -activity_index)

##STEP 4: Appropriately labels the data set with descriptive variable names. 

#Replace of expressions within names vector to label with more descriptive variable names
names(all_xy_train_test_meanstd_act)<-tolower(names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("-","_",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("^t","timedomain_",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("^f","frequencydomain_",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("acc","_acceleration",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("gyro","_gyroscope",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("jerk","_jerk",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("\\()","",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("_x","_x_axis",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("_y","_y_axis",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("_z","_z_axis",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("tbody","timedomain_body",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("angle","angle_between",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub(",","_and_",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("mag","_magnitude",names(all_xy_train_test_meanstd_act))
names(all_xy_train_test_meanstd_act)<-gsub("meanfreq","meanfrequency",names(all_xy_train_test_meanstd_act))

##STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#Create a tidy data set with the average of each variable for each activity and each subject
#Requires dplyr package
grouped<-group_by(all_xy_train_test_meanstd_act,subject,activity_description)
tidy<-summarise_each(grouped,funs(mean(., na.rm = TRUE)))
rm(grouped)

##tidy data frame is a tidy dataset because:
#Each variable is in one column, 
#Each different observation of that variable is in a different row

#Write the final txt file
write.table(tidy, "./tidydataset.txt",row.names = FALSE)
