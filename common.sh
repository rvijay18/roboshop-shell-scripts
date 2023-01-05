ID=$(id -u)
if [ $ID -ne 0 ]
then
  echo you need to run the script as a root user or use sudo privileges
  exit 1
fi

StatusCheck(){
  if [ $1 -eq 0 ]
  then
    echo -e Status = "\e[32mSuccess\e[0m"
  else
    echo -e Status = "\e[31mFailure\e[0m"
    exit 1
  fi
}

NODEJS {
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

  echo "Download ${COMPONENT} Application Code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
  StatusCheck $?

  cd /home/roboshop

  echo "clean old app content"
  rm -rf ${COMPONENT} &>>$LOG_FILE
  StatusCheck $?

  echo "Extract ${COMPONENT} Application Code"
  unzip /tmp/${COMPONENT}.zip &>>$LOG_FILE
  StatusCheck $?


  mv ${COMPONENT}-main ${COMPONENT}

  cd /home/roboshop/${COMPONENT}

  echo "Install Nodejs Dependencies"
  npm install &>>$LOG_FILE
  StatusCheck $?

  echo "Install Nodejs Dependencies"
  npm install &>>$LOG_FILE
  StatusCheck $?

  echo "Update SystemD Service File"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal' /home/roboshop/${COMPONENT}/systemd.service
  StatusCheck $?

  echo "setup ${COMPONENT} services"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG_FILE
  StatusCheck $?

  systemctl daemon-reload &>>$LOG_FILE
  StatusCheck $?

  systemctl start ${COMPONENT} &>>$LOG_FILE
  StatusCheck $?

  systemctl enable ${COMPONENT} &>>$LOG_FILE
  StatusCheck $?
}