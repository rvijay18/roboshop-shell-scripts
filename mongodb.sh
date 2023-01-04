LOG_FILE=/tmp/mongodb
source common.sh

echo 'setting MongoDB repo'
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
StatusCheck $?

echo 'Installing MongoDB server'
yum install -y mongodb-org &>>$LOG_FILE
StatusCheck $?

echo 'Starting MongoDB Service'
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
StatusCheck $?


echo 'update MongoDB Listen address'
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatusCheck $?


systemctl restart mongod &>>$LOG_FILE
StatusCheck $?

echo "Download Mongodb Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /tmp

echo "Extract Schema file"
unzip mongodb.zip &>>$LOG_FILE
StatusCheck $?

cd mongodb-main

echo "Load catalogue service schema"
mongo < catalogue.js &>>$LOG_FILE
StatusCheck $?

echo "Load users service schema"
mongo < users.js &>>$LOG_FILE
StatusCheck $?




