#!/bin/bash
###########################################################
#                                                         #
#       =========================================         #
#       |       DNW Despe Networks              |         #
#       =========================================         #
#       |>>>>>>>> Murmur Startscript v4      >>>|         #
#       |>>>>>>>> http://www.despe.de >>>>>>>>>>|         #
#       |>>>>>>>> DO NOT EDIT, only if u know >>|         #
#       |>>>>>>>> what are you doing! >>>>>>>>>>|         #
#       =========================================         #
#                                                         #
###########################################################

###########################################################
# 			GT MURMUR PLUGIN                              #
# http://www.gametracker.com/downloads/gtmurmurplugin.php #
#                                                         #
###########################################################

#	Name der für das Script ausgeben wird
NAME="Mumble Server"

#	Name der für das Script ausgeben wird
NAME2="GameTracker-Query"

#	Userverzeichnis für Murmur
USERDIR="/home/mumble"

#	Arbeitsverzeichnis für Murmur
BASEDIR="/home/mumble/server"

#	Arbeitsverzeichnis für GameTracker-Query Murmur
BASEDIR2="/home/mumble/querytracker"

#	Das Startcommando für Murmur
COMMAND="murmur_server.x86"

#	Das Startcommando für  GameTracker-Query Murmur
COMMAND2="gtmurmur-static"


#	Die ini-Daten von murmur
INI=murmur.ini

#	Hier bewahrt das Script den Murmur-PID auf um später den Server wieder stoppen zu können
PIDFILE=murmur.pid

#	Hier bewahrt das Script den GameTracker-Query-PID auf um später den Server wieder stoppen zu können
PIDFILE2=gtmurmur-static.pid

#	Updateverzeichnis für Murmur
UPDATEDIR="/home/mumble/update"

#	Updateverzeichnis für Murmur
BACKUPDIR="/home/mumble/backup"

#	Wieviele Backups sollen aufgehoben werden
TAR=3

#	Zeitstempel
STAMP=`date +%d-%m-%Y_%H%M`

#########################################################################
# DONT EDIT BELOW THIS LINE!!! Broken Server is the reason !!!          #
#########################################################################

case "$1" in
	start)
		cd $BASEDIR
		if test -f $PIDFILE; then
			PID="`cat $PIDFILE`"
			echo ""
   			echo "  |  > PID-File vorhanden. Prozess-ID '$PID' . Server abgestürzt?"
			echo ""
		elif test $PIDFILE; then
			echo ""
			echo "  |  > Prozess-ID und PID-File nicht vorhanden, starte den $NAME"
			echo ""
			
			rm -f murmur.log
			touch murmur.log
			touch $PIDFILE
			chmod 750 $COMMAND
			./$COMMAND -ini $INI
			PID="`cat $PIDFILE`"
			echo ""
			echo "  |  > $NAME erfolgreich wieder hergestellt. Prozess-ID '$PID'"
			echo ""
	fi

;;

	stop)
		cd $BASEDIR
		if test -f $PIDFILE; then
			echo ""
			echo "  |  > Stoppe den $NAME"
			echo ""
			PID="`cat $PIDFILE`"
			kill $PID
			killall -9 $COMMAND
			echo ""
			echo "  |  > $NAME wurde beendet"
			echo ""
			rm -f $PIDFILE
			echo ""
			echo "  |  > $PIDFILE wurde entfernt"
			echo ""
			chmod 644 $COMMAND
		elif test $PIDFILE; then
			echo ""
			echo "  |  > Der $NAME läuft nicht."
			echo ""
	fi
;;

	restart)
		cd $BASEDIR
		PID="`cat $PIDFILE`"
		echo ""
		echo "  |  > $NAME '$PID' wird gestoppt ..."
		echo ""
		kill $PID
		killall -9 $COMMAND
   		rm -f $PIDFILE
		touch $PIDFILE
		chmod 750 $COMMAND
		cd $BASEDIR2
		PID="`cat $PIDFILE2`"
		echo ""
		echo "  |  > $NAME2 '$PID' wird gestoppt ..."
		echo ""
		kill $PID
		killall -9 $COMMAND2
		rm -f $PIDFILE2
		sleep 5
		cd $BASEDIR
		./$COMMAND -ini $INI
		PID="`cat $PIDFILE`"
		echo ""
		echo "  |  > $NAME erfolgreich wieder hergestellt. Prozess-ID '$PID'"
		echo ""
		cd $BASEDIR2
		nice -n 19 ./$COMMAND2 -conf $BASEDIR/$INI 2> /dev/null >&2 &
		ps -ef | grep $COMMAND2 | grep -v grep | awk ' { print $2 }' > $PIDFILE2
		PID="`cat $PIDFILE2`"
		echo ""
		echo "  |  > $NAME2 erfolgreich wieder hergestellt. Prozess-ID '$PID'"
		echo ""
;;


	querystart)
		cd $BASEDIR2
		if test -f $PIDFILE2; then
			PID="`cat $PIDFILE2`"
   			echo ""
			echo "  |  > PID-File vorhanden. Prozess-ID '$PID' . Server abgestürzt?"
			echo ""
		elif test $PIDFILE2; then
			echo ""
			echo "  |  > Prozess-ID und PID-File nicht vorhanden, starte den $NAME2"
			echo ""
			
			touch $PIDFILE2
			chmod 750 $COMMAND2
			nice -n 19 ./$COMMAND2 -conf $BASEDIR/$INI 2> /dev/null >&2 &
			ps -ef | grep $COMMAND2 | grep -v grep | awk ' { print $2 }' > $PIDFILE2
			PID="`cat $PIDFILE2`"
			echo ""
			echo "  |  > $NAME2 erfolgreich wieder hergestellt. Prozess-ID '$PID'"
			echo ""
	fi

;;

	querystop)
		cd $BASEDIR2
		if test -f $PIDFILE2; then
			echo ""
			echo "  |  > Stoppe den $NAME2"
			echo ""
			PID="`cat $PIDFILE2`"
			kill $PID
			killall -9 $COMMAND2
			echo ""
			echo "  |  > $NAME2 wurde beendet"
			echo ""
			rm -f $PIDFILE2
			echo ""
			echo "  |  > $PIDFILE2 wurde entfernt"
			echo ""
			chmod 644 $COMMAND2
		elif test $PIDFILE2; then
			echo ""
			echo "  |  > Der $NAME2 läuft nicht."
			echo ""
	fi
;;

	update)
		cd $BASEDIR
		PID="`cat $PIDFILE`"
		echo ""
		echo "  |  > $NAME '$PID' wird gestoppt ..."
		echo ""
		kill $PID
		killall -9 $COMMAND
   		rm -f $PIDFILE
		sleep 3
		echo ""
		echo "  |  > Backup wird erstellt ..."
		echo ""
		sleep 2
		cd $BACKUPDIR
		tar cfv $COMMAND.$STAMP.tar $BASEDIR
		sleep 3
		echo ""
		echo "  |  > Alte Backups werden gelöscht ..."
		echo ""
		ls -tr murmur_server* | head -n -$TAR | xargs rm -v
		sleep 3
		echo ""
		echo "  |  > Updateordner leeren..."
		echo ""
		rm -R $UPDATEDIR/*
		sleep 3
		echo ""
		echo "  |  > Update wird geholt, entpackt und eingespielt ..."
		echo ""
		sleep 3
		cd $UPDATEDIR
		wget --no-cookies --trust-server-names "http://natenom.name/r/getmumbleserver/dev/linux"
		tar xfvj murmur-static*.tar.bz2
		cd murmur-static*
		cp murmur.x86 $BASEDIR/$COMMAND
		cp ice/Murmur.ice $BASEDIR/ice/Murmur.ice
		sleep 3
		echo ""
		echo "  |  > Starte den $NAME"
		echo ""
		cd $BASEDIR
		rm -f murmur.log
		touch murmur.log
		touch $PIDFILE
		chmod 750 $COMMAND
		./$COMMAND -ini $INI
		PID="`cat $PIDFILE`"
		echo ""
		echo "  |  > $NAME erfolgreich wieder hergestellt. Prozess-ID '$PID'"
		echo ""
;;

	fullbackup)
		cd $BASEDIR
		PID="`cat $PIDFILE`"
		echo ""
		echo "  |  > $NAME '$PID' wird gestoppt ..."
		echo ""
		kill $PID
		killall -9 $COMMAND
   		rm -f $PIDFILE
		touch $PIDFILE
		chmod 750 $COMMAND
		cd $BASEDIR2
		PID="`cat $PIDFILE2`"
		echo ""
		echo "  |  > $NAME2 '$PID' wird gestoppt ..."
		echo ""
		kill $PID
		rm -f $PIDFILE2
		sleep 2
		echo ""
		echo "  |  > FullBackup wird erstellt ..."
		echo ""
		cd $USERDIR
		./backup.sh
		sleep 2
		cd $BASEDIR
		./$COMMAND -ini $INI
		PID="`cat $PIDFILE`"
		echo ""
		echo "  |  > $NAME erfolgreich wieder hergestellt. Prozess-ID '$PID'"
		echo ""
		cd $BASEDIR2
		nice -n 19 ./$COMMAND2 -conf $BASEDIR/$INI 2> /dev/null >&2 &
		ps -ef | grep $COMMAND2 | grep -v grep | awk ' { print $2 }' > $PIDFILE2
		PID="`cat $PIDFILE2`"
		echo ""
		echo "  |  > $NAME2 erfolgreich wieder hergestellt. Prozess-ID '$PID'"
		echo ""
		
;;

*)
	echo "Usage: $0 Parameter eingeben {start|stop|restart|querystart|querystop|update|fullbackup}"
	exit 1
;;
esac