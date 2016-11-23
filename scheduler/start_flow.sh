#!/bin/bash

#start flume
nohup /Users/vishnu/apache-flume-1.6.0-bin/bin/flume-ng agent -n TwitterAgent -c /Users/vishnu/apache-flume-1.6.0-bin/conf -f /Users/vishnu/apache-flume-1.6.0-bin/conf/twitter-conf.properties -Dflume.root.logger=INFO,console&
flume_pid=$!
echo flume_pid=$flume_pid

#wait 15minutes
sleep 15m

#kill flume
kill -9 $flume_pid

#verify flume is killed
if [ -n "$(ps -p $flume_pid -o pid=)" ]
	#wait for 5 seconds and check again
	sleep 5s
	if [ -n "$(ps -p $flume_pid -o pid=)" ]
		echo "could not kill flume process, program exiting"
		exit

#move flume result to a working dir, except .tmp files
hadoop fs -mv /adbms/wordcloud/tweets/*.log /adbms/wordcloud/mrinput/
wait

nohup hadoop jar examples-1.0-SNAPSHOT.jar WordCount /adbms/wordcloud/mrinput/ /adbms/wordcloud/hive_external_table &
hadoop_pid =$!
echo hadoop_job_pid=$hadoop_pid