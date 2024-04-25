#!/bin/sh
set -ex

# Verifica e cria diretório de dados se não existir
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
fi

if [ -d "$MYSQL_DATA_DIRECTORY" ]; then
    echo 'MySQL data directory exists'
else
    echo 'MySQL data directory does not exist'
    echo "Creating MySQL data directory: $MYSQL_DATA_DIRECTORY"
    mkdir -p "$MYSQL_DATA_DIRECTORY"
fi

if [ -d "$MYSQL_DATA_DIRECTORY/mysql" ]; then
    echo 'Data directory already initialized'
    echo 'Starting server'
    exec /usr/sbin/mysqld --user=mysql --console --datadir="$MYSQL_DATA_DIRECTORY" 

else
    echo 'Initializing database'
    mysqld --initialize --user=root --datadir="$MYSQL_DATA_DIRECTORY" > mysql_startup_log.txt 2>&1
    echo 'Database initialized'

    if grep -q 'A temporary password is generated for root@localhost:' mysql_startup_log.txt; then
        # Extrai a senha temporária do arquivo de log
        temp_password=$(grep 'A temporary password is generated for root@localhost:' mysql_startup_log.txt | awk '{print $NF}')
    else
        echo 'Senha temporária não encontrada no log de inicialização do MySQL'
    fi

    # Inicia o servidor MySQL
    echo 'Starting server'
    /usr/sbin/mysqld --user=mysql --datadir="$MYSQL_DATA_DIRECTORY" &

    # Espera até que o MySQL esteja pronto
    sleep 5

    mysql -hlocalhost -uroot -p"$temp_password" --connect-expired-password <<EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; 
    FLUSH PRIVILEGES;
EOF

    # Executa outros comandos SQL necessários
    mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
    USE mysql;
    CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
    CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
    CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
    CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;
    GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' WITH GRANT OPTION;
    GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOF
    
    # Importa os dados, se disponíveis
    if [ -f "openmrs.sql" ]; then
        echo "Importing data to $MYSQL_DATABASE database"
        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < openmrs.sql

    # Executa esses alter tables para resolver problemas identificados durante a migração da plataforma 2.3.3 para 2.6.1
    mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
    USE \`$MYSQL_DATABASE\`;
    alter table location modify date_created datetime not null;
    alter table patient_state modify date_created datetime not null;
    alter table patient_identifier modify date_created datetime not null;
    alter table orders modify date_created datetime not null;
    alter table reporting_report_design_resource modify date_created datetime not null;
    alter table users modify date_created datetime not null;
EOF
    fi
fi
