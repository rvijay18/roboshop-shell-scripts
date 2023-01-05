LOG_FILE=/tmp/user
source common.sh

echo "setup Nodejs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
StatusCheck $?

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
StatusCheck $?

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]
then
  echo "Add roboshop Application User"
  useradd roboshop &>>$LOG_FILE
  StatusCheck $?
fi

echo "Download User Application Code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf user &>>$LOG_FILE
StatusCheck $?

echo "Extract Catalogue Application Code"
unzip /tmp/user.zip &>>$LOG_FILE
StatusCheck $?


mv user-main user

cd /home/roboshop/user

echo "Install Nodejs Dependencies"
npm install &>>$LOG_FILE
StatusCheck $?

echo "Install Nodejs Dependencies"
npm install &>>$LOG_FILE
StatusCheck $?

echo "Update SystemD Service File"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal' /home/roboshop/user/systemd.service
StatusCheck $?

echo "setup user services"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>$LOG_FILE
StatusCheck $?

systemctl daemon-reload &>>$LOG_FILE
StatusCheck $?

systemctl start user &>>$LOG_FILE
StatusCheck $?

systemctl enable user &>>$LOG_FILE
StatusCheck $?