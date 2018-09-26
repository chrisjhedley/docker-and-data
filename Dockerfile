FROM ubuntu:14.04

RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get -y install software-properties-common

# JAVA
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin

# PYTHON
RUN apt-get install python3

# SCALA
RUN apt-get install wget
RUN wget www.scala-lang.org/files/archive/scala-2.11.12.deb
RUN dpkg -i scala-2.11.12.deb
RUN echo Y | apt-get install scala

# SPARK
ARG SPARK_ARCHIVE=http://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz
ENV SPARK_HOME /usr/local/spark-2.3.1-bin-hadoop2.7

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -s ${SPARK_ARCHIVE} | tar -xz -C /usr/local/

WORKDIR $SPARK_HOME

# PYSPARK
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN pip3 install pyspark==2.3.1

# SPARK GRAPHFRAMES
RUN wget https://dl.bintray.com/spark-packages/maven/graphframes/graphframes/0.6.0-spark2.3-s_2.11/graphframes-0.6.0-spark2.3-s_2.11.jar
RUN mv graphframes-0.6.0-spark2.3-s_2.11.jar ${SPARK_HOME}/jars

# COPY OVER EXAMPLE FILES
RUN mkdir -p data/examples
COPY people.csv /data/examples/people.csv
COPY relationships.csv /data/examples/relationships.csv

RUN mkdir -p packages
RUN mkdir -p /etc/spark/conf

COPY graphframes.zip /packages/graphframes.zip
COPY spark-env.sh /etc/spark/conf/spark-env.sh

# SCALA LOGGING JARS
RUN wget http://central.maven.org/maven2/com/typesafe/scala-logging/scala-logging_2.11/3.9.0/scala-logging_2.11-3.9.0.jar
RUN wget http://central.maven.org/maven2/com/typesafe/scala-logging/scala-logging-slf4j_2.11/2.1.2/scala-logging-slf4j_2.11-2.1.2.jar
RUN wget http://central.maven.org/maven2/com/typesafe/scala-logging/scala-logging-api_2.11/2.1.2/scala-logging-api_2.11-2.1.2.jar

RUN mv scala-logging_2.11-3.9.0.jar ${SPARK_HOME}/jars
RUN mv scala-logging-slf4j_2.11-2.1.2.jar ${SPARK_HOME}/jars
RUN mv scala-logging-api_2.11-2.1.2.jar ${SPARK_HOME}/jars

# DATA FOR TUTORIAL AT:
# https://docs.databricks.com/spark/latest/graph-analysis/graphframes/graph-analysis-tutorial.html#build-the-graph

RUN wget https://github.com/udacity/data-analyst/raw/master/projects/bike_sharing/201508_trip_data.csv
RUN wget https://github.com/udacity/data-analyst/raw/master/projects/bike_sharing/201508_station_data.csv
RUN mv 201508_trip_data.csv /data/examples/
RUN mv 201508_station_data.csv /data/examples/