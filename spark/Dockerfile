FROM res-drl-docker-local.artifactory.swg-devops.com/database-testing/scalabase:latest

EXPOSE 8081
EXPOSE 8080
EXPOSE 8088
EXPOSE 7077
EXPOSE 9870
EXPOSE 4040

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

USER hadoop

RUN wget http://archive.apache.org/dist/hadoop/core/hadoop-3.2.1/hadoop-3.2.1.tar.gz && \
      tar -zxf hadoop-3.2.1.tar.gz && \
      mv hadoop-3.2.1 hadoop && \
      wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz && \
      tar -zxf spark-2.4.0-bin-without-hadoop.tgz && \
      mv spark-2.4.0-bin-without-hadoop spark && \
      rm *gz

RUN mkdir -p /home/hadoop/.ssh /home/hadoop/hadoop/logs \
    touch /home/hadoop/hadoop/logs/fairscheduler-statedump.log

COPY config/shellrc /home/hadoop/.bashrc
COPY config/shellrc /home/hadoop/.profile
COPY config/id_rsa* /home/hadoop/.ssh/
COPY config/id_rsa.pub  /home/hadoop/.ssh/authorized_keys
COPY config/sparkcmd.sh config/hadoop-env.sh /home/hadoop/

COPY config/core-site.xml config/hdfs-site.xml config/mapred-site.xml \
    config/yarn-site.xml /home/hadoop/hadoop/etc/hadoop/


RUN cat /home/hadoop/hadoop-env.sh >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh

USER root
RUN chmod -R 600 /home/hadoop/.ssh
RUN chown -R hadoop /home/hadoop

#ENTRYPOINT ["/home/hadoop/sparkcmd.sh","start"]
CMD service ssh start && sleep infinity
