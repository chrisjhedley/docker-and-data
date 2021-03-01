FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get -y install software-properties-common

# PYTHON
RUN apt-get install python3
RUN apt -y install python3-pip

# JUPYTER
RUN pip3 install jupyter
RUN pip3 install pyspark==2.3.1

# JAVA
RUN echo Y | apt install default-jre

# SCALA
RUN apt-get install wget
RUN wget www.scala-lang.org/files/archive/scala-2.11.12.deb
RUN dpkg -i scala-2.11.12.deb
RUN echo Y | apt-get install scala

# SPARK
ARG SPARK_ARCHIVE=http://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz
ENV SPARK_HOME /usr/local/spark-2.3.1-bin-hadoop2.7

RUN curl -s ${SPARK_ARCHIVE} | tar -xz -C /usr/local/

WORKDIR $SPARK_HOME

ENV PYTHONPATH $SPARK_HOME/python:/usr/bin/python
ENV PYSPARK_DRIVER_PYTHON "jupyter"
ENV PYSPARK_DRIVER_PYTHON_OPTS "notebook"
ENV PYSPARK_PYTHON python3

#ENV PATH ${PATH}:${SPARK_HOME}:~/.local/bin:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin:${SPARK_HOME}/bin
ENV PATH ${PATH}:${SPARK_HOME}:~/.local/bin:${SPARK_HOME}/bin

# N.B. --allow-root is not recommended
#RUN jupyter notebook --ip 0.0.0.0 --allow-root