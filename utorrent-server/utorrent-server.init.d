#! /bin/sh

### BEGIN INIT INFO
# Provides:          utorrent-server
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts instance of utorrent-server
# Description:       starts instance of utorrent-server using start-stop-daemon
### END INIT INFO

DAEMON=/usr/sbin/utserver
NAME=utserver
DESC=utserver
DAEMON_OPTS='-configfile /etc/utorrent-server/utorrent-server.conf -logfile /var/log/utorrent-server/utserver.log -settingspath /etc/utorrent-server -daemon -pidfile /var/run/utserver.pid'
USER=utorrent
GROUP=utorrent

test -x $DAEMON || exit 0

if [ ! -f /var/run/utserver.pid ]
then
	touch /var/run/utserver.pid
fi

if [ -f /var/run/utserver.pid ]
then
	chown $USER:$GROUP /var/run/utserver.pid
fi

set -e

. /lib/lsb/init-functions

rotate() {
        if [ -f '/var/log/utorrent-server/utserver.log' ]
        then
                date=`date +'%H%M%S%d%m%Y'`
                mv /var/log/utorrent-server/utserver.log /var/log/utorrent-server/utserver.log-$date
                gzip -9 /var/log/utorrent-server/utserver.log-$date
        fi

	if [ ! -f '/var/log/utorrent-server/utserver.log' ]
	then
                touch /var/log/utorrent-server/utserver.log
                chown utorrent.utorrent /var/log/utorrent-server/utserver.log
	fi
}

case "$1" in
  start)
	echo -n "Starting $DESC: "
	rotate
	umask 022
	start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid \
		--chuid "$USER" --exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid --retry 10 \
		--exec $DAEMON || true
	echo "$NAME."
	;;
  restart)
	echo -n "Restarting $DESC: "
	rotate
	start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid --retry 10 \
		--exec $DAEMON || true
	umask 022
	start-stop-daemon --start --quiet --pidfile \
		/var/run/$NAME.pid --chuid "$USER" --exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  status)
	status_of_proc -p /var/run/$NAME.pid "$DAEMON" "$NAME" && exit 0 || exit $?
	;;
  *)
	echo "Usage: $NAME {start|stop|restart|status}" >&2
	exit 1
	;;
esac

exit 0

