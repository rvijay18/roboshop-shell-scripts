LOG_FILE=/tmp/catalogue

echo "setup Nodejs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
echo status = $?

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
echo status = $?

echo "Add roboshop Application User"
useradd roboshop &>>$LOG_FILE
echo status = $?

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
echo status = $?

cd /home/roboshop

echo "Extract Catalogue Application Code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
echo status = $?

mv catalogue-main catalogue


cd /home/roboshop/catalogue

echo "Install Nodejs Dependencies"
npm install &>>$LOG_FILE
echo status = $?

echo "setup catalogue services"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
echo status = $?

systemctl daemon-reload &>>$LOG_FILE
echo status = $?

systemctl start catalogue &>>$LOG_FILE
echo status = $?

systemctl enable catalogue &>>$LOG_FILE
echo status = $?