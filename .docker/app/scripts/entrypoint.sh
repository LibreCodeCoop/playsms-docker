#!/bin/bash
. `pwd`/../.env

# Set uid of host machine
usermod --non-unique --uid "${HOST_UID}" www-data
groupmod --non-unique --gid "${HOST_GID}" www-data

PHP_PATH=$(which php)

if [ ! -f "index.php" ]; then
    git clone --progress --single-branch --depth 1 --branch "${VERSION_PLAYSMS}" --recurse-submodules -j 4 https://github.com/playsms/playsms /tmp/playsms
    rsync -r /tmp/playsms/ ${PATHSRC}
    mkdir -p $PATHWEB $PATHLOG $PATHSRC $PATHBIN $PATHCONF $PATHLIB
    cp -rf $PATHSRC/web/* $PATHWEB
    cp -f $PATHWEB/config-env.php $PATHWEB/config.php

    cp $PATHSRC/daemon/linux/bin/playsmsd.php $PATHBIN/playsmsd
    chmod 700 $PATHBIN/playsmsd
    > $PATHCONF/playsmsd.conf
    echo "PLAYSMS_PATH=\"$PATHWEB\"" > $PATHCONF/playsmsd.conf
    echo "PLAYSMS_LIB=\"$PATHLIB\"" >> $PATHCONF/playsmsd.conf
    echo "PLAYSMS_BIN=\"$PATHBIN\"" >> $PATHCONF/playsmsd.conf
    echo "PLAYSMS_LOG=\"$PATHLOG\"" >> $PATHCONF/playsmsd.conf
    echo "DAEMON_SLEEP=\"1\"" >> $PATHCONF/playsmsd.conf
    echo "ERROR_REPORTING=\"E_ALL ^ (E_NOTICE | E_WARNING)\"" >> $PATHCONF/playsmsd.conf
    echo "* * * * * $PATHBIN/playsmsd $PATHCONF/playsmsd.conf start" > /var/spool/cron/crontabs/www-data

    composer --working-dir="$PATHSRC/" install

    > $PATHLOG/playsms.log >/dev/null 2>&1
    chmod 664 $PATHLOG/playsms.log >/dev/null 2>&1

    touch $PATHLOG/audit.log >/dev/null 2>&1
    chmod 664 $PATHLOG/audit.log >/dev/null 2>&1

    chown -R www-data: $PATHWEB $PATHLOG $PATHSRC $PATHBIN $PATHCONF $PATHLIB
    php /var/www/scripts/install.php
    echo "🥳 Setup completed !!!"
fi
export PLAYSMS_WEB="$PATHWEB"
sleep 5
runuser -u www-data -- php $PATHBIN/playsmsd $PATHCONF/playsmsd.conf check
runuser -u www-data -- php $PATHBIN/playsmsd $PATHCONF/playsmsd.conf restart
runuser -u www-data -- php $PATHBIN/playsmsd $PATHCONF/playsmsd.conf status

# Start PHP-FPM
if [[ "$HTTP_PORT" != 80 ]]; then
    echo "💜 playSMS is up! Access http://localhost:$HTTP_PORT"
else
    echo "💜 playSMS is up! Access http://localhost"
fi
php-fpm
