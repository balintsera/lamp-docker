FROM phpmentors/php-app


RUN apt-get update
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes mysql-client-5.5 mysql-server-5.5
RUN yes O | apt-get install -y php5-mcrypt
RUN php5enmod mcrypt
RUN apt-get install mysql-client 

RUN a2enmod rewrite


VOLUME /var/lib/mysql
VOLUME /var/www/

WORKDIR /opt


EXPOSE 3306

RUN echo '
$ TARGET_GID=$(stat -c "%g" /volume/FOOBAR)
EXISTS=$(cat /etc/group | grep $TARGET_GID | wc -l)

  # Create new group using target GID and add nobody user
  if [ $EXISTS == "0" ]; then
    groupadd -g $TARGET_GID tempgroup
    usermod -a -G tempgroup nobody
  else
    # GID exists, find group name and add
    GROUP=$(getent group $TARGET_GID | cut -d: -f1)
    usermod -a -G $GROUP nobody
  fi
 ' >  /opt/perms.sh
 
RUN chmod ugo+x /opt/perms.sh
RUN /opt/perms.sh 

RUN echo 'apache2ctl start && mysqld' > /opt/start.sh && chmod ugo+x /opt/start.sh

CMD /opt/start.sh