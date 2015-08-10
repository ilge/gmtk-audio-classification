case "$1" in    start)
    websocketd  --port=8085 ./offline_test.sh &
    websocketd  --port=8083 ./applause.sh &
    ;;
    stop)
    PIDS=`ps | grep -v grep | grep websocketd | awk '{print $1}'`
    for PID in $PIDS ; do
	kill -SIGTERM $PID
	echo "Stopped $PID ."
	done
        ;;
    reload|restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Usage: $0 start|stop|restart|reload"
        exit 1
esac
exit 0
