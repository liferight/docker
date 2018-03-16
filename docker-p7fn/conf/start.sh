#!/bin/bash
set -m

PHP_PATH=/etc/php
PM_MAX_CHILDREN=5
PM_START_SERVER=3
PM_MIN_SPARE_SERVER=1
PM_MAX_SPARE_SERVER=3
PM_MAX_REQUESTS=1000

start_phpfpm()
{

    # 1 Edit php.ini:
    for i in $PHP_PATH/php.ini; do
        sed -i 's|max_execution_time = 30|max_execution_time = 120|' $i
        sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 64M|' $i
        sed -i 's|post_max_size = 8M|post_max_size = 64M|' $i
        sed -i 's|error_reporting = E_ALL & ~E_DEPRECATED|error_reporting =  E_ERROR|' $i
        sed -i 's|short_open_tag = Off|short_open_tag = On|' $i
        sed -i "s|;date.timezone =|date.timezone = 'Etc\/UTC'|" $i
    done
    
    # 2 Edit php-fpm.conf:
    for i in $PHP_PATH/php-fpm.conf; do
        sed -i "s|;log_level = notice|log_level = warning|" $i
        sed -i "s|;syslog.facility = daemon|syslog.facility = daemon|" $i
    done
    
    # 3 Remove php.conf
    rm -fr /etc/nginx/conf.d/php-fpm.conf
    rm -fr /etc/nginx/default.d/php.conf

    # 4 Create log directory
    mkdir -p /var/log/php-fpm
    
    # 5 Edit php-fpm.d/www.conf:
    for i in $PHP_PATH/php-fpm.d/www.conf; do
        sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9999|" $i
        sed -i "s|user = apache|user = nginx|" $i
        sed -i "s|group = apache|group = nginx|" $i
        sed -i "s|;listen.owner = apache|listen.owner = nginx|" $i
        sed -i "s|;listen.group = apache|listen.owner = nginx|" $i
        sed -i "s|;listen.mode = 0660|listen.mode = 0660|" $i
        sed -i "s|;listen.allowed_clients = 127.0.0.1|listen.allowed_clients = 127.0.0.1|" $i
        sed -i "s|;access.log = log/$pool.access.log|access.log = /var/log/php-fpm/access.log|" $i
        sed -i "s|;slowlog = log/$pool.log.slow|slowlog = /var/log/php-fpm/slow.log|" $i
        sed -i "s|;catch_workers_output = yes|catch_workers_output = yes|" $i
        sed -i "s|pm.max_children = 5|pm.max_children = ${PM_MAX_CHILDREN}|" $i
        sed -i "s|pm.start_servers = 2|pm.start_servers = ${PM_START_SERVER}|" $i
        sed -i "s|pm.min_spare_servers = 1|pm.min_spare_servers = ${PM_MIN_SPARE_SERVER}|" $i
        sed -i "s|pm.max_spare_servers = 3|pm.max_spare_servers = ${PM_MAX_SPARE_SERVER}|" $i
        sed -i "s|;pm.max_requests = 500|pm.max_requests = ${PM_MAX_REQUESTS}|" $i
        sed -i "s|php_admin_flag[log_errors] =.*|;php_admin_flag[log_errors] =|" $i
        sed -i "s|php_admin_value[error_log] =.*|;php_admin_value[error_log] =|" $i
        sed -i "s|php_admin_value[error_log] =.*|;php_admin_value[error_log] =|" $i
    done

    # 5. Send error to a file
    ln -sf /dev/stderr /var/log/php-fpm.error.log

    # 6. Run PHP-FPM
    DAEMON="php-fpm"
    EXEC=$(type -p $DAEMON)
    ARGS="--pid /var/run/php-fpm.pid"
    ${EXEC} ${ARGS}
}

start_nginx()
{
    # if nginx config file exists
    if [ -f /etc/nginx/conf.d/default.conf ]; then
        if [ -n "${VIRTUALHOST}" ]; then
            # Replace variables on config files:
            sed -i "s|    server_name localhost;|    server_name localhost ${VIRTUALHOST};|" /etc/nginx/conf.d/default.conf
            # Replace directory:
            #sed -i "s|    root ${DIR_VIRTUALHOST};|    root ${DIR_VIRTUALHOST}|" /etc/nginx/conf.d/default.conf
        fi
    fi

    # Run Nginx
    DAEMON="nginx"
    EXEC=$(type -p $DAEMON)
    ARGS="-c /etc/nginx/nginx.conf"
    exec ${EXEC} ${ARGS}
}

start_phpfpm
start_nginx