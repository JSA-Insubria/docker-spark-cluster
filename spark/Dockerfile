#FROM res-drl-docker-local.artifactory.swg-devops.com/database-testing/scalabase:latest
FROM scalabase:latest

EXPOSE 8081
EXPOSE 8080
EXPOSE 8088
EXPOSE 7077
EXPOSE 9870
EXPOSE 4040

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

USER hadoop
#RUN  wget https://storage.googleapis.com/staging.cloudproject-feffa.appspot.com/hadoop-3.2.1.tar.gz
COPY config/hadoop-3.2.1.tar.gz /home/hadoop/hadoop-3.2.1.tar.gz

#RUN  wget https://storage.googleapis.com/staging.cloudproject-feffa.appspot.com/spark-2.4.0-bin-without-hadoop.tgz
COPY config/spark-2.4.0-bin-without-hadoop.tgz /home/hadoop/spark-2.4.0-bin-without-hadoop.tgz

RUN tar -zxf hadoop-3.2.1.tar.gz && \
    mv hadoop-3.2.1 hadoop && \
    tar -zxf spark-2.4.0-bin-without-hadoop.tgz && \
    mv spark-2.4.0-bin-without-hadoop spark &&  rm *gz

RUN mkdir -p /home/hadoop/.ssh /home/hadoop/hadoop/logs \
    /home/hadoop/data/nameNode /home/hadoop/data/dataNode \
    /home/hadoop/data/namesecondary /home/hadoop/data/tmp && \
    touch /home/hadoop/hadoop/logs/fairscheduler-statedump.log

# We don't care about the skeleton rc files, so overwrite
COPY config/shellrc /home/hadoop/.bashrc
COPY config/shellrc /home/hadoop/.profile
COPY config/id_rsa* /home/hadoop/.ssh/
COPY config/id_rsa.pub  /home/hadoop/.ssh/authorized_keys
#COPY config/workers /home/hadoop/spark/conf/slaves
COPY config/sparkcmd.sh /home/hadoop/
COPY config/hadoop-env.sh /home/hadoop/

#COPY config/core-site.xml config/hdfs-site.xml config/mapred-site.xml \
#    config/yarn-site.xml config/workers /home/hadoop/hadoop/etc/hadoop/

USER hadoop
#RUN cat /home/hadoop/hadoop-env.sh >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh

USER root
RUN chown -R hadoop /home/hadoop/.ssh /home/hadoop/.bashrc /home/hadoop/.profile \
    /home/hadoop/data /home/hadoop/hadoop-env.sh
    
RUN chmod 400 /home/hadoop/.ssh/authorized_keys
#ENTRYPOINT ["/home/hadoop/sparkcmd.sh","start"]
CMD service ssh start && sleep infinity
