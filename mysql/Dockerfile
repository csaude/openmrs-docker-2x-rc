FROM mysql:8.4.1

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=openmrs_prod
ENV MYSQL_USER=sesp
ENV MYSQL_PASSWORD=sesp
ENV MYSQL_DATA_DIRECTORY=/var/lib/mysql

ADD mysql.cnf /root/.my.cnf
ADD localtime /etc/localtime
ADD openmrs.sql /openmrs.sql

RUN chmod 664 /root/.my.cnf

COPY run.sh /run.sh

EXPOSE 3306

CMD ["/run.sh"]
