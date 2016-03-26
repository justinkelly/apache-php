FROM ubuntu:precise
MAINTAINER Justin Kelly <justin@kelly.org.au>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-xsl \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

ENV ALLOW_OVERRIDE **False**
ENV DB_HOST="DB_HOST"
ENV DB_NAME="DB_NAME"
ENV DB_PASS="DB_PASS"
ENV DB_PORT="3306"
ENV DB_USER="DB_USER"
ENV VIRTUAL_HOST="VIRTUAL_HOST"
ENV DOMAIN="DOMAIN"
ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID"
ENV AWS_SECRET_ACCESS_KEY="AWS_SECRET_ACCESS_KEY"

# Add image configuration and scripts
ADD s3
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www && ln -s /app /var/www
#ADD sample/ /app
ADD simpleinvoices/ /app

#VOLUME "/data/invoice:/app"

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
