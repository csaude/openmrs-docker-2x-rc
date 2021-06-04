# Configuring OpenMRS to Start at Boot Time
-
This is done by calling the docker-compose at boot time. This ensures the order and dependencies are properly maintained.

## Steps.
These instructions are meant for Ubuntu 18.04

1. Copy the provided _openmrs.service_ to `/etc/systemd/system/`.
2. Replace the _\<path-to-project-directory>_ with the correct path. That is the directory path of the docker compose project.
3. Run the command `systemctl enable openmrs.service` (use `sudo` if necessary) to enable boot time starting up via systemd.
4. Reboot the system to test.

**Note:** The systemd relies on the containers already being available because it uses the `docker-compose start` command, therefore one need to ensure the containers have already been created. Creation of containers happens the first time when `docker-compose up -d` is run. 
