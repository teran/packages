#! /bin/sh

### BEGIN INIT INFO
# Provides:          php5-fcgi interface
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts instance of php5-fcgi
# Description:       starts instance of php5-fcgi using start-stop-daemon
### END INIT INFO

## ABSOLUTE path to the spawn-fcgi binary
SPAWNFCGI="/usr/bin/spawn-fcgi"

## ABSOLUTE path to the PHP binary
FCGIPROGRAM="/usr/bin/php-cgi"

## number of PHP childs to spawn
PHP_FCGI_CHILDREN=8

## number of request server by a single php-process until is will be restarted
PHP_FCGI_MAX_REQUESTS=1000

## IP adresses where PHP should access server connections from
FCGI_WEB_SERVER_ADDRS="127.0.0.1"

# allowed environment variables sperated by spaces
ALLOWED_ENV="PATH USER"

DAEMON="$SPAWNFCGI"
NAME=php5-fcgi
DESC=php5-fcgi
USER=www-data
GROUP=www-data
DAEMON_OPTS="-p 9000 -f $FCGIPROGRAM -u $USER -g $GROUP -C $PHP_FCGI_CHILDREN"

test -x $DAEMON || exit 0

set -e

. /lib/lsb/init-functions
case  "$1" in
  start)
	echo -n "Starting $DESC: "
	umask 022
	start-stop-daemon --start --make-pidfile --quiet --pidfile /var/run/$NAME.pid \
		--chuid "$USER" --exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
#	start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid --retry 10 \
#		--exec $DAEMON || true
	killall php-cgi || true
	echo "$NAME."
	;;
  restart)
	echo -n "Restarting $DESC: "
	#start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid --retry 10 \
	#	--exec $DAEMON || true
	killall php-cgi || true
	umask 022
	start-stop-daemon --start --make-pidfile --quiet --pidfile \
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
