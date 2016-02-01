run_analysis<-function() {

  # 0. load datasets
  # load training & test set subject ids
  subj.tr<-read.table("UCI HAR Dataset/train/subject_train.txt")
  subj.te<-read.table("UCI HAR Dataset/test/subject_test.txt")
  
  # load activity label names
  act.labels<-read.table("UCI HAR Dataset/activity_labels.txt")
  # load training & test set activity label ids
  labels.tr<-read.table("UCI HAR Dataset/train/y_train.txt")
  labels.te<-read.table("UCI HAR Dataset/test/y_test.txt")
  
  # load sets column names
  features<-read.table("UCI HAR Dataset/features.txt")
  # load training & test sets
  set.tr<-read.table("UCI HAR Dataset/train/X_train.txt")
  set.te<-read.table("UCI HAR Dataset/test/X_test.txt")
  
  # 1. Merges the training and the test sets to create one data set.
  # add set id
  set.tr$setname <- "training"
  set.te$setname <- "test"
  
  # concatenate datasets
  set <- rbind(set.tr, set.te)

  # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  # set feature names to training & test sets
  names(set)<-append(as.character(features$V2),"setname")

  # get names vector and filter set selecting appropriate columns
  n<-names(set)
  n2<-n[grep("mean\\(\\)|std\\(\\)|setname", n)]
  set2<-set[,n[grep("mean\\(\\)|std\\(\\)|setname", n)]]
  
  # 3. Uses descriptive activity names to name the activities in the data set
  # concatenate activity labels
  labels <- rbind(labels.tr, labels.te)

  # replace activity ids by activity descriptions  
  labels2 <- labels
  labels2<-replace.labels(1, labels2, act.labels)
  labels2<-replace.labels(2, labels2, act.labels)
  labels2<-replace.labels(3, labels2, act.labels)
  labels2<-replace.labels(4, labels2, act.labels)
  labels2<-replace.labels(5, labels2, act.labels)
  labels2<-replace.labels(6, labels2, act.labels)

  # 4. Appropriately labels the data set with descriptive variable names.
  # concatenate subject ids
  subj <- rbind(subj.tr, subj.te)

  # add subject ids to sets
  set2$subject <- subj$V1

  # add activity labels to sets
  set2$activity <- labels2$V1

  # 5. From the data set in step 4, creates a second, independent tidy data set
  #    with the average of each variable for each activity and each subject.
  library(dplyr)
  
  m.by.feature<-mean.by.feature(set2, 1, act.labels, addlabels = T)
  for(col.idx in 2:66) {
    m.by.feature<-cbind(m.by.feature, mean.by.feature(set2, col.idx, act.labels, addlabels = F))
  }

  write.csv(m.by.feature, "feature_means.csv")
  
  write.table(m.by.feature, "feature_means.txt", row.names = FALSE)
  
  m.by.feature
}

replace.labels<-function(index, labels2, act.labels) {
  x<-factor(act.labels$V2, levels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"), ordered = T)
  labels2[labels2$V1 == index & !is.na(labels2$V1),] <- as.character(x[index])
  labels2
  #labels2[labels2$V1 == x[index],]
}

transpose<-function(res, feat.name, act.label, addlabels = F) {
  if(addlabels) {
    subj.ids<-rownames(res)
    z<-data.frame(subj.ids)
    #z$activity<-colnames(res)[1]
    z$activity<-act.label
    z$feat.name<-res[,act.label]
    names(z)<-c("subject", "activity", feat.name)
  } else {
    z<-data.frame(res[,act.label])
    names(z)<-c(feat.name)
  }
  z
}

mean.by.feature<-function(set2, set2.col.id, act.labels, addlabels = F) {
  res<-with(set2, tapply(set2[[set2.col.id]], list(subject, activity), mean))
  transp<-transpose(res, names(set2)[set2.col.id], act.labels$V2[1], addlabels)
  transp<-rbind(transp, transpose(res, names(set2)[set2.col.id], act.labels$V2[2], addlabels))
  transp<-rbind(transp, transpose(res, names(set2)[set2.col.id], act.labels$V2[3], addlabels))
  transp<-rbind(transp, transpose(res, names(set2)[set2.col.id], act.labels$V2[4], addlabels))
  transp<-rbind(transp, transpose(res, names(set2)[set2.col.id], act.labels$V2[5], addlabels))
  transp<-rbind(transp, transpose(res, names(set2)[set2.col.id], act.labels$V2[6], addlabels))
  transp
}