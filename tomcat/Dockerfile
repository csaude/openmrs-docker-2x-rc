FROM tomcat:8-jre8-temurin

RUN mkdir -p /usr/local/tomcat/.OpenMRS

COPY openmrs-runtime.properties /usr/local/tomcat/openmrs-runtime.properties
ADD  setenv.sh /usr/local/tomcat/bin/setenv.sh
COPY localtime /etc/localtime

EXPOSE 8080
