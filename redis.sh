LOG_FILE=/tmp/catalogue
source common.sh

echo "set up Yum Repos for redis"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>LOG_FILE
StatusCheck $?

echo "Enabling Redis Yum Modules"
dnf module enable redis:remi-6.2 -y &>>LOG_FILE
StatusCheck $?

echo "Install Redis"
yum install redis -y &>>LOG_FILE
StatusCheck $?

echo "Updating Listren address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf /etc/redis/redis.conf
StatusCheck $?

systemctl enable redis

echo "set up Yum Repos for redis"
systemctl restart redis &>>LOG_FILE
StatusCheck $?