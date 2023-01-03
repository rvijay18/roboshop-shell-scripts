LOG_FILE=/tmp/catalogue
echo "setup Nodejs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


echo "Add roboshop Application User"
useradd roboshop &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


cd /home/roboshop

echo "Extract Catalogue Application Code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


mv catalogue-main catalogue


cd /home/roboshop/catalogue

echo "Install Nodejs Dependencies"
npm install &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


echo "setup catalogue services"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


systemctl daemon-reload &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


systemctl start catalogue &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi


systemctl enable catalogue &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = Success
else
  echo Status = Failure
  exit
fi
