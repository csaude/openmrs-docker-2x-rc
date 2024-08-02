FROM tomcat:9.0.91-jre11-temurin-focal

RUN mkdir -p /usr/local/tomcat/.OpenMRS

COPY openmrs-runtime.properties /usr/local/tomcat/openmrs-runtime.properties
ADD  setenv.sh /usr/local/tomcat/bin/setenv.sh
COPY localtime /etc/localtime

EXPOSE 8080
