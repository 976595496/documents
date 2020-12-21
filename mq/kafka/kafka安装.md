#kafka安装

准备: zookeeper 环境, [kafka 安装包]([http://kafka.apache.org/downloads](http://kafka.apache.org/downloads))



## 集群安装

1. 解压到指定目录

   ```shell
   $ tar -zxvf kafka_2.12-0.11.0.3.tgz -C /opt/modules/
   $ cd /opt/modules
   $ mv kafka_2.12-0.11.0.3 kafka
   ```

2. 修改配置文件

   ```shell
   $ cd kafka/conf
   $ vim server.properties
   ```

   ```properties
   # broker 全局唯一标志, int 值 不可重复
   broker.id=0
   # 是否可删除 topic
   delete.topic.enable=true
   # kafka 端口
   listeners=PLAINTEXT://172.16.235.166:9092
   
   # 处理网络请求的线程数量
   num.network.threads=3
   # 处理磁盘 I/O 的线程数量
   num.io.threads=8
   # socket 发送缓冲区打小
   socket.send.buffer.bytes=102400
   # socket 接收缓冲区打小
   socket.receive.buffer.bytes=102400
   # 请求 socket 最大字节
   socket.request.max.bytes=104857600
   
   # kafka 运行时数据存储地址
   log.dirs=/opt/modules/kafka/data
   
   # topic在当前 broker 的分区个数
   num.partitions=1
   # 用于恢复清理data 下数据的线程个数
   num.recovery.threads.per.data.dir=1
   # segment文件保存的最长时间
   log.retention.hours=168
   #zookeeper 环境地址
   zookeeper.connect=172.16.235.166:2181,172.16.235.167:2181,172.16.235.168:2181
   ```

3. 分别启动每个 broker

   ```shell
   $ cd /opt/modules/kafka/bin
   $ ./kafka-server-start.sh -daemon ../config/server.properties
   ```

   