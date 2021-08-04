FROM tomcat:8-jre8-alpine

RUN mkdir -p /usr/local/tomcat/.OpenMRS

ADD setenv.sh /usr/local/tomcat/bin/setenv.sh
COPY localtime /etc/localtime

EXPOSE 8080