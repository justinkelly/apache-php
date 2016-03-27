#!/bin/bash
chown www-data:www-data /app -R

if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    a2enmod rewrite
fi

source /etc/apache2/envvars
/s3 --region "us-west-2" sync s3://invoice.im/${DOMAIN}/logo/ /app/templates/invoices/logos/
/s3 --region "us-west-2" sync s3://invoice.im/${DOMAIN}/template/ /app/templates/invoices/
mysql --host=${MYSQL_HOST} --port=${MYSQL_PORT} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} -e "CREATE DATABASE ${MYSQL_NAME}"
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
