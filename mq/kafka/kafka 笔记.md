# kafka 笔记

## kafka-topics.sh

1. 创建主题

   ```shell
   $ ./kafka-topic.sh --create --topic <topic-name> --zookeeper host:port --partitions 3 --replication-factor 2
   创建主题  topic-name   分区 3 个  副本 2ge
   ```

2. 查看主题列表

   ```shell
   $ ./kafka-topic.sh --list --zookeeper host:port
   ```

3. 删除主题

   ```shell
   $ ./kafka-topic.sh --delete --topic <topic-name> --zookeeper  host:port
   ```

4. 修改主题

   ```shell
   $ ./kafka-topic.sh --alter --topic <topic-name> --zookeeper host:port --replication 4
   ```

   