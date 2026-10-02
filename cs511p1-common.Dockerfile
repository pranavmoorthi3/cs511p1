####################################################################################
# DO NOT MODIFY THE BELOW ##########################################################

FROM eclipse-temurin:8-jdk-jammy

RUN apt update && \
    apt upgrade --yes && \
    apt install ssh openssh-server python3 --yes

COPY resources/configure-heartbeats.py /configure-heartbeats.py

# Setup common SSH key.
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/shared_rsa -C common && \
    cat ~/.ssh/shared_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# DO NOT MODIFY THE ABOVE ##########################################################
####################################################################################

# Setup HDFS/Spark resources here
# (the PySpark skeleton of Part 3 also needs python3 on every node; Spark 3.4.1
#  supports Python 3.7-3.11, so do not install a newer interpreter)
RUN apt update && apt install --yes curl

ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}"

RUN curl -fsSL "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
        -o /tmp/hadoop.tar.gz && \
    tar -xzf /tmp/hadoop.tar.gz -C /opt && \
    mv "/opt/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}" && \
    rm /tmp/hadoop.tar.gz

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> "${HADOOP_HOME}/etc/hadoop/hadoop-env.sh"

COPY resources/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site.xml
COPY resources/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml

ENV SPARK_VERSION=3.4.1
ENV SPARK_HOME=/opt/spark
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"
ENV PYSPARK_PYTHON=python3

RUN curl -fsSL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz" \
        -o /tmp/spark.tgz && \
    tar -xzf /tmp/spark.tgz -C /opt && \
    mv "/opt/spark-${SPARK_VERSION}-bin-hadoop3" "${SPARK_HOME}" && \
    rm /tmp/spark.tgz

COPY resources/spark-env.sh      ${SPARK_HOME}/conf/spark-env.sh
COPY resources/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf