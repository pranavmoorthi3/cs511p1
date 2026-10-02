#!/bin/bash
export JAVA_HOME=/opt/java/openjdk

####################################################################################
# DO NOT MODIFY THE BELOW ##########################################################

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# DO NOT MODIFY THE ABOVE ##########################################################
####################################################################################

# Setup HDFS/Spark main here
export HADOOP_HOME=/opt/hadoop
export PATH="$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH"

mkdir -p /opt/hadoop/data/nameNode /opt/hadoop/data/dataNode

cat > "$HADOOP_HOME/etc/hadoop/workers" << 'EOF'
main
worker1
worker2
EOF