# zookeeper 安装

## 准备

[zookeeper 安装包](https://zookeeper.apache.org/)

java 环境

## 安装

1. 解压到 /opt/modules/

   ```shell
   $ tar -zxvf zookeeper.tar.gz -C /opt/modules/
   ```

2. 修改文件夹名称和配置文件名称

   ```shell
   $ cd /opt/modules
   $ mv zookeeper-3.4.14/ zk
   $ cd zk/conf
   $ mv zoo_sample.cfg zoo.cfg
   ```

3. 修改配置文件

   ```shell
   # The number of milliseconds of each tick
   tickTime=2000
   # The number of ticks that the initial
   # synchronization phase can take
   initLimit=10
   # The number of ticks that can pass between
   # sending a request and getting an acknowledgement
   syncLimit=5
   # the directory where the snapshot is stored.
   # do not use /tmp for storage, /tmp here is just
   # example sakes.
   dataDir=/opt/modules/zk/data
   # the port at which the clients will connect
   clientPort=2181
   # the maximum number of client connections.
   # increase this if you need to handle more clients
   #maxClientCnxns=60
   #
   # Be sure to read the maintenance section of the
   # administrator guide before turning on autopurge.
   #
   # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
   #
   # The number of snapshots to retain in dataDir
   #autopurge.snapRetainCount=3
   # Purge task interval in hours
   # Set to "0" to disable auto purge feature
   #autopurge.purgeInterval=1
   
   
   server.1=172.16.235.166:2888:3888
   server.2=172.16.235.167:2888:3888
   server.3=172.16.235.168:2888:3888
   ```

4. 在dataDir目录下创建 myid 并标记相应 server.id

   ```shell
   $ cd /opt/modules/zk/
   $ mkdir data 
   $ cd data
   $ vim myid
   1
   ```

5. 其他服务器相同操作或直接同步

6. 分别启动每个服务器中的 zk

   ```shell
   $ cd /opt/modules/zk/bin
   $ ./zkServer.sh start
   $ ./zkServer.sh stop
   $ ./zkServer.sh restart
   $ ./zkServer.sh status
   ```

7. 查看节点状态

   ```shell
   [root@localhost bin]# ./zkServer.sh status
   ZooKeeper JMX enabled by default
   Using config: /opt/modules/zk/bin/../conf/zoo.cfg
   Mode: leader
   ```

   