# rocketmq部署

[依赖环境](#依赖环境)

[部署服务](#部署服务)

[部署可视化-扩展](#部署可视化-扩展)

## 依赖环境

jdk1.8    

maven

unzip



## 部署服务

[download](http://rocketmq.apache.org/)

此部署安装的 4.7.1

1. 上传至服务器

   ```shell
   scp /Users/zhangchenzhao/Downloads/rocketmq-all-4.7.1-bin-release.zip root@172.16.235.171:/opt/software/
   ```

2. 解压到指定路径

   ```
   unzip rocketmq-all-4.7.1-bin-release.zip -d /opt/modules/
   cd /opt/modules/
   mv rocketmq-all-4.7.1-bin-release/ rocketmq
   ```

3. 修改broker配置

   [文档](https://github.com/apache/rocketmq/blob/master/docs/cn/best_practice.md#33-broker-%E9%85%8D%E7%BD%AE)-https://github.com/apache/rocketmq/blob/master/docs/cn/best_practice.md#33-broker-%E9%85%8D%E7%BD%AE  *(跳转注意#转义)*

   ```shell
   增加数据路径
   storePathRootDir=/opt/modules/rocketmq/store/
   storePathCommitLog=/opt/modules/rocketmq/store/commitlog/
   storePathConsumeQueue=/opt/modules/rocketmq/store/consumequeue/
   storePathIndex=/opt/modules/rocketmq/store/index/
   ```

4. 修改 runserver.sh 脚本  (视自己的服务器性能配置决定, 我这里测试虚拟机内存小, 所以设置的小)

   ```shell
   vim bin/runserver.sh
   
   #JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
   JAVA_OPT="${JAVA_OPT} -server -Xms256m -Xmx256m -Xmn128m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
   ```

5. 修改 runbroker.sh 脚本

   ```shell
   vim bin/runbroker.sh
   #JAVA_OPT="${JAVA_OPT} -server -Xms8g -Xmx8g -Xmn4g"
   JAVA_OPT="${JAVA_OPT} -server -Xms256m -Xmx256m -Xmn64m"
   ```

6. 启动 nameServer和 broker

   ```shell
   #!/bin/bash
   nohup sh /opt/modules/rocketmq/bin/mqnamesrv &
   nohup sh /opt/modules/rocketmq/bin/mqbroker -n 172.16.235.171:9876 autoCreateTopicEnable=true -c /opt/modules/rocketmq/conf/broker.conf &
   ```

7. 检查服务启动

   ```shell
   jps
   22009 NamesrvStartup
   22010 BrokerStartup
   22106 Jps
   ```



##部署可视化-扩展

[download](https://github.com/apache/rocketmq-externals)

1. 上传至服务器

   ```shell
   scp /Users/zhangchenzhao/Downloads/rocketmq-externals-master.zip root@172.16.235.171:/opt/software/
   ```

2. 解压到指定路径

   ```shell
   unzip rocketmq-externals-master.zip -d /opt/modules/
   cd /opt/modules/
   mv rocketmq-externals-master externals
   ```

3. 打包: *(打包前可以修改 application.properties中的配置, 或在启动时指定参数)*

   ```shell
   cd externals/rocketmq-console
   mvn clean package -Dmaven.skip.test=true
   ```

4. 将 jar 包放到指定路径下

   ```shell
   mkdir -d /opt/modules/rocketmq/externals/
   mv rocketmq-console-ng-2.0.0.jar /opt/modules/rocketmq/externals/
   ```

5. 启动 rocketmq-console

   ```shell
   java -jar rocketmq-console-ng-2.0.0.jar --rocketmq.config.namesrvAddr=172.16.235.171:9876
   ```

   

