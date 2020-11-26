FROM res-drl-docker-local.artifactory.swg-devops.com/database-testing/sparkbase:latest

EXPOSE 10000

USER hadoop
WORKDIR /home/hadoop

ENV HIVE_VERSION=${HIVE_VERSION:-3.1.2}

RUN wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz && \
      tar -zxf apache-hive-$HIVE_VERSION-bin.tar.gz && \
      mv apache-hive-$HIVE_VERSION-bin hive && \
      rm *.gz

WORKDIR /home/hadoop

COPY config/hive-site.xml config/hive-env.sh /home/hadoop/hive/conf/

COPY config/hive-setting.sh /home/hadoop/
RUN rm /home/hadoop/.bashrc && \
  rm /home/hadoop/.profile
COPY config/shellrc /home/hadoop/.bashrc
COPY config/shellrc /home/hadoop/.profile

USER root
CMD service ssh start && sleep infinity
