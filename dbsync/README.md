# Introduction
This project hold the necessary stuffs for eip application installation using a docker container. The eip application run in a container called openmrs-eip-sender. The container has the ability to pickup updates for eip application. The new releases (routes, jar, scripts, etc) must be put in [release_stuff](./release_stuff) directory. The release update mechanism check the information in [release_info.sh](./release_stuff/scripts/release_info.sh) script. So, every time there is a new release the information in this script must be updated so that the remote computer can see the new releases. The eip container share the VOLUME with the host matchine in folder ./shared. This folder hold important things such as logs, debezium offset file, backups, etc. The container is shipped with backup mecanism which performe backups of eip mgt database and debezium offset files. The backup are persisted in shared folder under ./shared/bkps.

If you wish to send some maintenance commands to the remote sites, you can always ship the new releases with scripts included in [after_ugrade](release_stuff/scripts/after_upgrade/) folder. These scripts will be picked-up after the apgrade and run in the container. Scripts in this directory will be run once within the container.  


## Create eip.env property file

#### Copy the [./eip.template.env](eip.template.env) file to ./eip.env using the command

```
cp eip.template.env eip.env
```

Edit the env in the file copied above putting the correct values for the env variables 

```
db_sync_senderId=SENDER_ID
server_port=SERVER_PORT
openmrs_db_host=OPENMRS_DB_HOST
openmrs_db_port=OPENMRS_DB_PORT
openmrs_db_name=OPENMRS_DB_NAME
spring_openmrs_datasource_password=OPENMRS_DB_USER
spring_artemis_user=ACTIVE_MQ_USER
spring_artemis_password=ACTIVE_MQ_PASSWORD
origin_app_location_code=ORIGIN_APP_LOCATION_CODE
spring_artemis_host=ACTIVE_MQ_HOST
spring_artemis_port=ACTIVE_MQ_PORT
dbsync_notification_email_recipients=NOTIFICATION_EMAL_RECIPIENTS
eip_user=DBSYNC_CONSOLE_USER_NAME
eip_pass=DBSYNC_CONSOLE_USER_PASSWORD
```

The SENDER_ID codes will be provided by the central team.