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
RUN rm /home/hadoop/.bashrc
RUN rm /home/hadoop/.profile
COPY config/shellrc /home/hadoop/.bashrc
COPY config/shellrc /home/hadoop/.profile

USER root
CMD service ssh start && sleep infinity
