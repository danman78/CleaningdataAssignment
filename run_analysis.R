
## import data
data.Subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
data.Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
data.Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")

data.Subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
data.Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
data.Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")

## combine test and train data

Fulldata.X <- rbind(data.Xtest, data.Xtrain)
Fulldata.Y <- rbind(data.Ytest, data.Ytrain)
Fulldata.sub <- rbind(data.Subtest, data.Subtrain)

## extract the locations of mean and std dev data
features <- read.table("./UCI HAR Dataset/features.txt", quote="\"", comment.char="")
extract <- grep("mean\\(\\)|std\\(\\)", features$V2)

## pull mean and sd from overall full data and rename columns
Fulldata.X.meanandstd <- Fulldata.X[,extract]
names(Fulldata.X.meanandstd) <- features[extract,2]

## add a column with the referenced activity
Fulldata.X.meanandstd1 <- cbind(Fulldata.Y,Fulldata.sub[,1], Fulldata.X.meanandstd)
colnames(Fulldata.X.meanandstd1)[1:2] <- c("Activity", "Subject")

#calculates the average by person and by activity

averagedata <- aggregate(x=Fulldata.X.meanandstd1, by = list(Fulldata.X.meanandstd1$Activity, 
                                                             Fulldata.X.meanandstd1$Subject), FUN =mean)


## import activity codes, adds them, cleans up the data set

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")


averagedata$Activity <- activitylabels[averagedata$Activity,2]
averagedata <- averagedata[, -c(1,2)]
write.table(averagedata, row.names = FALSE, "Assignment.txt")
View(averagedata)
