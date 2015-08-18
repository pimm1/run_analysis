#
# 1. Merging ddata
# we put every file in our working directory
#x_train.txt
#x_test.txt
#features.txt
#we read and merge files
x_test<-read.table("X_Test.txt")
x_train<-read.table("X_Train.txt")
x_features<-read.table("features.txt")
x_total<-merge(x_test,x_train, all=TRUE)
x_features2<-x_features$V2
names(x_total)<-x_features2
# x_total is the file with  headers


# 2.Extraction mean and std
x_meanstd<-x_total[,grep("[Mm]ean|[Ss]td",names(x_total))]

# 3
# we copy files in our working direcory
# y_train.txt
# y_test.txt
y_train<-read.table("y_train.txt")
y_test<-read.table("y_test.txt")
y_total<-rbind(y_test,y_train)
dat<-y_total$V1
dat<-gsub("1","WALKING",dat)
dat<-gsub("2","WALKING_UPSTAIRS",dat)
dat<-gsub("3","WALKING_DOWNSTAIRS",dat)
dat<-gsub("4","SITTING",dat)
dat<-gsub("5","STANDING",dat)
dat<-gsub("6","LAYING",dat)
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING
# we placed it in the data set
x_meanstd[87]<-dat
# and a good name
names(x_meanstd)[87]<-"Activity"


# 4. Renaming columns
# Acc-> aceleration
# mag-> magnitude
# gyro-> gyroscopic
# ageDx-> ageatDiagnosis
# bodybody-> body
# freq->frequency
# vector with colum names
data<-names(x_meanstd)
# renaming 
data<-gsub("[Aa]cc","Aceleration",data)
data<-gsub("[Mm]ag","Magnitude",data)
data<-gsub("[Gg]yro","gyroscopic",data)
data<-gsub("[Aa]geDx","ageatDiagnosis",data)
data<-gsub("[Bb]ody[Bb]ody","body",data)
data<-gsub("[Ff]req","frecuency",data)
# renaming the columns with new vector
names(x_meanstd)<-data
x_result2<-summarise(group_by(x_meanstd,"Activity","Subjects"),mean(round(as.numeric(as.character(tBodyAceleration.mean...X)),6)))

# 5 last_tidy data_set
# we copy files with subjects in the working directory.
# subject_test
# subject_train
subject_test<-read.table("subject_test.txt")
subject_train<-read.table("subject_train.txt")
subject_total<-rbind(subject_test,subject_train)
# we place a nice name
names(subject_total)[1]<-"Subjects"
x_meanstd[88]<-subject_total
library(dplyr)
# to get medias the best is to use summarise_each
# we group by selected activities
by_group <- x_meanstd %>% group_by(Activity,Subjects)
res_fin<- by_group %>% summarise_each(funs(mean))
write.table(res_fin,"Resfin.txt",row.name=FALSE)
#The tidy data set is Resfin.txt


