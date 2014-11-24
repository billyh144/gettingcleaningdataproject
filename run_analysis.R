#Dowloaded the data file and extracted into the set working directory
setwd("C:/Users/Billy/Desktop/R Data/UCI HAR Dataset")

trainData<-read.table("train/X_train.txt")
trainSubject<-read.table("train/subject_train.txt")
trainActivity<-read.table("train/Y_train.txt")
train<-cbind(trainData,trainSubject,trainActivity)

dim(trainData)
dim(train)

testData<-read.table("test/X_test.txt")
testSubject<-read.table("test/subject_test.txt")
testActivity<-read.table("test/Y_test.txt")
test<-cbind(testData,testSubject,testActivity)

dim(testData)
dim(test)

allData<-rbind(train,test)
dim(allData)

features <- read.table("features.txt",header=FALSE)
columns <- features[(grepl("mean\\(\\)",features$V2) | grepl("std()",features$V2)),]
columns_num <- columns[,1]+2
columns_num <- c(1,2,columns_num)
result <- allData[,columns_num]

length(columns_num)
dim(result)

columns_name <- c("activity_labels","subjects",as.vector(columns[,2]))
names(result) <- columns_name

activity_labels <- read.table("activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
name <- function(x, pattern, replace){
  for (i in seq_along(pattern)){
    x <- gsub(pattern[i], replace[i], x)
  }               
  x
}
result$activity_labels=name(result$activity_labels,activity_labels[,1],activity_labels[,2])



library(reshape2)
melted <- melt(result,id.vars=c("activity_labels","subjects"),na.rm = TRUE)
tidy_data <- dcast(melted, subjects + activity_labels ~ variable, mean) 

dim(tidy_data)


write.table(tidy_data,file="tidy_data.txt",quote=FALSE,row.names=FALSE)