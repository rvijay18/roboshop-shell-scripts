LOG_FILE=/tmp/catalogue

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

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>$LOG_FILE
StatusCheck $?

echo "Extract Catalogue Application Code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
StatusCheck $?


mv catalogue-main catalogue

cd /home/roboshop/catalogue

echo "Install Nodejs Dependencies"
npm install &>>$LOG_FILE
StatusCheck $?

echo "setup catalogue services"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
StatusCheck $?

systemctl daemon-reload &>>$LOG_FILE
StatusCheck $?

systemctl start catalogue &>>$LOG_FILE
StatusCheck $?

systemctl enable catalogue &>>$LOG_FILE
StatusCheck $?