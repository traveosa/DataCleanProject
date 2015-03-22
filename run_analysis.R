#Copde used to create the tidy data sets
#read in train data
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
subTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"")

#read in test data
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")
subTest <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"")

#read features
features <- read.table("UCI HAR Dataset/features.txt", quote="\"")

#read activities
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"")

#join data and labels
datJoin <- rbind(xTrain, xTest)
labJoin <- rbind(yTrain, yTest)
subJoin <- rbind(subTrain, subTest)

#create labJoinFactor - a factor containing activity names applied to labels
labJoinFac <- factor(labJoin$activityNum, labels = as.character(activity_labels[, 2]))

#clean workspace - rid unecessary assets
rm(xTest, xTrain, yTest, yTrain)

#name the data
colnames(datJoin) <- features[, 2]
colnames(labJoin) <- "activityNum"
colnames(subJoin) <- "subjectNumber"

#find colnum for std and mean
mean_indices <- grep("mean", features[, 2])
std_indices <- grep("std", features[, 2])

#subset joined data based on mean and std
datJoinInterest <- datJoin[, c(mean_indices, std_indices)]

#combine data with subjects and activity mean/std
datJoinInterest <- cbind(subJoin, labJoinFac, datJoinInterest)

#rename variables to be more descriptive and clean
names(datJoinInterest) <- gsub("\\(\\)", "", names(datJoinInterest)) #the \\(\) escapes the parentheses
names(datJoinInterest) <- gsub("-", "", names(datJoinInterest))
names(datJoinInterest) <- gsub("mean", "Mean", names(datJoinInterest))
names(datJoinInterest) <- gsub("std", "Std", names(datJoinInterest))
names(datJoinInterest) <- gsub("labJoinFac", "activityName", names(datJoinInterest))

#create final data set using only interested variables
#use the aggregate function, which easily produces descriptive statistics
secDat <- aggregate(datJoinInterest[, 3:81], by=list(activity = datJoinInterest$activityName, subject = datJoinInterest$subjectNumber), mean)

#write out data file for submission
write.table(secDat, "secondDataTable.txt", row.name = FALSE)