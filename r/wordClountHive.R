#some useful commands

#DYLD_PRINT_LIBRARIES=1 R 
#sudo ln -f -s $(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib /usr/local/lib

#jvm=`ls /Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home/jre/lib/server/libjvm.dylib`
#sudo install_name_tool -id "$jvm" "$jvm"

#options("java.home"="/Librar/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home/")
#install.packages('rJava', type='source')
#dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home/jre/lib/server/libjvm.dylib", FALSE)

#alias rstudio="DYLD_FALLBACK_LIBRARY_PATH=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home/jre/lib/server/: open -a RStudio"

cp = c("/Users/vishnu/apache-hive-1.2.1-bin/lib/hive-jdbc-1.2.1.jar","/Users/vishnu/apache-hive-1.2.1-bin/lib/libthrift-0.9.2.jar","/Users/vishnu/apache-hive-1.2.1-bin/lib/hive-service-1.2.1.jar","/Users/vishnu/apache-hive-1.2.1-bin/lib/httpclient-4.4.jar","/Users/vishnu/apache-hive-1.2.1-bin/lib/httpcore-4.4.jar","/Users/vishnu/apache-hive-1.2.1-bin/lib/hive-jdbc-1.2.1-standalone.jar","/Users/vishnu/hadoop-2.6.0/share/hadoop/common/hadoop-common-2.6.0.jar") 

library(rJava)
.jinit(classpath=cp)

#check java version is 1.8
.jcall("java/lang/System", "S", "getProperty", "java.runtime.version")

drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/Users/vishnu/apache-hive-1.2.1-bin/lib/hive-jdbc-1.2.1.jar", identifier.quote="`")

#connect using default username and password
hivecon <- dbConnect(drv, "jdbc:hive2://localhost:10000/default")

query = "select * from tweets_count"
res <- dbGetQuery(hivecon, query)

wordcloud(words = res$tweets_count.word, freq = res$tweets_count.word_count, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))