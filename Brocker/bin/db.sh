sudo mysql -e "CREATE USER '$USER_NAME'@'localhost' IDENTIFIED BY '$DEPLOY_PASSWORD';"
sudo mysql -e "CREATE DATABASE ${USER_NAME}_db;"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${USER_NAME}_db.* TO '$USER_NAME'@'localhost';"