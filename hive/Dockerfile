FROM sparkbase:latest

USER hadoop
WORKDIR /home/hadoop

RUN wget http://mirror.nohup.it/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz

RUN tar -zxf apache-hive-3.1.2-bin.tar.gz && \
    mv apache-hive-3.1.2-bin hive && rm *gz

COPY config/hive-site.xml /home/hadoop/hive/conf/
RUN rm /home/hadoop/hive/lib/guava-19.0.jar
COPY config/guava-27.0-jre.jar /home/hadoop/hive/lib/

COPY config/hive-setting.sh /home/hadoop/

USER root
ENV HADOOP_HOME /home/hadoop/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV PATH $PATH:$HADOOP_HOME/sbin
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV YARN_HOME ${HADOOP_HOME}
ENV HIVE_HOME /home/hadoop/hive
ENV PATH $PATH:$HIVE_HOME/bin

CMD service ssh start && sleep infinity
