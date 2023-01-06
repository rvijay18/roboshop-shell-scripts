COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
StatusCheck $?

echo "Install Erland & RabbitMQ"
yum install erlang -y &>>$LOG_FILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
yum install rabbitmq-server -y &>>$LOG_FILE
StatusCheck $?

echo "Start RabbitMQ Server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl restart rabbitmq-server &>>$LOG_FILE
StatusCheck $?

rabbitmqctl  list_users | grep roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
  echo "Add Application USer in RabbitMQ"
  rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
  StatusCheck $?
fi

echo "Add Application USer tags in RabbitMQ"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
StatusCheck $?

echo "Add permissions for App User in RabbitMQ"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOG_FILE
StatusCheck $?