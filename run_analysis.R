# Download and unzip the data from the website
install.packages("downloader")
library(downloader)
url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  "
download(url, destfile = "C:/Users/User/Documents/R/gcd.zip",mode = "wb")
unzip("C:/Users/User/Documents/R/gcd.zip", exdir = "C:/Users/User/Documents/R/gcd")

# Read the data into R and name the tables
features <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
#Look at the file to se how it can be used for coulmn names
str(features)
# read and name the rest of the data
activities <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("C:/Users/User/Documents/R/gcd/UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Investigate the data
# Admittedly, this was done while doing step above, then re-doing the read command to include the name
str(features)
str(activities)
str(subject_test)
str(x_test)
str(y_test)
str(subject_train)
str(x_train)
str(y_train)

#1.Merge the training and the test sets to create one data set.
#First build the columns by binding the rows of the train and test data sets
subjects <- rbind(subject_train, subject_test)
xdata <- rbind(x_train, x_test)
ydata <- rbind(y_train, y_test)
#Now bind the columns together
dataset <- cbind(subjects, xdata, ydata)
#Look at the completed dataset
View(dataset)
#for the code book
colnames(dataset)
# 
#2. Extract only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
meanstddata<- dataset %>% 
            select(subject, code, contains("mean"), contains("std"))
# Look at the condensed data set
View(meanstddata)

#3. Use descriptive activity names to name the activities in the data set
meanstddata$code <- activities[meanstddata$code, 2]
names(meanstddata)[2] = "Activity"
#Control the meanstddata set
View(meanstddata)

#4.Appropriately label the data set with descriptive variable names. 
#look at the labels to rename
colnames(meanstddata)
names(meanstddata)<-gsub("Acc", "Accelerometer", names(meanstddata))
names(meanstddata)<-gsub("angle", "Angle", names(meanstddata))
names(meanstddata)<-gsub("BodyBody", "Body", names(meanstddata))
names(meanstddata)<-gsub("^f", "Frequency", names(meanstddata))
names(meanstddata)<-gsub("-freq()", "Frequency", names(meanstddata), ignore.case = TRUE)
names(meanstddata)<-gsub("gravity", "Gravity", names(meanstddata))
names(meanstddata)<-gsub("Gyro", "Gyroscope", names(meanstddata))
names(meanstddata)<-gsub("Mag", "Magnitude", names(meanstddata))
names(meanstddata)<-gsub("-mean()", "Mean", names(meanstddata), ignore.case = TRUE)
names(meanstddata)<-gsub("-std()", "STD", names(meanstddata), ignore.case = TRUE)
names(meanstddata)<-gsub("^t", "Time", names(meanstddata))
names(meanstddata)<-gsub("tBody", "TimeBody", names(meanstddata))
#Control the new labels
colnames(meanstddata)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
IndependantTidyData<- meanstddata %>%
  group_by(subject, Activity) %>%
  summarise_all(funs(mean))
#Control dimensions for 30 subject x 6 Activities, 88 variables
dim(IndependantTidyData)
#for the codebook column names
colnames(IndependantTidyData)
#Write it to a text file named TidyData
write.table(IndependantTidyData, file = "TidyData.txt", row.names = FALSE)
#This concludes this part of the assignment.