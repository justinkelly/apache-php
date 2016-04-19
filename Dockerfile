FROM ubuntu:trusty
MAINTAINER Justin Kelly <justin@kelly.org.au>

# Install base packages
RUN apt-get -yq install software-properties-common 
RUN add-apt-repository -y ppa:sergey-dryabzhinsky/php52 > /dev/null 2>&1

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        exim4-base \
        apache2 \
        libapache2-mod-php52 \
        php52-common \
        php52-cli \
        php52-mod-mysql \
        php52-mod-mcrypt \
        php52-mod-gd \
        php52-mod-xsl \
        php52-mod-curl \
        php52-pear && \
    rm -rf /var/lib/apt/lists/* 

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s|\("MaxSpareServers" * *\).*|\12|" /etc/apache2/apache2.conf

#Apache start issues 
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR


ENV ALLOW_OVERRIDE **False**
ENV SI_AUTH="SI_AUTH"
ENV DB_HOST="DB_HOST"
ENV DB_NAME="DB_NAME"
ENV DB_PASS="DB_PASS"
ENV DB_PORT="3306"
ENV DB_USER="DB_USER"
ENV VIRTUAL_HOST="VIRTUAL_HOST"
ENV DOMAIN="DOMAIN"
ENV AWS_REGION="AWS_REGION"
ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID"
ENV AWS_SECRET_ACCESS_KEY="AWS_SECRET_ACCESS_KEY"
ENV SMTP_HOST="SMTP_HOST"
ENV SMTP_PASS="SMTP_PASS"
ENV SMTP_USER="SMTP_USER"
ENV SMTP_PORT="SMTP_POST"
ENV SMTP_SECURE="SMTP_SECURE"

# Add image configuration and scripts
ADD s3 /s3
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#add folders
ADD simpleinvoices/ /app
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf

#VOLUME "/data/invoice:/app"

EXPOSE 80 443
WORKDIR /app
CMD ["/run.sh"]
