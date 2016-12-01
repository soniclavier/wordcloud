#!/bin/bash

#variables
job_jar=/Users/vishnu/temp/wordcount/target/wordcount-1.0-SNAPSHOT.jar
flume_home=/Users/vishnu/apache-flume-1.6.0-bin
tweets_dir=/adbms/wordcloud/tweets/
mrinput_dir=/adbms/wordcloud/mrinput/
mroutput_dir=/adbms/wordcloud/mroutput
hive_table_dir=/user/hive/warehouse/tweets_count/
#directory for storing processed tweet files.
hist_dir=/adbms/wordcloud/hist/

#create required hdfs folder
hadoop fs -mkdir $mrinput_dir
hadoop fs -mkdir $hist_dir

#start flume.
####nohup $flume_home/bin/flume-ng agent -n agent -c $flume_home/conf -f $flume_home/conf/flume-conf.properties -Dflume.root.logger=INFO,console&
flume_pid=$!
echo "flume started with pid"=$flume_pid

#wait 10minutes
echo "sleeping for 10 minutes"
sleep 600
echo "wokeup"
echo "killing the flume process"
kill $flume_pid


#verify flume is killed
#if [ -n "$(ps -p $flume_pid -o pid=)" ]
	#wait for 5 seconds and check again
	#sleep 5s
	#if [ -n "$(ps -p $flume_pid -o pid=)" ]
		#echo "could not kill flume process, program exiting"
		#exit

#move flume result to a working dir, except .tmp files
echo "moving log files to working directory"
hadoop fs -mv $mrinput_dir*.log $hist_dir
wait
hadoop fs -mv $tweets_dir/*.log $mrinput_dir
wait

hadoop fs -rmr $mroutput_dir
hadoop jar $job_jar $mrinput_dir $mroutput_dir
hadoop_pid=$!
wait
name=$(($(date +%s)))
hadoop fs -mv $mroutput_dir/part* $hive_table_dir/$name
