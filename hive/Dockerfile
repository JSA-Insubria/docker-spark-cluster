FROM sparkbase:latest

USER hadoop
WORKDIR /home/hadoop

ENV HIVE_VERSION=${HIVE_VERSION:-3.1.2}

#For Test
#ENV HIVE_VERSION=${HIVE_VERSION:-4.0.0-SNAPSHOT} 

RUN wget http://mirror.nohup.it/apache/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz

#For Test
#COPY config/apache-hive-4.0.0-SNAPSHOT-bin.tar.gz /home/hadoop/apache-hive-4.0.0-SNAPSHOT-bin.tar.gz

RUN tar -zxf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin hive && rm *gz

COPY config/hive-site.xml /home/hadoop/hive/conf/
RUN rm /home/hadoop/hive/lib/guava-19.0.jar
COPY config/guava-27.0-jre.jar /home/hadoop/hive/lib/

COPY config/hive-setting.sh /home/hadoop/
RUN rm /home/hadoop/.bashrc
RUN rm /home/hadoop/.profile
COPY config/shellrc /home/hadoop/.bashrc
COPY config/shellrc /home/hadoop/.profile

USER root
CMD service ssh start && sleep infinity
