#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
yum install -y jq
az=$(curl --silent
http://169.254.169.254/latest/dynamic/instance-
identity/document| jq .availabilityZone)
cat <<EOF > /var/www/html/index.html
<html> <body>Hey!! This is YOUR_NAME in AZ :)!
</body> </html>
EOF
sed -i "s/AZ/$az/g" /var/www/html/index.html
