#!/bin/bash

source components/common.sh

Print "Add MongoDB to YUM Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
Check_Stat $?

Print "Install MongoDB"
yum install -y mongodb-org &>>$LOG_FILE
Check_Stat $?

Print "Update MongoDB Listen Address "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
Check_Stat $?

Print "Start MongoDB"
systemctl enable mongod &>>$LOG_FILE && systemctl restart mongod &>>$LOG_FILE
Check_Stat $?

Print "Download Database Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
Check_Stat $?

Print "Extract Schema"
cd /tmp && unzip mongodb.zip &>>$LOG_FILE
Check_Stat $?

Print "Load Schema"
cd mongodb-main
for schema in catalogue users; do
  echo "Load $schema Schema"
  mongo < ${schema}.js &>>$LOG_FILE
done
Check_Stat $?

