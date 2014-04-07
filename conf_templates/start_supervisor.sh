#! /bin/bash

NAME=supervisord
SUPERVISORD=%(virtualenv)s/bin/supervisord
SUPERVISORCTL=%(virtualenv)s/bin/supervisorctl
PIDFILE=/home/%(user)s/.%(app_name)s_supervisord.pid
OPTS="-c %(conf_dir)s/supervisord.conf"
PS=$NAME
TRUE=1
FALSE=0

test -x $SUPERVISORD || exit 0

export PATH="${PATH:+$PATH:}/usr/local/bin:/usr/sbin:/sbin:/home/%(user)s/bin:%(virtualenv)s/bin:"

isRunning(){
    pidof_daemon
    PID=$?

    if [ $PID -gt 0 ]; then
	return 1
    else
        return 0
    fi
}

pidof_daemon() {
    PIDS=`pidof -x $PS` || true

    [ -e $PIDFILE ] && PIDS2=`cat $PIDFILE`

    for i in $PIDS; do
        if [ "$i" = "$PIDS2" ]; then
            return 1
        fi
    done
    return 0
}

start () {
    echo "Starting Supervisor daemon manager..."
    isRunning
    isAlive=$?

    if [ "${isAlive}" -eq $TRUE ]; then
        echo "Supervisor is already running."
    else
        $SUPERVISORD $OPTS || echo "Failed...!"
        echo "OK"
    fi
}

stop () {
    echo "Stopping Supervisor daemon manager..."
    $SUPERVISORCTL $OPTS shutdown ||  echo "Failed...!"
    isRunning
    isAlive=$?
    while [ "${isAlive}" -eq $TRUE ]
    do
        echo "Shutting down"
        sleep 2
        isRunning
        isAlive=$?
    done

    echo "OK"
}

case "$1" in
  start)
    start
	;;

  stop)
    stop
	;;

  restart|reload|force-reload)
    stop
    start
    ;;

esac

exit 0
