# Docker Compose Configuration for OpenMRS 2.6.1 Deployment
-
Project can be used to either run an 2.6.1 instance or upgrade an 2.3.x instance (it uses the OpenMRS platform 2.6.1 war file). In order to launch/run, one is required to provide an sql dump of desired OpenMRS instance. When first run, the openmrs database will be created and then populated with the data from the provided sql dump. The subsequent run however, will skip this step.

## Steps to run
1. Place the SQL dump of the database which has to be named _openmrs.sql_ in _**mysql**_ directory.
2. While in the project's directory run the command `docker-compose up -d`.

**Note:** Don't forget to provide the required SQL dump file.

## Ensuring OpenMRS is started at boot time.
In Ubuntu 18.04 systemd is used to start openmrs via docker compose at boot time. See _systemd/README.md_ for details.
