LOG_FILE=/tmp/frontend
source common.sh

echo installing nginx
yum install nginx -y &>>$LOG_FILE
StatusCheck $?

systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE

echo downloading ngimx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /usr/share/nginx/html &>>$LOG_FILE

echo removing web content
rm -rf * &>>$LOG_FILE
StatusCheck $?

echo extracting the web content
unzip /tmp/frontend.zip &>>$LOG_FILE
StatusCheck $?

mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo starting nginx service
systemctl restart nginx &>>$LOG_FILE
StatusCheck $?
